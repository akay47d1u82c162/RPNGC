from __future__ import annotations

from django import forms
from django.contrib import admin, messages
from django.utils.html import format_html
from django.utils.safestring import mark_safe

from .models import (
    User,
    Province, District,
    ApplicantProfile, AlternativeContact, ParentGuardian,
    EducationRecord, WorkHistory, Reference, Document,
    RecruitmentCycle, Application, ApplicationEligibility, ScreeningAction,
    Test, Question, Choice, TestAttempt, AttemptAnswer,
    InterviewSchedule, InterviewScore, FinalSelection,
    Notification, AuditLog,
)

# =============================
# Helpers & Role gating
# =============================

def _is_admin_user(user):
    """Admins/Officers (or superusers) can edit status; others view-only."""
    if user.is_superuser:
        return True
    role = getattr(user, "role", None)
    try:
        return role in (User.Roles.ADMIN, User.Roles.OFFICER)
    except Exception:
        # Fallback if no roles available
        return user.is_staff

def _has_field(model, name: str) -> bool:
    return any(getattr(f, "name", None) == name for f in model._meta.get_fields())

def _table(rows):
    html = "<table style='width:100%;border-collapse:collapse'>"
    for k, v in rows:
        html += (
            "<tr>"
            f"<th style='text-align:left;padding:6px 8px;width:220px;color:#444'>{k}</th>"
            f"<td style='padding:6px 8px'>{v}</td>"
            "</tr>"
        )
    html += "</table>"
    return mark_safe(html)


# =============================
# Core / Accounts
# =============================
@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ("username", "email", "first_name", "last_name", "role", "is_staff", "is_superuser")
    list_filter = ("role", "is_staff", "is_superuser", "is_active")
    search_fields = ("username", "email", "first_name", "last_name")
    ordering = ("username",)


# =============================
# Locations
# =============================
@admin.register(Province)
class ProvinceAdmin(admin.ModelAdmin):
    list_display = ("name", "code")
    search_fields = ("name", "code")


@admin.register(District)
class DistrictAdmin(admin.ModelAdmin):
    list_display = ("name", "province")
    list_filter = ("province",)
    search_fields = ("name", "province__name", "province__code")


# =============================
# Applicant Profile & Related (LOCKED: view-only)
# =============================

@admin.register(ApplicantProfile)
class ApplicantProfileAdmin(admin.ModelAdmin):
    list_display = ("full_name", "user", "gender", "dob", "province", "district", "phone", "email")
    list_filter = ("gender", "province", "district", "highest_education_level")
    search_fields = ("full_name", "user__username", "email", "phone", "nid_number")

    def get_readonly_fields(self, request, obj=None):
        # All fields read-only
        return [f.name for f in ApplicantProfile._meta.fields]

    def has_add_permission(self, request):
        return False
    def has_change_permission(self, request, obj=None):
        return False
    def has_delete_permission(self, request, obj=None):
        return False


class _ViewOnlyAdmin(admin.ModelAdmin):
    """Base for related applicant models: read-only, no add/change/delete."""
    def get_readonly_fields(self, request, obj=None):
        return [f.name for f in self.model._meta.fields]
    def has_add_permission(self, request):
        return False
    def has_change_permission(self, request, obj=None):
        return False
    def has_delete_permission(self, request, obj=None):
        return False


@admin.register(AlternativeContact)
class AlternativeContactAdmin(_ViewOnlyAdmin):
    list_display = ("applicant", "name", "relationship", "phone")
    search_fields = ("applicant__full_name", "name", "relationship", "phone")


@admin.register(ParentGuardian)
class ParentGuardianAdmin(_ViewOnlyAdmin):
    list_display = ("applicant", "kind", "name", "is_alive")
    list_filter = ("kind", "is_alive")
    search_fields = ("applicant__full_name", "name")


@admin.register(EducationRecord)
class EducationRecordAdmin(_ViewOnlyAdmin):
    list_display = ("applicant", "level", "institution", "province", "start_year", "end_year", "gpa")
    list_filter = ("level", "province", "start_year", "end_year")
    search_fields = ("applicant__full_name", "institution", "certificate_title")


@admin.register(WorkHistory)
class WorkHistoryAdmin(_ViewOnlyAdmin):
    list_display = ("applicant", "employer", "position", "start_date", "end_date")
    list_filter = ("start_date", "end_date")
    search_fields = ("applicant__full_name", "employer", "position", "duties")


