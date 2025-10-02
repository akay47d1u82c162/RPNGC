# recruitment/views.py
from __future__ import annotations

from datetime import date
from functools import wraps
from typing import Optional, Dict, Any

from django import forms
from django.contrib import messages
from django.contrib.auth import get_user_model, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import AuthenticationForm, UserCreationForm
from django.contrib.auth.views import LoginView
from django.contrib.admin.views.decorators import staff_member_required
from django.db import transaction
from django.http import HttpRequest, HttpResponse
from django.shortcuts import get_object_or_404, redirect, render
from django.urls import reverse
from django.utils import timezone
from django.views.decorators.http import require_GET, require_http_methods, require_POST

from .models import (
    ApplicantProfile,
    Application,
    RecruitmentCycle,
    InterviewSchedule,
    Notification,
    ScreeningAction,
    Test,
    ApplicationEligibility,
    run_automated_eligibility,
)

from .forms import (
    RoleBasedLoginForm,
    ApplicantProfileForm,
    ApplicationForm,
    AlternativeContactFormSet,
    EducationRecordFormSet,
    WorkHistoryFormSet,
    ReferenceFormSet,
)

# ------------------------- Guards & helpers ------------------------- #

def is_applicant(user) -> bool:
    """True only for real applicants (non-staff) with an ApplicantProfile (and, if present, APPLICANT role)."""
    # If you're staff/superuser, you're not an applicant.
    if getattr(user, "is_staff", False) or getattr(user, "is_superuser", False):
        return False
    # If you use a custom role enum, enforce it when available.
    try:
        Roles = user.__class__.Roles
        if hasattr(Roles, "APPLICANT") and getattr(user, "role", None) != Roles.APPLICANT:
            return False
    except Exception:
        pass
    # Must have a linked profile to be treated as an applicant.
    return hasattr(user, "profile")

def applicant_required(view_func):
    """Deny staff/superusers (and non-applicants) from applicant pages; redirect to admin site."""
    @wraps(view_func)
    @login_required
    def _wrapped(request: HttpRequest, *args, **kwargs):
        if not is_applicant(request.user):
            messages.error(request, "Staff users cannot access the applicant portal.")
            return redirect("/admin_site/")
        return view_func(request, *args, **kwargs)
    return _wrapped

def _as_local(dt):
    if not dt:
        return None
    if timezone.is_naive(dt):
        dt = timezone.make_aware(dt, timezone.get_default_timezone())
    return timezone.localtime(dt)

def _fit_field(model_cls, field_name: str, value):
    try:
        field = model_cls._meta.get_field(field_name)
        max_len = getattr(field, "max_length", None)
        if max_len and isinstance(value, str) and len(value) > max_len:
            return value[:max_len]
    except Exception:
        pass
    return value

def _notify(user, title: str, body: str, ntype: str = "app_receipt"):
    try:
        kwargs = {"user": user}
        if hasattr(Notification, "title"):
            kwargs["title"] = _fit_field(Notification, "title", title)
        if hasattr(Notification, "body"):
            kwargs["body"] = body
        if hasattr(Notification, "ntype"):
            kwargs["ntype"] = _fit_field(Notification, "ntype", ntype)
        if hasattr(Notification, "is_read"):
            kwargs["is_read"] = False
        with transaction.atomic():
            Notification.objects.create(**kwargs)
    except Exception:
        pass

# ------------------------- Auth & Landing ------------------------- #

class RoleBasedLoginView(LoginView):
    """
    Role-aware login: staff/superusers are ALWAYS sent to /admin_site/,
    applicants to their dashboard. A 'Sign in as' dropdown is supported.
    """
    template_name = "registration/login.html"
    authentication_form = RoleBasedLoginForm

    def get_form_kwargs(self):
        kwargs = super().get_form_kwargs()
        kwargs.setdefault("initial", {}).update({"login_as": self.request.session.get("login_as", "auto")})
        return kwargs

    def form_valid(self, form):
        self.request.session["login_as"] = form.cleaned_data.get("login_as") or "auto"
        return super().form_valid(form)

    def get_success_url(self) -> str:
        user = self.request.user
        chosen = self.request.session.get("login_as") or "auto"

        # Staff/superusers are restricted from applicant portal regardless of choice.
        if user.is_staff or user.is_superuser:
            return "/admin_site/"

        # If user explicitly chose applicant, honor it (still non-staff).
        if chosen == "applicant":
            try:
                return reverse("recruitment:applicant_dashboard")
            except Exception:
                return "/"

        # Panel choice goes to admin site list (if available); else admin home.
        if chosen == "panel":
            try:
                return reverse("rpngc_admin:recruitment_interviewschedule_changelist")
            except Exception:
                return "/admin_site/"

        # Auto: real applicants → applicant dashboard; others → admin.
        if is_applicant(user):
            try:
                return reverse("recruitment:applicant_dashboard")
            except Exception:
                return "/"
        return "/admin_site/"

