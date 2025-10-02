# recruitment/admin.py
from __future__ import annotations

from django.contrib import admin, messages
from django.contrib.auth.admin import UserAdmin as DjangoUserAdmin
from django.urls import reverse
from django.utils.html import format_html
from django.db import transaction  # <-- for safe savepoint around notifications

from .admin_site import rpngc_admin_site
from .models import (
    User,
    Province, District,
    ApplicantProfile, ParentGuardian,
    RecruitmentCycle, Application, ApplicationEligibility, ScreeningAction,
    AlternativeContact, EducationRecord, WorkHistory, Reference, Document,
    Test, Question, Choice, TestAttempt, AttemptAnswer,
    InterviewSchedule, InterviewScore,
    FinalSelection, Notification, AuditLog,
    run_automated_eligibility,
)

# ---------------------------------------------------------------------
# Generic read-only helpers
# ---------------------------------------------------------------------
def _all_readonly_field_names(model):
    names = [f.name for f in model._meta.fields]
    names += [m.name for m in model._meta.many_to_many]
    return names

class ReadOnlyModelAdmin(admin.ModelAdmin):
    """Completely view-only (no add/delete; fields read-only)."""
    def has_add_permission(self, request): return False
    def has_delete_permission(self, request, obj=None): return False
    def get_readonly_fields(self, request, obj=None):
        return _all_readonly_field_names(self.model)

class StrictReadOnlyModelAdmin(ReadOnlyModelAdmin):
    """View-only AND no change view."""
    def has_change_permission(self, request, obj=None): return False

class ReadOnlyTabularInline(admin.TabularInline):
    """Inline that is read-only."""
    can_delete = False
    extra = 0
    def has_add_permission(self, request, obj=None): return False
    def has_change_permission(self, request, obj=None): return False
    def get_readonly_fields(self, request, obj=None):
        return _all_readonly_field_names(self.model)

# ---------------------------------------------------------------------
# Users
# ---------------------------------------------------------------------
@admin.register(User, site=rpngc_admin_site)
class UserAdmin(DjangoUserAdmin):
    pass

# ---------------------------------------------------------------------
# Lookups
# ---------------------------------------------------------------------
@admin.register(Province, site=rpngc_admin_site)
class ProvinceAdmin(admin.ModelAdmin):
    list_display = ("id", "name", "code")
    search_fields = ("name", "code")
    ordering = ("name",)

@admin.register(District, site=rpngc_admin_site)
class DistrictAdmin(admin.ModelAdmin):
    list_display = ("id", "name", "province")
    list_filter = ("province",)
    search_fields = ("name", "province__name", "province__code")
    autocomplete_fields = ("province",)
    ordering = ("province__name", "name")

# ---------------------------------------------------------------------
# Applicant (VIEW ONLY)
# ---------------------------------------------------------------------
class ParentGuardianReadOnlyInline(ReadOnlyTabularInline):
    model = ParentGuardian

@admin.register(ApplicantProfile, site=rpngc_admin_site)
class ApplicantProfileAdmin(ReadOnlyModelAdmin):
    list_display = ("id", "full_name", "gender", "dob", "province", "district", "phone", "email", "highest_education_level")
    list_filter = ("gender", "province", "district", "highest_education_level")
    search_fields = ("full_name", "user__username", "phone", "email")
    inlines = [ParentGuardianReadOnlyInline]
    ordering = ("full_name",)