@admin.register(Reference)
class ReferenceAdmin(_ViewOnlyAdmin):
    list_display = ("applicant", "name", "position_title", "phone_number", "email")
    search_fields = ("applicant__full_name", "name", "position_title", "phone_number", "email")


@admin.register(Document)
class DocumentAdmin(_ViewOnlyAdmin):
    """Documents are view/download-only in admin."""
    list_display = ("applicant", "doc_type", "verify_status", "uploaded_at", "file_link")
    list_filter = ("doc_type", "verify_status")
    search_fields = ("applicant__full_name", "verification_note")
    autocomplete_fields = ("applicant",)

    def file_link(self, obj):
        f = getattr(obj, "file", None)
        if f:
            return format_html('<a href="{}" target="_blank" rel="noopener">Open</a>', f.url)
        return "—"
    file_link.short_description = "File"


# =============================
# Recruitment Cycles
# =============================
@admin.register(RecruitmentCycle)
class RecruitmentCycleAdmin(admin.ModelAdmin):
    list_display = ("name", "intake_year", "rec_type", "start_date", "end_date", "is_active")
    list_filter = ("rec_type", "is_active", "intake_year")
    search_fields = ("name",)
    date_hierarchy = "start_date"


# =============================
# Applications (Inline status update + one-screen review + notify on change)
# =============================

class ApplicationDecisionForm(forms.ModelForm):
    # Non-model field to include a note in the applicant Notification (used on detail page)
    decision_note = forms.CharField(
        label="Decision note (sent to applicant)",
        required=False,
        widget=forms.Textarea(attrs={"rows": 3, "style": "resize:vertical;"}),
        help_text="Optional message included in the applicant notification."
    )

    class Meta:
        model = Application
        fields = ("status",)  # Only editable model field