def logout_view(request: HttpRequest) -> HttpResponse:
    logout(request)
    return redirect("recruitment:login")

@require_GET
def landing(request: HttpRequest) -> HttpResponse:
    """Public landing page with role-aware redirect for authenticated users."""
    if request.user.is_authenticated:
        if request.user.is_staff or request.user.is_superuser:
            return redirect("/admin_site/")
        if is_applicant(request.user):
            return redirect("recruitment:applicant_dashboard")
        return redirect("/admin_site/")
    return render(request, "recruitment/landing.html")

class RegistrationForm(UserCreationForm):
    email = forms.EmailField(
        required=True,
        widget=forms.EmailInput(attrs={"autocomplete": "email", "placeholder": "you@example.com"})
    )

    class Meta(UserCreationForm.Meta):
        model = get_user_model()
        fields = ("username", "email", "password1", "password2")

    def clean_email(self):
        UserModel = get_user_model()
        email = self.cleaned_data["email"].strip().lower()
        if UserModel.objects.filter(email__iexact=email).exists():
            raise forms.ValidationError("An account with this email already exists.")
        return email

    def save(self, commit: bool = True):
        UserModel = get_user_model()
        user = super().save(commit=False)
        user.email = self.cleaned_data["email"]
        if hasattr(UserModel, "Roles"):
            user.role = UserModel.Roles.APPLICANT
        if commit:
            user.save()
        return user

@require_http_methods(["GET", "POST"])
def register(request: HttpRequest) -> HttpResponse:
    if request.user.is_authenticated:
        # Staff stays restricted from applicant portal
        if request.user.is_staff or request.user.is_superuser:
            return redirect("/admin_site/")
        return redirect("recruitment:applicant_dashboard")

    form = RegistrationForm(request.POST or None)
    if request.method == "POST" and form.is_valid():
        user = form.save()
        login(request, user)
        return redirect("recruitment:applicant_dashboard")
    return render(request, "registration/register.html", {"form": form})

# ------------------------- Applicant Portal ------------------------- #

@applicant_required
def applicant_dashboard(request: HttpRequest) -> HttpResponse:
    user = request.user
    profile: Optional[ApplicantProfile] = getattr(user, "profile", None)

    application: Optional[Application] = None
    if profile:
        application = Application.objects.filter(applicant=profile).order_by("-submitted_at", "-id").first()

    application_status_display = "—"
    if application:
        try:
            application_status_display = application.get_status_display()
        except Exception:
            application_status_display = application.status or "—"

    stats: Dict[str, Any] = {
        "applications_count": Application.objects.filter(applicant=profile).count() if profile else 0,
        "pending_count": Application.objects.filter(
            applicant=profile, status__in=[Application.Status.PENDING, Application.Status.SCREENING]
        ).count() if profile else 0,
        "shortlisted_count": Application.objects.filter(
            applicant=profile, status=Application.Status.SHORTLISTED
        ).count() if profile else 0,
        "tests_available": 0,
        "upcoming_interviews": 0,
    }

    now = timezone.now()
    if application:
        stats["tests_available"] = Test.objects.filter(
            cycle=application.cycle, is_published=True, opens_at__lte=now, closes_at__gte=now
        ).count()
        stats["upcoming_interviews"] = InterviewSchedule.objects.filter(
            application__applicant=profile, scheduled_at__gte=now
        ).count()
    else:
        active = RecruitmentCycle.objects.filter(is_active=True).order_by("-start_date").first()
        if active:
            stats["tests_available"] = Test.objects.filter(
                cycle=active, is_published=True, opens_at__lte=now, closes_at__gte=now
            ).count()

    notices_qs = Notification.objects.filter(user=user).order_by("-created_at")[:15]
    notices = []
    for n in notices_qs:
        created_local = _as_local(getattr(n, "created_at", None))
        notices.append({
            "id": n.id,
            "title": getattr(n, "title", None) or "Notification",
            "body": getattr(n, "body", None) or "",
            "created_at_str": created_local.strftime("%Y-%m-%d %H:%M") if created_local else "",
            "read": getattr(n, "is_read", False),
        })
    unread_count = sum(1 for n in notices if not n["read"])

    actions = []
    if application:
        actions = list(ScreeningAction.objects.filter(application=application).order_by("-created_at")[:10])

    ctx = {
        "profile": profile,
        "application": application,
        "application_status_display": application_status_display,
        "stats": stats,
        "notices": notices,
        "unread_count": unread_count,
        "actions": actions,
    }
    return render(request, "recruitment/dashboard.html", ctx)

