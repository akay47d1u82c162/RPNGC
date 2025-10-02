from django.contrib import admin
from django.urls import path, include
from recruitment.admin_site import rpngc_admin_site  # custom Jazzmin admin

urlpatterns = [
    path("admin_site/", rpngc_admin_site.urls),  # custom Jazzmin-themed admin
    path("admin/", admin.site.urls),            # default admin (backup)
    path("", include("recruitment.urls")),      # app routes
]

# Optional in dev: serve media/static
from django.conf import settings
from django.conf.urls.static import static

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
