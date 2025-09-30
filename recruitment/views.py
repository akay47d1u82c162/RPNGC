from __future__ import annotations

from datetime import date
from django.conf import settings
from django.contrib import messages
from django.contrib.auth import login as auth_login
from django.contrib.auth.decorators import login_required
from django.contrib.auth.views import LoginView
from django.core.files.images import get_image_dimensions
from django.db import transaction
from django.http import HttpResponse, JsonResponse
from django.shortcuts import get_object_or_404, render, redirect, resolve_url
from django.template.loader import render_to_string
from django.urls import reverse
from django.utils import timezone
from django.utils.http import url_has_allowed_host_and_scheme
from django.views.decorators.http import require_POST

from .models import (
    User,
    ApplicantProfile,
    RecruitmentCycle,
    Application,
    Document,
    Notification,
)

try:
    from .models import ScreeningAction
except Exception:
    ScreeningAction = None

from .forms import (
    ApplicantRegistrationForm,
    ApplicantProfileForm,
    ApplicationForm,
    AlternativeContactFormSet,
    ParentGuardianFormSet,
    EducationRecordFormSet,
    WorkFormSet,
    ReferenceFormSet,
    DocumentUploadForm,
    REQUIRED_DOC_TYPES,
)

# -------------------------------------------------------------------
# Helpers
# -------------------------------------------------------------------
def _get_active_cycle() -> RecruitmentCycle | None:
    return RecruitmentCycle.objects.filter(is_active=True).order_by("-start_date").first()

def role_default_url(user) -> str:
    if not getattr(user, "is_authenticated", False):
        return resolve_url(settings.LOGIN_URL)
    role = getattr(user, "role", None)
    if role == User.Roles.APPLICANT:
        return reverse("recruitment:applicant_dashboard")
    if role in (User.Roles.OFFICER, User.Roles.ADMIN):
        return reverse("recruitment:staff_dashboard")
    return reverse("recruitment:applicant_dashboard")

def _get_cycle_attr(cycle, *names):
    if not cycle:
        return None
    for n in names:
        v = getattr(cycle, n, None)
        if v:
            return str(v)
    return None

def _cycle_label(cycle) -> str:
    return _get_cycle_attr(cycle, "name", "title", "label") or (str(cycle) if cycle else "—")

def _cycle_type(cycle) -> str | None:
    return _get_cycle_attr(cycle, "recruitment_type", "type", "rec_type", "category")

# -------------------------------------------------------------------
# Landing (public)
# -------------------------------------------------------------------
def landing(request):
    return render(request, "recruitment/landing.html")

# -------------------------------------------------------------------
# Auth (role-based)
# -------------------------------------------------------------------
class RoleBasedLoginView(LoginView):
    template_name = "registration/login.html"
    def get_success_url(self):
        next_url = self.get_redirect_url()
        if next_url and url_has_allowed_host_and_scheme(
            url=next_url,
            allowed_hosts={self.request.get_host()},
            require_https=self.request.is_secure(),
        ):
            return next_url
        return role_default_url(self.request.user)

def register_view(request):
    """Applicant self-registration; creates ApplicantProfile and logs in."""
    if request.user.is_authenticated:
        return redirect(role_default_url(request.user))

    if request.method == "POST":
        form = ApplicantRegistrationForm(request.POST, request.FILES)  # include FILES (photo)
        if form.is_valid():
            user = form.save()
            auth_login(request, user)
            messages.success(request, "Account created. Welcome!")
            # Go straight to the application form (prefilled from profile)
            return redirect("recruitment:application_form")
        messages.error(request, "Please correct the errors below.")
    else:
        form = ApplicantRegistrationForm()

    return render(request, "recruitment/register.html", {"form": form})