# ---------------------------------------------------------------------
# Applications (VIEW-ONLY with inline status edit, bulk actions, notify + sync)
# ---------------------------------------------------------------------
@admin.register(Application, site=rpngc_admin_site)
class ApplicationAdmin(ReadOnlyModelAdmin):
    list_display = (
        "id", "applicant_name", "cycle", "rec_type", "status", "total_score",
        "link_documents", "link_references", "link_work", "link_education", "link_contact",
    )
    list_filter = ("status", "rec_type", ("cycle", admin.RelatedOnlyFieldListFilter))
    search_fields = ("applicant__full_name", "applicant__user__username", "cycle__name", "applied_unit")
    autocomplete_fields = ("applicant", "cycle")
    list_select_related = ("applicant", "cycle")
    ordering = ("-total_score", "id")

    # inline edit of status on changelist
    list_editable = ("status",)

    actions = [
        "run_eligibility_check",
        "mark_under_review",
        "mark_shortlisted",
        "mark_approved",
        "mark_rejected",
    ]

    @admin.display(description="Applicant")
    def applicant_name(self, obj):
        return obj.applicant.full_name

    # Quick links to related children
    def _link(self, model_key: str, label: str, obj):
        url = reverse(f"rpngc_admin:{model_key}_changelist") + f"?application__id__exact={obj.id}"
        return format_html('<a class="btn btn-sm btn-outline-primary" href="{}">{}</a>', url, label)

    @admin.display(description="Docs")
    def link_documents(self, obj):  return self._link("recruitment_document", "Documents", obj)
    @admin.display(description="Refs")
    def link_references(self, obj): return self._link("recruitment_reference", "References", obj)
    @admin.display(description="Work")
    def link_work(self, obj):       return self._link("recruitment_workhistory", "Work", obj)
    @admin.display(description="Edu")
    def link_education(self, obj):  return self._link("recruitment_educationrecord", "Education", obj)
    @admin.display(description="Alt Contact")
    def link_contact(self, obj):    return self._link("recruitment_alternativecontact", "Alt Contact", obj)

    # Everything read-only except 'status'
    def get_readonly_fields(self, request, obj=None):
        ro = set(_all_readonly_field_names(self.model))
        ro.discard("status")
        return list(ro)

    # ---- eligibility action (kept) ----
    @admin.action(description="Re-run eligibility check")
    def run_eligibility_check(self, request, queryset):
        count = 0
        for app in queryset:
            run_automated_eligibility(app)
            count += 1
        self.message_user(request, f"Eligibility re-evaluated for {count} application(s).", level=messages.SUCCESS)

    # -------- status + notifications wiring --------
    def _resolve_status(self, name: str):
        Status = getattr(Application, "Status", None)
        if Status and hasattr(Status, name):
            return getattr(Status, name)
        return name.lower()

    def _fit_field(self, model_cls, field_name: str, value):
        """
        Truncate string 'value' to the max_length of model.field_name if present.
        """
        try:
            field = model_cls._meta.get_field(field_name)
            max_len = getattr(field, "max_length", None)
            if max_len and isinstance(value, str) and len(value) > max_len:
                return value[:max_len]
        except Exception:
            pass
        return value

    def _sync_applicant_status(self, app):
        """Keep ApplicantProfile's status aligned, if such a field exists."""
        prof = getattr(app, "applicant", None)
        if not prof:
            return
        for field in ("application_status", "status"):
            if hasattr(prof, field):
                try:
                    setattr(prof, field, app.status)
                    prof.save(update_fields=[field])
                except Exception:
                    pass
                break

    def _notify_status_change(self, request, app, old_status, new_status):
        """Create a Notification without breaking the surrounding admin transaction."""
        try:
            user = getattr(getattr(app, "applicant", None), "user", None)
            if not user:
                return
            # Build safe payload respecting field lengths (esp. ntype)
            title = "Application status updated"
            body = f"Your application (ID {app.id}) is now {new_status}."
            ntype_value = "application_status"  # may exceed DB; we'll fit it

            kwargs = {"user": user}
            if hasattr(Notification, "title"):
                kwargs["title"] = self._fit_field(Notification, "title", title)
            if hasattr(Notification, "body"):
                kwargs["body"] = body  # usually TextField; leave as is
            if hasattr(Notification, "ntype"):
                kwargs["ntype"] = self._fit_field(Notification, "ntype", ntype_value)
            if hasattr(Notification, "is_read"):
                kwargs["is_read"] = False

            # Isolate in a savepoint so errors don't poison the admin transaction
            with transaction.atomic():
                Notification.objects.create(**kwargs)
        except Exception:
            # swallow — notifications are best-effort
            pass

    def _set_status_with_side_effects(self, request, app, new_value):
        old = app.status
        if old == new_value:
            return False
        app.status = new_value
        app.save(update_fields=["status"])
        self._sync_applicant_status(app)
        self._notify_status_change(request, app, old_status=old, new_status=new_value)
        return True

    # ---- approval/status bulk actions ----
    def _bulk_set_status(self, request, queryset, status_name: str, success_msg: str, level=messages.SUCCESS):
        new_value = self._resolve_status(status_name)
        updated = 0
        for app in queryset.select_related("applicant__user"):
            if self._set_status_with_side_effects(request, app, new_value):
                updated += 1
        if updated:
            self.message_user(request, f"{success_msg} {updated} application(s).", level=level)
        else:
            self.message_user(request, "No applications required updating.", level=messages.INFO)

    @admin.action(description="Set status → UNDER_REVIEW")
    def mark_under_review(self, request, queryset):
        self._bulk_set_status(request, queryset, "UNDER_REVIEW", "Moved to UNDER_REVIEW:")

    @admin.action(description="Set status → SHORTLISTED")
    def mark_shortlisted(self, request, queryset):
        self._bulk_set_status(request, queryset, "SHORTLISTED", "Shortlisted:")

    @admin.action(description="Set status → APPROVED")
    def mark_approved(self, request, queryset):
        self._bulk_set_status(request, queryset, "APPROVED", "Approved:")

    @admin.action(description="Set status → REJECTED")
    def mark_rejected(self, request, queryset):
        self._bulk_set_status(request, queryset, "REJECTED", "Rejected:", level=messages.WARNING)

    # Ensure inline (list_editable) status changes also trigger notifications/sync
    def save_model(self, request, obj, form, change):
        if change and "status" in getattr(form, "changed_data", []):
            try:
                old = type(obj).objects.only("status").get(pk=obj.pk).status
            except type(obj).DoesNotExist:
                old = None
            super().save_model(request, obj, form, change)
            self._sync_applicant_status(obj)
            if old != obj.status:
                self._notify_status_change(request, obj, old_status=old, new_status=obj.status)
            return
        super().save_model(request, obj, form, change)

