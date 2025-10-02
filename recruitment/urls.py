# recruitment/urls.py
from django.urls import path
from . import views

app_name = "recruitment"  # ✅ required for namespacing

urlpatterns = [
    path("", views.landing, name="landing"),
    path("login/", views.RoleBasedLoginView.as_view(), name="login"),
    path("logout/", views.logout_view, name="logout"),
    path("register/", views.register, name="register"),

    path("dashboard/", views.applicant_dashboard, name="applicant_dashboard"),

    # ✅ this is the one your template needs
    path("profile/photo/", views.profile_photo_update, name="profile_photo_update"),

    path("application/form/", views.application_form, name="application_form"),
    path("application/status/", views.application_status, name="application_status"),
    path("application/status/pdf/", views.application_status_pdf, name="application_status_pdf"),
    path("application/status/print/", views.application_status_print, name="application_status_print"),

    path("notifications/", views.notifications_list, name="notifications_list"),
    path("notifications/mark-all/", views.notifications_mark_all_seen, name="notifications_mark_all_seen"),
    path("notifications/<int:pk>/seen/", views.notification_mark_seen, name="notification_mark_seen"),

    path("interviews/", views.interview_schedule_list, name="interview_schedule_list"),
    path("tests/", views.tests_list, name="tests_list"),
    path("cycles/", views.cycles_list, name="cycles_list"),
    path("eligibility/", views.eligibility_list, name="eligibility_list"),
    path("staff/", views.staff_dashboard, name="staff_dashboard"),
]