@admin.register(Application)
class ApplicationAdmin(admin.ModelAdmin):
    form = ApplicationDecisionForm

    # --- LIST PAGE: keep it static so system checks pass ---
    list_display = ("id", "applicant", "cycle", "status")   # <-- include 'status' here
    list_editable = ("status",)                              # inline-editable now valid
    list_display_links = ("id", "applicant", "cycle")
    list_filter = ("status", "cycle__intake_year", "cycle__rec_type", "eligibility_passed")
    search_fields = ("applicant__full_name", "cycle__name")
    autocomplete_fields = ("applicant", "cycle")
    ordering = ("-id",)
    actions = None

    # (remove your get_list_display override entirely)

    # --- DETAIL PAGE (unchanged) ---
    BASE_SECTIONS = ("_applicant_info", "_application_info", "_documents_list", "_timeline")
    def get_fields(self, request, obj=None):
        fields = ["status", "decision_note", *self.BASE_SECTIONS]
        # add optional read-only timestamps if your model has them
        for name in ("submitted_at", "updated_at"):
            if _has_field(Application, name):
                fields.append(name)
        for name in ("applicant", "cycle"):
            if _has_field(Application, name):
                fields.append(name)
        return tuple(fields)

    def get_readonly_fields(self, request, obj=None):
        ro = set(self.BASE_SECTIONS)
        for f in Application._meta.fields:
            ro.add(f.name)
        ro.discard("status")
        valid = set(self.BASE_SECTIONS) | {f.name for f in Application._meta.fields}
        return tuple(n for n in ro if n in valid)

    def has_add_permission(self, request): return False
    def has_delete_permission(self, request, obj=None): return False
    def has_change_permission(self, request, obj=None): return _is_admin_user(request.user)

    # ... keep your composed sections (_applicant_info/_application_info/_documents_list/_timeline)
    # ... and your save_model() that creates Notification (+optional ScreeningAction) on status change

    # ---------- READ-ONLY COMPOSED SECTIONS ----------
    @admin.display(description="Applicant")
    def _applicant_info(self, obj: Application):
        p = obj.applicant
        u = getattr(p, "user", None)
        rows = [
            ("Full name", getattr(p, "full_name", "—")),
            ("Email", getattr(u, "email", "—") if u else "—"),
            ("DOB", getattr(p, "dob", "—")),
            ("Gender", p.get_gender_display() if hasattr(p, "get_gender_display") else getattr(p, "gender", "—")),
            ("Highest education", p.get_highest_education_level_display() if hasattr(p, "get_highest_education_level_display") else getattr(p, "highest_education_level", "—")),
            ("NID", getattr(p, "nid_number", "—") or "—"),
            ("Phone", getattr(p, "phone", "—") or "—"),
            ("Address", getattr(p, "address", "—") or "—"),
            ("Province", getattr(p, "province", "—") or "—"),
            ("District", getattr(p, "district", "—") or "—"),
        ]
        return _table(rows)

    @admin.display(description="Application")
    def _application_info(self, obj: Application):
        rows = [
            ("Cycle", str(getattr(obj, "cycle", "—"))),
            ("Status", obj.get_status_display() if hasattr(obj, "get_status_display") else getattr(obj, "status", "—")),
        ]
        for name in ("submitted_at", "updated_at", "auto_screen_score", "manual_adjustment", "test_score", "interview_score", "total_score", "eligibility_passed"):
            if _has_field(Application, name):
                rows.append((name.replace("_", " ").title(), getattr(obj, name, "—") or "—"))
        return _table(rows)

    @admin.display(description="Documents")
    def _documents_list(self, obj: Application):
        docs = Document.objects.filter(applicant=obj.applicant).order_by("doc_type")
        if not docs.exists():
            return mark_safe("<p>No documents uploaded.</p>")
        items = []
        for d in docs:
            label = d.get_doc_type_display() if hasattr(d, "get_doc_type_display") else str(getattr(d, "doc_type", "Document"))
            f = getattr(d, "file", None)
            link = format_html('<a href="{}" target="_blank" rel="noopener">Open</a>', f.url) if f else "—"
            items.append(f"<li><strong>{label}</strong> — {link}</li>")
        return mark_safe("<ul style='margin:0;padding-left:16px'>" + "".join(items) + "</ul>")

    @admin.display(description="Timeline")
    def _timeline(self, obj: Application):
        try:
            qs = ScreeningAction.objects.filter(application=obj).select_related("by_user").order_by("created_at")
        except Exception:
            return mark_safe("<p>Timeline not available.</p>")
        if not qs.exists():
            return mark_safe("<p>No recorded actions yet.</p>")
        lis = []
        for a in qs:
            by = a.by_user.get_full_name() or a.by_user.username if getattr(a, "by_user_id", None) else "—"
            note = f"<div style='color:#555;margin-top:4px'>{getattr(a,'reason','')}</div>" if getattr(a, "reason", "") else ""
            lis.append(f"<li><strong>{by}</strong> <span style='color:#666'>({a.created_at:%Y-%m-%d %H:%M})</span>{note}</li>")
        return mark_safe("<ul style='margin:0;padding-left:16px'>" + "".join(lis) + "</ul>")

    # ---------- NOTIFY ON STATUS CHANGE (works for list and detail) ----------
    def save_model(self, request, obj, form, change):
        old_status = None
        if change:
            try:
                old_status = Application.objects.only("status").get(pk=obj.pk).status
            except Application.DoesNotExist:
                pass

        super().save_model(request, obj, form, change)

        if old_status and obj.status != old_status:
            note = ""
            if hasattr(form, "cleaned_data"):
                note = form.cleaned_data.get("decision_note", "") or ""

            # optional timeline row
            try:
                ScreeningAction.objects.create(
                    application=obj,
                    by_user=request.user,
                    reason=note,
                )
            except Exception:
                pass

            # notify applicant
            try:
                kwargs = dict(
                    user=obj.applicant.user,
                    title="Application status updated",
                    body=f"Your application for {obj.cycle} is now "
                         f"'{obj.get_status_display() if hasattr(obj,'get_status_display') else obj.status}'. "
                         f"{('Note: ' + note) if note else ''}",
                )
                if _has_field(Notification, "ntype"):
                    kwargs["ntype"] = "STATUS"
                if _has_field(Notification, "is_read"):
                    kwargs["is_read"] = False
                elif _has_field(Notification, "seen"):
                    kwargs["seen"] = False
                Notification.objects.create(**kwargs)
            except Exception:
                pass

            messages.success(request, "Status updated and applicant notified.")


# =============================
# Eligibility & Screening
# =============================
@admin.register(ApplicationEligibility)
class ApplicationEligibilityAdmin(admin.ModelAdmin):
    list_display = ("application", "result", "age_ok", "education_ok", "medical_ok", "police_ok", "run_at")
    list_filter = ("result", "age_ok", "education_ok", "medical_ok", "police_ok")
    search_fields = ("application__applicant__full_name",)