# ---------------------------------------------------------------------
# Eligibility record (VIEW ONLY)
# ---------------------------------------------------------------------
@admin.register(ApplicationEligibility, site=rpngc_admin_site)
class ApplicationEligibilityAdmin(ReadOnlyModelAdmin):
    list_display = ("application", "result", "age_ok", "education_ok", "medical_ok", "police_ok", "duplicates_ok", "run_at")
    list_filter = ("result", "age_ok", "education_ok", "medical_ok", "police_ok", "duplicates_ok")
    autocomplete_fields = ("application",)
    search_fields = ("application__applicant__full_name",)
    ordering = ("-run_at",)

# ---------------------------------------------------------------------
# Screening actions (log of manual adjustments etc.)
# ---------------------------------------------------------------------
@admin.register(ScreeningAction, site=rpngc_admin_site)
class ScreeningActionAdmin(admin.ModelAdmin):
    list_display = ("id", "application", "auto_score", "manual_adjustment", "by_user", "created_at")
    list_filter = ("by_user", "created_at")
    search_fields = ("application__applicant__full_name", "reason")
    autocomplete_fields = ("application", "by_user")
    readonly_fields = ("created_at",)

# ---------------------------------------------------------------------
# Application Children (VIEW ONLY) — except Documents (verification)
# ---------------------------------------------------------------------
@admin.register(AlternativeContact, site=rpngc_admin_site)
class AlternativeContactAdmin(ReadOnlyModelAdmin):
    list_display = ("application", "name", "relationship", "phone")
    search_fields = ("name", "phone", "application__applicant__full_name")
    autocomplete_fields = ("application",)

