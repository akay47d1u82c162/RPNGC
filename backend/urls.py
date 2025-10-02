# backend/urls.py
from django.contrib import admin  # default admin (optional)
from django.urls import path, include
from recruitment.admin_site import rpngc_admin_site  # custom Jazzmin-themed site

urlpatterns = [
    path("admin_site/", rpngc_admin_site.urls),  # custom admin (your primary)
    path("admin/", admin.site.urls),            # default admin (optional / backup)
    path("", include("recruitment.urls")),
]

# (optional in dev) media/static
from django.conf import settings
from django.conf.urls.static import static
if settings.DEBUG: urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