# -------------------------------------------------------------------
# Profile photo (collapsible menu upload)
# -------------------------------------------------------------------
@login_required
@require_POST
def profile_photo_update(request):
    """
    Update the applicant's profile photo from the collapsible menu.
    Accepts multipart/form-data with field name 'photo'.
    """
    profile = get_object_or_404(ApplicantProfile, user=request.user)
    file = request.FILES.get("photo")
    if not file:
        messages.error(request, "No image selected.")
        return redirect(request.META.get("HTTP_REFERER", reverse("recruitment:applicant_dashboard")))
    try:
        get_image_dimensions(file)  # raises if not image
    except Exception:
        messages.error(request, "Please upload a valid image.")
        return redirect(request.META.get("HTTP_REFERER", reverse("recruitment:applicant_dashboard")))

    profile.photo = file
    profile.save(update_fields=["photo"])

    if Notification:
        try:
            Notification.objects.create(
                user=request.user,
                ntype=getattr(Notification, "Type", None).INFO if hasattr(Notification, "Type") else "INFO",
                title="Profile photo updated",
                body="Your profile picture has been changed successfully.",
            )
        except Exception:
            pass

    messages.success(request, "Profile photo updated.")
    return redirect(request.META.get("HTTP_REFERER", reverse("recruitment:applicant_dashboard")))

# -------------------------------------------------------------------
# Applicant Dashboard
# -------------------------------------------------------------------
@login_required
def applicant_dashboard(request):
    profile = get_object_or_404(ApplicantProfile, user=request.user)

    app = (
        Application.objects.filter(applicant=profile)
        .select_related("cycle")
        .order_by("-submitted_at", "-id")
        .first()
    )

    # Notifications: normalize to common 'read' boolean
    unread_count = 0
    notices = []
    if Notification:
        qs = Notification.objects.filter(user=request.user).order_by("-created_at")
        if hasattr(Notification, "is_read"):
            unread_count = qs.filter(is_read=False).count()
        elif hasattr(Notification, "seen"):
            unread_count = qs.filter(seen=False).count()
        notices = [
            {
                "id": n.id,
                "title": getattr(n, "title", "Notification"),
                "body": getattr(n, "body", ""),
                "created_at": n.created_at,
                "read": bool(getattr(n, "is_read", getattr(n, "seen", False))),
            }
            for n in qs[:10]
        ]

    # Recent admin actions
    actions = []
    if ScreeningAction and app:
        actions = list(
            ScreeningAction.objects.filter(application=app)
            .select_related("by_user")
            .order_by("-created_at")[:10]
        )

    # Optional quick upload
    if request.method == "POST" and request.POST.get("intent") == "upload_document":
        doc_form = DocumentUploadForm(request.POST, request.FILES)
        if doc_form.is_valid():
            dtype = doc_form.cleaned_data["doc_type"]
            file = doc_form.cleaned_data["file"]
            Document.objects.update_or_create(
                applicant=profile, doc_type=dtype, defaults={"file": file}
            )
            messages.success(request, "Document uploaded.")
            return redirect("recruitment:applicant_dashboard")
    else:
        doc_form = DocumentUploadForm()

    ctx = {
        "profile": profile,
        "application": app,
        "actions": actions,
        "notices": notices,          # list of dicts with 'read'
        "unread_count": unread_count,
        "doc_form": doc_form,
        "generated_at": timezone.now(),
    }
    return render(request, "recruitment/dashboard.html", ctx)

# -------------------------------------------------------------------
# Notifications (bell)
# -------------------------------------------------------------------
@login_required
def notifications_list(request):
    if not Notification:
        return JsonResponse({"ok": False, "detail": "Notifications disabled"}, status=400)
    qs = Notification.objects.filter(user=request.user).order_by("-created_at")[:30]
    data = [
        {
            "id": n.id,
            "title": getattr(n, "title", ""),
            "body": getattr(n, "body", ""),
            "created_at": n.created_at.strftime("%Y-%m-%d %H:%M"),
            "is_read": bool(getattr(n, "is_read", getattr(n, "seen", False))),
        }
        for n in qs
    ]
    if request.headers.get("x-requested-with") == "XMLHttpRequest" or request.GET.get("format") == "json":
        return JsonResponse({"ok": True, "items": data})
    return render(request, "recruitment/notifications.html", {"items": data})