@admin.register(EducationRecord, site=rpngc_admin_site)
class EducationRecordAdmin(ReadOnlyModelAdmin):
    list_display = ("application", "level", "institution", "province", "start_year", "end_year")
    list_filter = ("level", "province")
    search_fields = ("institution", "certificate_title", "application__applicant__full_name")
    autocomplete_fields = ("application", "province")

@admin.register(WorkHistory, site=rpngc_admin_site)
class WorkHistoryAdmin(ReadOnlyModelAdmin):
    list_display = ("application", "employer", "position", "start_date", "end_date")
    list_filter = ("start_date", "end_date")
    search_fields = ("employer", "position", "duties", "application__applicant__full_name")
    autocomplete_fields = ("application",)

@admin.register(Reference, site=rpngc_admin_site)
class ReferenceAdmin(ReadOnlyModelAdmin):
    list_display = ("application", "name", "position_title", "phone_number", "email")
    search_fields = ("name", "position_title", "phone_number", "email", "application__applicant__full_name")
    autocomplete_fields = ("application",)

# Documents — verification allowed (approve/reject), no add/delete
@admin.register(Document, site=rpngc_admin_site)
class DocumentAdmin(admin.ModelAdmin):
    list_display = ("id", "application", "doc_type", "verify_status", "uploaded_at")
    list_filter = ("doc_type", "verify_status", "uploaded_at")
    search_fields = ("application__applicant__full_name",)
    autocomplete_fields = ("application",)
    list_editable = ("verify_status",)
    fields = ("application", "doc_type", "file", "uploaded_at", "verify_status", "verification_note", "verified_by")
    readonly_fields = ("application", "doc_type", "file", "uploaded_at", "verified_by")
    actions = ["mark_docs_approved", "mark_docs_rejected"]

    def has_add_permission(self, request): return False
    def has_delete_permission(self, request, obj=None): return False

    def save_model(self, request, obj, form, change):
        if "verify_status" in form.changed_data:
            obj.verified_by = request.user
        super().save_model(request, obj, form, change)

    @admin.action(description="Mark selected as APPROVED")
    def mark_docs_approved(self, request, queryset):
        updated = queryset.update(verify_status=Document.VerifyStatus.APPROVED, verified_by=request.user)
        self.message_user(request, f"Approved {updated} document(s).", level=messages.SUCCESS)

    @admin.action(description="Mark selected as REJECTED")
    def mark_docs_rejected(self, request, queryset):
        updated = queryset.update(verify_status=Document.VerifyStatus.REJECTED, verified_by=request.user)
        self.message_user(request, f"Rejected {updated} document(s).", level=messages.WARNING)

# ---------------------------------------------------------------------
# Recruitment cycles & assessments
# ---------------------------------------------------------------------
@admin.register(RecruitmentCycle, site=rpngc_admin_site)
class RecruitmentCycleAdmin(admin.ModelAdmin):
    list_display = ("id", "name", "intake_year", "rec_type", "start_date", "end_date", "is_active", "min_age", "max_age", "min_education_level")
    list_filter = ("rec_type", "is_active", "intake_year", "start_date")
    search_fields = ("name", "intake_year")
    autocomplete_fields = ("created_by",)
    date_hierarchy = "start_date"
    readonly_fields = ("created_at",)

@admin.register(Test, site=rpngc_admin_site)
class TestAdmin(admin.ModelAdmin):
    list_display = ("id", "name", "cycle", "opens_at", "closes_at", "is_published")
    list_filter = ("is_published", "cycle")
    search_fields = ("name", "cycle__name")
    autocomplete_fields = ("cycle",)
    date_hierarchy = "opens_at"

@admin.register(Question, site=rpngc_admin_site)
class QuestionAdmin(admin.ModelAdmin):
    list_display = ("id", "test", "order", "points_short", "text_short")
    list_filter = ("test",)
    search_fields = ("text", "test__name")
    autocomplete_fields = ("test",)
    ordering = ("test", "order")

    @admin.display(description="Points")
    def points_short(self, obj): return obj.points

    @admin.display(description="Question")
    def text_short(self, obj):
        return (obj.text[:80] + "…") if len(obj.text) > 80 else obj.text

