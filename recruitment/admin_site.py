# recruitment/admin_site.py
try:
    from jazzmin.admin import JazzminAdminSite as BaseAdminSite
except Exception:
    from django.contrib.admin import AdminSite as BaseAdminSite

from django.utils import timezone
from datetime import timedelta


class RPNGCAdminSite(BaseAdminSite):
    site_header = "RPNGC"
    site_title = "RPNGC Admin"
    index_title = "Recruitment Administration"

    # point to our custom templates
    index_template = "recruitment/admin/index.html"
    app_index_template = "recruitment/admin/app_index.html"

    def index(self, request, extra_context=None):
        # Lazy imports to avoid circulars at import time
        from .models import (
            ApplicantProfile, Application, RecruitmentCycle, Document, InterviewSchedule
        )
        from django.db.models import Q

        now = timezone.now()
        in_7d = now + timedelta(days=7)

        stats = {
            "applicants_count": ApplicantProfile.objects.count(),
            "applications_count": Application.objects.count(),
            "pending_count": Application.objects.filter(
                Q(status=Application.Status.PENDING) | Q(status=Application.Status.SCREENING)
            ).count(),
            "shortlisted_count": Application.objects.filter(status=Application.Status.SHORTLISTED).count(),
            "active_cycles_count": RecruitmentCycle.objects.filter(is_active=True).count(),
            "docs_pending_count": Document.objects.filter(verify_status=Document.VerifyStatus.PENDING).count(),
            "interviews_week_count": InterviewSchedule.objects.filter(
                scheduled_at__gte=now, scheduled_at__lte=in_7d
            ).count(),
        }

        # Lists for dashboard widgets
        active_cycles = RecruitmentCycle.objects.filter(is_active=True).order_by("-intake_year", "-start_date")[:6]
        recent_apps = Application.objects.exclude(submitted_at__isnull=True).order_by("-submitted_at")\
                                         .select_related("applicant", "cycle")[:10]
        pending_docs = Document.objects.filter(verify_status=Document.VerifyStatus.PENDING)\
                                       .select_related("application__applicant")\
                                       .order_by("-uploaded_at")[:10]
        upcoming_interviews = InterviewSchedule.objects.filter(scheduled_at__gte=now)\
                                                       .select_related("application__applicant")\
                                                       .order_by("scheduled_at")[:8]

        context = {
            "stats": stats,
            "active_cycles": active_cycles,
            "recent_apps": recent_apps,
            "pending_docs": pending_docs,
            "upcoming_interviews": upcoming_interviews,
        }
        if extra_context:
            context.update(extra_context)
        return super().index(request, extra_context=context)


rpngc_admin_site = RPNGCAdminSite(name="rpngc_admin")