@login_required
@require_POST
def notifications_mark_all_seen(request):
    if not Notification:
        return JsonResponse({"ok": False, "detail": "Notifications disabled"}, status=400)
    if hasattr(Notification, "is_read"):
        Notification.objects.filter(user=request.user, is_read=False).update(is_read=True)
    elif hasattr(Notification, "seen"):
        Notification.objects.filter(user=request.user, seen=False).update(seen=True)
    return JsonResponse({"ok": True})

@login_required
@require_POST
def notification_mark_seen(request, pk: int):
    if not Notification:
        return JsonResponse({"ok": False, "detail": "Notifications disabled"}, status=400)
    n = get_object_or_404(Notification, pk=pk, user=request.user)
    if hasattr(n, "is_read"):
        n.is_read = True
        n.save(update_fields=["is_read"])
    elif hasattr(n, "seen"):
        n.seen = True
        n.save(update_fields=["seen"])
    return JsonResponse({"ok": True})

# -------------------------------------------------------------------
# Application Form (composite) — Save & Submit
# -------------------------------------------------------------------
@login_required
@transaction.atomic
def application_form_view(request):
    # Self-heal: ensure ApplicantProfile exists (created at registration)
    profile, _ = ApplicantProfile.objects.get_or_create(
        user=request.user,
        defaults=dict(
            full_name=(request.user.get_full_name() or request.user.username),
            dob=date(2000, 1, 1),
            gender=ApplicantProfile.Gender.OTHER,
            highest_education_level=ApplicantProfile.EducationLevel.G12,
            nid_number=None,
        ),
    )

    cycle = _get_active_cycle()
    if not cycle:
        messages.error(request, "No active recruitment cycle is currently open.")
        return redirect("recruitment:applicant_dashboard")

    application, _ = Application.objects.get_or_create(applicant=profile, cycle=cycle)
    intent = request.POST.get("intent") if request.method == "POST" else None

    if request.method == "POST":
        profile_form = ApplicantProfileForm(request.POST, request.FILES, instance=profile)
        application_form = ApplicationForm(request.POST, request.FILES, instance=application)

        has_alt = any(k.startswith("alt-") for k in request.POST.keys())
        has_par = any(k.startswith("par-") for k in request.POST.keys())

        alt_contact_formset = AlternativeContactFormSet(
            request.POST if has_alt else None, instance=profile, prefix="alt"
        )
        parent_formset = ParentGuardianFormSet(
            request.POST if has_par else None, instance=profile, prefix="par"
        )

        education_formset = EducationRecordFormSet(request.POST, instance=profile, prefix="edu")
        work_formset = WorkFormSet(request.POST, instance=profile, prefix="work")
        reference_formset = ReferenceFormSet(request.POST, instance=profile, prefix="ref")

        document_rows = []
        docs_all_valid = True
        for idx, dtype in enumerate(REQUIRED_DOC_TYPES):
            existing = Document.objects.filter(applicant=profile, doc_type=dtype).first()
            prefix = f"doc_{idx}"
            bound = DocumentUploadForm(request.POST, request.FILES, prefix=prefix, initial={"doc_type": dtype})
            if intent == "submit" and not (existing and existing.file) and not (bound.files.get(f"{prefix}-file")):
                bound.add_error("file", "This document is required to submit the application.")
                docs_all_valid = False
            document_rows.append({
                "doc_type": dtype,
                "doc_type_label": Document.DocType(dtype).label,
                "form": bound,
                "existing": existing,
            })

        all_valid = (
            profile_form.is_valid()
            and application_form.is_valid()
            and (alt_contact_formset.is_valid() if has_alt else True)
            and (parent_formset.is_valid() if has_par else True)
            and education_formset.is_valid()
            and work_formset.is_valid()
            and reference_formset.is_valid()
            and docs_all_valid
            and all(r["form"].is_valid() for r in document_rows)
        )

        if not all_valid:
            messages.error(request, "Please fix the errors below.")
            ctx = {
                "active_cycle": cycle,
                "profile_form": profile_form,
                "application_form": application_form,
                "alt_contact_formset": alt_contact_formset,
                "education_formset": education_formset,
                "work_formset": work_formset,
                "reference_formset": reference_formset,
                "document_rows": document_rows,
            }
            return render(request, "recruitment/application_form.html", ctx)

        profile_form.save()

        app = application_form.save(commit=False)
        app.applicant = profile
        app.cycle = cycle
        app.save()

        if has_alt:
            alt_contact_formset.save()
        if has_par:
            parent_formset.save()
        education_formset.save()
        work_formset.save()
        reference_formset.save()

        for row in document_rows:
            form = row["form"]
            dtype = row["doc_type"]
            if form.cleaned_data.get("file"):
                Document.objects.update_or_create(
                    applicant=profile, doc_type=dtype, defaults={"file": form.cleaned_data["file"]}
                )

        if intent == "submit":
            if not app.submitted_at:
                app.submitted_at = timezone.now()
                app.save(update_fields=["submitted_at"])
            messages.success(request, "Application submitted successfully.")
            return redirect("recruitment:application_status")

        messages.success(request, "Application saved as draft.")
        return redirect("recruitment:application_form")

    # GET — render unbound forms/sets + existing docs (prefilled via instances)
    profile_form = ApplicantProfileForm(instance=profile)
    application_form = ApplicationForm(instance=application)
    alt_contact_formset = AlternativeContactFormSet(instance=profile, prefix="alt")
    education_formset = EducationRecordFormSet(instance=profile, prefix="edu")
    work_formset = WorkFormSet(instance=profile, prefix="work")
    reference_formset = ReferenceFormSet(instance=profile, prefix="ref")

    document_rows = []
    for idx, dtype in enumerate(REQUIRED_DOC_TYPES):
        existing = Document.objects.filter(applicant=profile, doc_type=dtype).first()
        document_rows.append({
            "doc_type": dtype,
            "doc_type_label": Document.DocType(dtype).label,
            "form": DocumentUploadForm(prefix=f"doc_{idx}", initial={"doc_type": dtype}),
            "existing": existing,
        })

    ctx = {
        "active_cycle": cycle,
        "profile_form": profile_form,
        "application_form": application_form,
        "alt_contact_formset": alt_contact_formset,
        "education_formset": education_formset,
        "work_formset": work_formset,
        "reference_formset": reference_formset,
        "document_rows": document_rows,
    }
    return render(request, "recruitment/application_form.html", ctx)