@admin.register(Choice, site=rpngc_admin_site)
class ChoiceAdmin(admin.ModelAdmin):
    list_display = ("id", "question_short", "is_correct")
    list_filter = ("is_correct",)
    search_fields = ("text", "question__text", "question__test__name")
    autocomplete_fields = ("question",)

    @admin.display(description="Question")
    def question_short(self, obj):
        return (obj.question.text[:60] + "…") if len(obj.question.text) > 60 else obj.question.text

@admin.register(TestAttempt, site=rpngc_admin_site)
class TestAttemptAdmin(admin.ModelAdmin):
    list_display = ("id", "test", "application", "status", "score", "started_at", "submitted_at")
    list_filter = ("status", "test")
    search_fields = ("application__applicant__full_name", "test__name")
    autocomplete_fields = ("test", "application")
    date_hierarchy = "started_at"

# Attempt answers — STRICT VIEW-ONLY (no add/delete/change)
@admin.register(AttemptAnswer, site=rpngc_admin_site)
class AttemptAnswerAdmin(StrictReadOnlyModelAdmin):
    list_display = ("id", "attempt", "question", "selected_choice", "is_correct", "awarded_points")
    list_filter = ("is_correct",)
    search_fields = ("attempt__test__name", "question__text", "selected_choice__text", "attempt__application__applicant__full_name")
    autocomplete_fields = ("attempt", "question", "selected_choice")

# ---------------------------------------------------------------------
# Interviews & final selection
# ---------------------------------------------------------------------
@admin.register(InterviewSchedule, site=rpngc_admin_site)
class InterviewScheduleAdmin(admin.ModelAdmin):
    list_display = ("id", "application", "scheduled_at", "location", "panel_name", "status", "created_by")
    list_filter = ("status", "scheduled_at", "created_by")
    search_fields = ("application__applicant__full_name", "location", "panel_name")
    autocomplete_fields = ("application", "created_by")
    date_hierarchy = "scheduled_at"

@admin.register(InterviewScore, site=rpngc_admin_site)
class InterviewScoreAdmin(admin.ModelAdmin):
    list_display = ("id", "schedule", "interviewer", "score", "created_at")
    list_filter = ("interviewer",)
    search_fields = ("schedule__application__applicant__full_name", "interviewer__username", "interviewer__first_name", "interviewer__last_name")
    autocomplete_fields = ("schedule", "interviewer")
    readonly_fields = ("created_at",)

@admin.register(FinalSelection, site=rpngc_admin_site)
class FinalSelectionAdmin(admin.ModelAdmin):
    list_display = ("id", "application", "rank", "total_score_snapshot", "approved_by", "approved_at", "is_published")
    list_filter = ("is_published",)
    search_fields = ("application__applicant__full_name",)
    autocomplete_fields = ("application", "approved_by")
    readonly_fields = ("approved_at",)

# ---------------------------------------------------------------------
# Notifications & audit
# ---------------------------------------------------------------------
@admin.register(Notification, site=rpngc_admin_site)
class NotificationAdmin(admin.ModelAdmin):
    list_display = ("id", "user", "ntype", "title", "is_read", "created_at")
    list_filter = ("ntype", "is_read", "created_at")
    search_fields = ("title", "body", "user__username", "user__first_name", "user__last_name")
    autocomplete_fields = ("user",)
    readonly_fields = ("created_at",)

@admin.register(AuditLog, site=rpngc_admin_site)
class AuditLogAdmin(ReadOnlyModelAdmin):
    list_display = ("id", "created_at", "actor", "action", "entity", "entity_id", "ip_address")
    list_filter = ("action", "created_at")
    search_fields = ("actor__username", "entity", "entity_id", "ip_address")
    autocomplete_fields = ("actor",)
    ordering = ("-created_at",)