@require_POST
@applicant_required
def profile_photo_update(request: HttpRequest) -> HttpResponse:
    profile = get_object_or_404(ApplicantProfile, user=request.user)
    file = request.FILES.get("photo")
    if not file:
        messages.error(request, "Please choose an image to upload.")
        return redirect("recruitment:applicant_dashboard")
    profile.photo = file
    profile.save(update_fields=["photo"])
    messages.success(request, "Profile photo updated.")
    return redirect("recruitment:applicant_dashboard")

@applicant_required
@require_http_methods(["GET", "POST"])
def application_form(request: HttpRequest) -> HttpResponse:
    user = request.user
    profile = getattr(user, "profile", None)
    if profile is None:
        profile = ApplicantProfile.objects.create(
            user=user,
            full_name=user.get_full_name() or user.username,
            gender=ApplicantProfile.Gender.OTHER,
            dob=date(2000, 1, 1),
        )

    application = Application.objects.filter(applicant=profile).order_by("-submitted_at", "-id").first()
    app_instance = application or Application(applicant=profile)

    if request.method == "POST":
        profile_form = ApplicantProfileForm(request.POST, request.FILES, instance=profile)
        app_form = ApplicationForm(request.POST, instance=app_instance)

        alt_formset = AlternativeContactFormSet(request.POST, instance=app_instance, prefix="alt")
        education_formset = EducationRecordFormSet(request.POST, instance=app_instance, prefix="edu")
        work_formset = WorkHistoryFormSet(request.POST, instance=app_instance, prefix="work")
        reference_formset = ReferenceFormSet(request.POST, instance=app_instance, prefix="ref")

        valid = (
            profile_form.is_valid()
            and app_form.is_valid()
            and alt_formset.is_valid()
            and education_formset.is_valid()
            and work_formset.is_valid()
            and reference_formset.is_valid()
        )

        if not valid:
            messages.error(request, "Please fix the errors below and try again.")
        else:
            profile = profile_form.save()
            app_obj: Application = app_form.save(commit=False)
            app_obj.applicant = profile

            if app_obj.cycle and app_obj.rec_type and app_obj.cycle.rec_type != app_obj.rec_type:
                app_form.add_error("rec_type", "Recruitment type must match the selected cycle’s type.")

            intent = request.POST.get("intent", "save")

            if intent == "submit":
                if not app_obj.declaration_agreed:
                    app_form.add_error("declaration_agreed", "You must agree to the declaration to submit.")
                if not app_obj.signature_name:
                    app_form.add_error("signature_name", "Signature name is required to submit.")
                if not app_obj.signature_date:
                    app_form.add_error("signature_date", "Signature date is required to submit.")

            if app_form.errors:
                pass
            else:
                if intent == "submit":
                    app_obj.status = Application.Status.PENDING
                    app_obj.submitted_at = timezone.now()
                app_obj.save()

                alt_formset.instance = app_obj
                education_formset.instance = app_obj
                work_formset.instance = app_obj
                reference_formset.instance = app_obj

                alt_formset.save()
                education_formset.save()
                work_formset.save()
                reference_formset.save()

                if intent == "submit" and app_obj.cycle_id:
                    try:
                        run_automated_eligibility(app_obj)
                    except Exception:
                        pass

                if intent == "submit":
                    try:
                        submitted_when = _as_local(app_obj.submitted_at)
                        when_str = submitted_when.strftime("%Y-%m-%d %H:%M") if submitted_when else ""
                    except Exception:
                        when_str = ""
                    try:
                        status_label = app_obj.get_status_display()
                    except Exception:
                        status_label = app_obj.status
                    _notify(
                        user,
                        "Application received",
                        f"Thank you. We've received your application (ID {app_obj.id}). "
                        f"Status: {status_label}. Submitted on {when_str}.",
                        ntype="app_receipt",
                    )
                    messages.success(request, "Application submitted. You can track the status on the status page.")
                    return redirect("recruitment:application_status")
                else:
                    messages.success(request, "Application saved as draft.")
                    return redirect("recruitment:application_form")
    else:
        profile_form = ApplicantProfileForm(instance=profile)
        app_form = ApplicationForm(instance=app_instance)
        alt_formset = AlternativeContactFormSet(instance=app_instance, prefix="alt")
        education_formset = EducationRecordFormSet(instance=app_instance, prefix="edu")
        work_formset = WorkHistoryFormSet(instance=app_instance, prefix="work")
        reference_formset = ReferenceFormSet(instance=app_instance, prefix="ref")

    active_cycle = RecruitmentCycle.objects.filter(is_active=True).order_by("-start_date").first()

    ctx = {
        "profile_form": profile_form,
        "application_form": app_form,
        "alt_contact_formset": alt_formset,
        "education_formset": education_formset,
        "work_formset": work_formset,
        "reference_formset": reference_formset,
        "active_cycle": active_cycle,
        "application": application,
        "document_rows": None,
    }
    return render(request, "recruitment/application_form.html", ctx)