# -------------------------------------------------------------------
# Application Status (+ timeline, print)
# -------------------------------------------------------------------
@login_required
def application_status_view(request):
    profile = get_object_or_404(ApplicantProfile, user=request.user)
    app = (
        Application.objects.filter(applicant=profile)
        .select_related("cycle")
        .order_by("-submitted_at", "-id")
        .first()
    )
    if not app:
        messages.info(request, "You have not created an application yet.")
        return redirect("recruitment:application_form")

    actions = []
    if ScreeningAction:
        actions = list(
            ScreeningAction.objects.filter(application=app)
            .select_related("by_user")
            .order_by("created_at")
        )
    documents = list(Document.objects.filter(applicant=profile).order_by("doc_type"))

    ctx = {
        "profile": profile,
        "app": app,
        "cycle": app.cycle,
        "actions": actions,
        "documents": documents,
        "generated_at": timezone.now(),
    }
    return render(request, "recruitment/application_status.html", ctx)

@login_required
def application_status_pdf(request):
    profile = get_object_or_404(ApplicantProfile, user=request.user)
    app = (
        Application.objects.filter(applicant=profile)
        .select_related("cycle")
        .order_by("-submitted_at", "-id")
        .first()
    )
    if not app:
        messages.info(request, "You have not created an application yet.")
        return redirect("recruitment:application_form")

    actions = []
    if ScreeningAction:
        actions = list(
            ScreeningAction.objects.filter(application=app)
            .select_related("by_user")
            .order_by("created_at")
        )
    documents = list(Document.objects.filter(applicant=profile).order_by("doc_type"))

    ctx = {
        "profile": profile,
        "app": app,
        "cycle": app.cycle,
        "actions": actions,
        "documents": documents,
        "generated_at": timezone.now(),
    }

    try:
        from weasyprint import HTML  # type: ignore
        html_str = render_to_string("recruitment/application_status_print.html", ctx)
        pdf = HTML(string=html_str, base_url=request.build_absolute_uri("/")).write_pdf()
        resp = HttpResponse(pdf, content_type="application/pdf")
        filename = f"RPNGC_Application_Status_{request.user.username}.pdf"
        resp["Content-Disposition"] = f'inline; filename="{filename}"'
        return resp
    except Exception:
        return render(request, "recruitment/application_status_print.html", ctx)