@admin.register(ScreeningAction)
class ScreeningActionAdmin(admin.ModelAdmin):
    """Make timeline viewable but not editable to avoid backdoor CRUD on applicant flow."""
    list_display = ("application", "auto_score", "manual_adjustment", "by_user", "created_at")
    list_filter = ("created_at",)
    search_fields = ("application__applicant__full_name", "reason")
    autocomplete_fields = ("application", "by_user")

    def get_readonly_fields(self, request, obj=None):
        return [f.name for f in ScreeningAction._meta.fields]

    def has_add_permission(self, request):
        return False
    def has_change_permission(self, request, obj=None):
        return False
    def has_delete_permission(self, request, obj=None):
        return False


# =============================
# Tests & Questions
# =============================
class ChoiceInline(admin.TabularInline):
    model = Choice
    extra = 0


@admin.register(Test)
class TestAdmin(admin.ModelAdmin):
    list_display = ("name", "cycle", "opens_at", "closes_at", "is_published", "max_score", "max_attempts")
    list_filter = ("is_published", "cycle__intake_year")
    search_fields = ("name", "cycle__name")
    autocomplete_fields = ("cycle",)
    date_hierarchy = "opens_at"


@admin.register(Question)
class QuestionAdmin(admin.ModelAdmin):
    list_display = ("test", "order", "points")
    list_filter = ("test",)
    search_fields = ("test__name", "text")
    autocomplete_fields = ("test",)
    inlines = [ChoiceInline]


@admin.register(Choice)
class ChoiceAdmin(admin.ModelAdmin):
    list_display = ("question", "text", "is_correct")
    list_filter = ("is_correct",)
    search_fields = ("question__test__name", "text")
    autocomplete_fields = ("question",)


@admin.register(TestAttempt)
class TestAttemptAdmin(admin.ModelAdmin):
    list_display = ("test", "application", "status", "started_at", "submitted_at", "score")
    list_filter = ("status", "started_at", "submitted_at")
    search_fields = ("test__name", "application__applicant__full_name")
    autocomplete_fields = ("test", "application")


@admin.register(AttemptAnswer)
class AttemptAnswerAdmin(admin.ModelAdmin):
    list_display = ("attempt", "question", "selected_choice", "is_correct", "awarded_points")
    list_filter = ("is_correct",)
    search_fields = ("attempt__test__name", "question__text")
    autocomplete_fields = ("attempt", "question", "selected_choice")


# =============================
# Interviews & Selection
# =============================
@admin.register(InterviewSchedule)
class InterviewScheduleAdmin(admin.ModelAdmin):
    list_display = ("application", "scheduled_at", "location", "panel_name", "status", "created_by")
    list_filter = ("status", "scheduled_at")
    search_fields = (
        "panel_name",
        "location",
        "application__applicant__full_name",
        "application__cycle__name",
    )
    autocomplete_fields = ("application", "created_by")
    date_hierarchy = "scheduled_at"


@admin.register(InterviewScore)
class InterviewScoreAdmin(admin.ModelAdmin):
    list_display = ("schedule", "interviewer", "score", "created_at")
    list_filter = ("created_at",)
    search_fields = ("schedule__panel_name", "interviewer__username")
    autocomplete_fields = ("schedule", "interviewer")


@admin.register(FinalSelection)
class FinalSelectionAdmin(admin.ModelAdmin):
    list_display = ("application", "rank", "total_score_snapshot", "approved_by", "approved_at", "is_published")
    list_filter = ("is_published",)
    search_fields = ("application__applicant__full_name",)
    autocomplete_fields = ("application", "approved_by")


# =============================
# Notifications & Audit
# =============================
@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display = ("user", "ntype", "title", "is_read", "created_at")
    list_filter = ("ntype", "is_read", "created_at")
    search_fields = ("user__username", "title", "body")
    autocomplete_fields = ("user",)


@admin.register(AuditLog)
class AuditLogAdmin(admin.ModelAdmin):
    list_display = ("actor", "action", "entity", "entity_id", "ip_address", "created_at")
    list_filter = ("action", "created_at")
    search_fields = ("actor__username", "entity", "entity_id", "ip_address")
    autocomplete_fields = ("actor",)