@applicant_required
def application_status(request: HttpRequest) -> HttpResponse:
    profile: Optional[ApplicantProfile] = getattr(request.user, "profile", None)
    application = Application.objects.filter(applicant=profile).order_by("-submitted_at", "-id").first() if profile else None
    return render(request, "recruitment/application_status.html", {"application": application})

@applicant_required
def application_status_pdf(request: HttpRequest) -> HttpResponse:
    return HttpResponse("PDF generation not implemented.", content_type="text/plain")

@applicant_required
def application_status_print(request: HttpRequest) -> HttpResponse:
    profile: Optional[ApplicantProfile] = getattr(request.user, "profile", None)
    application = Application.objects.filter(applicant=profile).order_by("-submitted_at", "-id").first() if profile else None
    return render(request, "recruitment/application_status_print.html", {"application": application})

# ------------------------- Notifications ------------------------- #

@applicant_required
def notifications_list(request: HttpRequest) -> HttpResponse:
    notices = Notification.objects.filter(user=request.user).order_by("-created_at")[:100]
    return render(request, "recruitment/notifications.html", {"notices": notices})

@applicant_required
@require_http_methods(["POST"])
def notifications_mark_all_seen(request: HttpRequest) -> HttpResponse:
    Notification.objects.filter(user=request.user, is_read=False).update(is_read=True)
    return HttpResponse(status=204)

@applicant_required
@require_http_methods(["POST"])
def notification_mark_seen(request: HttpRequest, pk: int) -> HttpResponse:
    Notification.objects.filter(user=request.user, pk=pk).update(is_read=True)
    return HttpResponse(status=204)

# ------------------------- Simple list pages ------------------------- #

@applicant_required
def interview_schedule_list(request: HttpRequest) -> HttpResponse:
    profile: Optional[ApplicantProfile] = getattr(request.user, "profile", None)
    qs = InterviewSchedule.objects.filter(application__applicant=profile).order_by("scheduled_at") if profile else []
    return render(request, "recruitment/interviews.html", {"schedules": qs})

@applicant_required
def tests_list(request: HttpRequest) -> HttpResponse:
    profile: Optional[ApplicantProfile] = getattr(request.user, "profile", None)
    now = timezone.now()
    tests_open = []
    tests_future = []
    tests_past = []
    if profile:
        app = Application.objects.filter(applicant=profile).order_by("-submitted_at", "-id").first()
        cycle = app.cycle if app else RecruitmentCycle.objects.filter(is_active=True).order_by("-start_date").first()
        if cycle:
            qs = Test.objects.filter(cycle=cycle, is_published=True).order_by("-opens_at")
            tests_open = qs.filter(opens_at__lte=now, closes_at__gte=now)
            tests_future = qs.filter(opens_at__gt=now)
            tests_past = qs.filter(closes_at__lt=now)
    ctx = {"tests_open": tests_open, "tests_future": tests_future, "tests_past": tests_past}
    return render(request, "recruitment/tests.html", ctx)

@applicant_required
def cycles_list(request: HttpRequest) -> HttpResponse:
    qs = RecruitmentCycle.objects.order_by("-intake_year", "-start_date")
    return render(request, "recruitment/cycles.html", {"cycles": qs})

@applicant_required
def eligibility_list(request: HttpRequest) -> HttpResponse:
    profile: Optional[ApplicantProfile] = getattr(request.user, "profile", None)
    application = Application.objects.filter(applicant=profile).order_by("-submitted_at", "-id").first() if profile else None
    eligibility: Optional[ApplicationEligibility] = getattr(application, "eligibility", None) if application else None
    return render(request, "recruitment/eligibility.html", {"application": application, "eligibility": eligibility})

# ------------------------- Staff quick redirect ------------------------- #

@staff_member_required(login_url="recruitment:login")
def staff_dashboard(request: HttpRequest) -> HttpResponse:
    """Target for {% url 'recruitment:staff_dashboard' %} — always bounce to custom admin."""
    return redirect("/admin_site/")

# Alias for legacy URL wiring
def register_view(request: HttpRequest) -> HttpResponse:
    return register(request)