@login_required
def application_status_print(request):
    profile = get_object_or_404(ApplicantProfile, user=request.user)
    app = (
        Application.objects.filter(applicant=profile)
        .select_related("cycle")
        .order_by("-submitted_at", "-id")
        .first()
    )
    if not app:
        messages.info(request, "You have not created an application yet.")
        return redirect("recruitment:application_form")

    actions = []
    if ScreeningAction:
        actions = list(
            ScreeningAction.objects.filter(application=app)
            .select_related("by_user")
            .order_by("created_at")
        )
    documents = list(Document.objects.filter(applicant=profile).order_by("doc_type"))

    ctx = {
        "profile": profile,
        "app": app,
        "cycle": app.cycle,
        "actions": actions,
        "documents": documents,
        "generated_at": timezone.now(),
        "print_mode": True,
    }
    return render(request, "recruitment/application_status_print.html", ctx)

# -------------------------------------------------------------------
# Staff Dashboard (Admin iframe host)
# -------------------------------------------------------------------
@login_required
def staff_dashboard(request):
    if getattr(request.user, "role", None) not in (User.Roles.OFFICER, User.Roles.ADMIN):
        return redirect(role_default_url(request.user))
    return render(request, "recruitment/staff_dashboard.html")

@login_required
def interview_schedule_list(request):
    profile = get_object_or_404(ApplicantProfile, user=request.user)
    app = (
        Application.objects.filter(applicant=profile)
        .select_related("cycle")
        .order_by("-submitted_at", "-id")
        .first()
    )
    items = []
    if app:
        try:
            from .models import InterviewSchedule  # optional safety
            items = (InterviewSchedule.objects
                     .filter(application=app)
                     .select_related("application")
                     .order_by("-scheduled_at"))
        except Exception:
            items = []
    return render(request, "recruitment/interview_list.html", {
        "app": app,
        "items": items,
        "generated_at": timezone.now(),
    })


@login_required
def tests_list(request):
    profile = get_object_or_404(ApplicantProfile, user=request.user)
    cycle = _get_active_cycle()
    tests = []
    attempts_by_test = {}
    if cycle:
        try:
            from .models import Test, TestAttempt
            tests = (Test.objects
                     .filter(cycle=cycle, is_published=True)
                     .order_by("opens_at", "name"))
            attempts = (TestAttempt.objects
                        .filter(application__applicant=profile, application__cycle=cycle)
                        .select_related("test", "application"))
            attempts_by_test = {a.test_id: a for a in attempts}
        except Exception:
            tests = []
    return render(request, "recruitment/tests_list.html", {
        "cycle": cycle,
        "tests": tests,
        "attempts_by_test": attempts_by_test,
        "generated_at": timezone.now(),
    })


@login_required
def cycles_list(request):
    try:
        cycles = RecruitmentCycle.objects.all().order_by("-is_active", "-start_date")
    except Exception:
        cycles = []
    return render(request, "recruitment/cycles_list.html", {
        "cycles": cycles,
        "generated_at": timezone.now(),
    })


@login_required
def eligibility_list(request):
    profile = get_object_or_404(ApplicantProfile, user=request.user)
    app = (
        Application.objects.filter(applicant=profile)
        .select_related("cycle")
        .order_by("-submitted_at", "-id")
        .first()
    )
    rows = []
    if app:
        try:
            from .models import ApplicationEligibility
            rows = (ApplicationEligibility.objects
                    .filter(application=app)
                    .order_by("-run_at"))
        except Exception:
            rows = []
    return render(request, "recruitment/eligibility_list.html", {
        "app": app,
        "rows": rows,
        "generated_at": timezone.now(),
    })