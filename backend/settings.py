# settings.py
import os
from pathlib import Path
import dj_database_url  # ensure in requirements.txt: dj-database-url

BASE_DIR = Path(__file__).resolve().parent.parent

# ----------------------- Security / Env -----------------------
SECRET_KEY = os.environ.get("SECRET_KEY", "changeme-in-prod")
# Prefer explicit DEBUG var; e.g., set DEBUG=true locally. On Render don't set it (defaults to False).
DEBUG = os.environ.get("DEBUG", "False").lower() == "true"

# Allow local hosts by default; append Render hostname if present
ALLOWED_HOSTS = [h.strip() for h in os.environ.get("ALLOWED_HOSTS", "127.0.0.1,localhost").split(",") if h.strip()]
RENDER_EXTERNAL_HOSTNAME = os.environ.get("RENDER_EXTERNAL_HOSTNAME")
if RENDER_EXTERNAL_HOSTNAME and RENDER_EXTERNAL_HOSTNAME not in ALLOWED_HOSTS:
    ALLOWED_HOSTS.append(RENDER_EXTERNAL_HOSTNAME)

# CSRF trusted origins
CSRF_TRUSTED_ORIGINS = [
    "http://127.0.0.1:8000",
    "http://localhost:8000",
]
if RENDER_EXTERNAL_HOSTNAME:
    CSRF_TRUSTED_ORIGINS.append(f"https://{RENDER_EXTERNAL_HOSTNAME}")

# If Render provides the full external URL
RENDER_EXTERNAL_URL = os.environ.get("RENDER_EXTERNAL_URL")
if RENDER_EXTERNAL_URL and RENDER_EXTERNAL_URL not in CSRF_TRUSTED_ORIGINS:
    CSRF_TRUSTED_ORIGINS.append(RENDER_EXTERNAL_URL)

# Honor X-Forwarded-Proto from Render's proxy for secure redirects
SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")

# Same-origin iframes (to embed admin in Staff Dashboard)
X_FRAME_OPTIONS = "SAMEORIGIN"

# ----------------------- Installed apps -----------------------
INSTALLED_APPS = [
    "jazzmin",  # keep first
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    # 3rd-party
    "rest_framework",
    "django_extensions",
    # local
    "recruitment",
]

# ----------------------- Middleware -----------------------
MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "whitenoise.middleware.WhiteNoiseMiddleware",  # serve static files in Render
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
    # allows admin pages to be iframed (same origin) inside /staff/
    "recruitment.middleware.AdminIframeXFrameMiddleware",
]

ROOT_URLCONF = "backend.urls"          # <-- change "backend" if your project module is different
WSGI_APPLICATION = "backend.wsgi.application"

# ----------------------- Templates -----------------------
TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / "templates"],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

# ----------------------- Database -----------------------
# Prefer DATABASE_URL (Render/External Postgres). If not set, fall back to SQLite for local dev.
db_url = os.environ.get("DATABASE_URL")
if db_url:
    # If your provider requires SSL: append ?sslmode=require to DATABASE_URL OR set ssl_require=True below.
    DATABASES = {
        "default": dj_database_url.parse(db_url, conn_max_age=600)  # set ssl_require=True if needed
    }
else:
    # Local dev fallback — avoids failing builds by trying to hit localhost:5433 on Render
    DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": BASE_DIR / "db.sqlite3",
        }
    }

# ----------------------- Auth / redirects -----------------------
AUTH_USER_MODEL = "recruitment.User"
LOGIN_URL = "recruitment:login"
LOGIN_REDIRECT_URL = "recruitment:applicant_form"  # role-based view may override
LOGOUT_REDIRECT_URL = "recruitment:landing"

# ----------------------- Static & Media -----------------------
STATIC_URL = "/static/"
STATIC_ROOT = BASE_DIR / "static_root"           # where collectstatic writes (Render)
STATICFILES_DIRS = [BASE_DIR / "static"]         # optional for dev/global assets
STATICFILES_STORAGE = "whitenoise.storage.CompressedManifestStaticFilesStorage"

MEDIA_URL = "/media/"
MEDIA_ROOT = BASE_DIR / "media"

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# ----------------------- Recruitment knobs -----------------------
RECRUITMENT_REQUIRED_DOCS = [
    "G12_CERT", "BIRTH_CERT", "NID_PASSPORT",
    "MED_CLEAR", "POL_CLEAR", "CHAR_REF",
]
RECRUITMENT_DOCS_MUST_BE_APPROVED = True
RECRUITMENT_ENFORCE_AGE_EDU = True

# ----------------------- Jazzmin -----------------------
JAZZMIN_SETTINGS = {
    "site_title": "RPNGC Admin",
    "site_header": "RPNGC",
    "site_brand": "Recruitment Portal",
    "welcome_sign": "Welcome to RPNGC Recruitment Admin Portal",
    "copyright": "© 2025 Royal Papua New Guinea Constabulary",
    "site_logo": "recruitment/images/logo.png",
    "login_logo": "recruitment/images/logo.png",
    "login_logo_dark": None,
    "site_logo_classes": "img-circle elevation-3",
    "site_icon": "recruitment/images/favicon.ico",
    "topmenu_links": [
        {"name": "Home", "url": "admin:index", "permissions": ["auth.view_user"]},
        {"name": "Recruitment Dashboard", "url": "/staff/", "icon": "fas fa-home", "permissions": ["auth.view_user"]},
        {"app": "recruitment"},
        {"name": "Support", "url": "https://support.rpngc.gov.pg", "new_window": True, "icon": "fas fa-question-circle"},
    ],
    "usermenu_links": [
        {"name": "View Profile", "url": "admin:auth_user_change", "icon": "fas fa-user"},
        {"name": "Change Password", "url": "admin:password_change", "icon": "fas fa-key"},
        {"model": "auth.user"},
    ],
    "show_sidebar": True,
    "navigation_expanded": True,
    "hide_apps": [],
    "hide_models": [],
    "order_with_respect_to": ["recruitment", "auth", "contenttypes", "sessions"],
    "icons": {
        "auth": "fas fa-users-cog",
        "auth.user": "fas fa-user",
        "auth.Group": "fas fa-users",
        "recruitment": "fas fa-user-plus",
        "recruitment.application": "fas fa-file-alt",
        "recruitment.applicant": "fas fa-id-card",
        "recruitment.intake": "fas fa-calendar-check",
        "recruitment.document": "fas fa-folder-open",
        "recruitment.assessment": "fas fa-clipboard-check",
        "recruitment.notification": "fas fa-bell",
        "recruitment.settings": "fas fa-cog",
    },
    "default_icon_parents": "fas fa-chevron-circle-right",
    "default_icon_children": "fas fa-circle",
    "related_modal_active": True,
    "show_ui_builder": False,
    "button_classes": {
        "primary": "btn-primary",
        "secondary": "btn-secondary",
        "info": "btn-info",
        "warning": "btn-warning",
        "danger": "btn-danger",
        "success": "btn-success",
        "save": "btn-primary",
        "add": "btn-success",
        "delete": "btn-danger",
    },
    "custom_links": {
        "recruitment": [
            {"name": "Quick Reports", "url": "/admin/recruitment/reports/", "icon": "fas fa-chart-bar", "permissions": ["recruitment.view_application"]},
            {"name": "Export Data", "url": "/admin/recruitment/export/", "icon": "fas fa-download", "permissions": ["recruitment.view_application"]},
            {"name": "System Status", "url": "/admin/recruitment/status/", "icon": "fas fa-heartbeat", "permissions": ["auth.view_user"]},
        ]
    },
    "search_bar": True,
    "search_model": ["auth.User", "recruitment.Application"],
    "language_chooser": False,
    "site_url": "/staff/",
    "site_footer": "Internal system — for authorized staff only. | Powered by Django",
    "custom_css": "recruitment/css/admin_overrides.css",
    "custom_js": "recruitment/js/admin_overrides.js",
    "changeform_format": "horizontal_tabs",
    "changeform_format_overrides": {"auth.user": "collapsible", "auth.group": "vertical_tabs"},
}
JAZZMIN_UI_TWEAKS = {
    "theme": "minty",
    "dark_mode_theme": None,
    "navbar": "navbar-dark",
    "navbar_fixed": True,
    "navbar_small_text": True,
    "footer_small_text": True,
    "footer_fixed": False,
    "sidebar": "sidebar-dark-primary",
    "sidebar_nav_small_text": True,
    "sidebar_disable_expand": False,
    "sidebar_nav_child_indent": True,
    "sidebar_nav_compact_style": True,
    "sidebar_nav_legacy_style": False,
    "sidebar_nav_flat_style": True,
    "sidebar_fixed": True,
    "brand_small_text": False,
    "brand_colour": "navbar-primary",
    "actions_sticky_top": True,
    "body_small_text": False,
}

ADMIN_SITE_HEADER = "RPNGC Recruitment Admin"
ADMIN_SITE_TITLE = "RPNGC Admin Portal"
ADMIN_INDEX_TITLE = "Welcome to RPNGC Recruitment Administration"

# ----------------------- Cookies / Session -----------------------
SESSION_COOKIE_SECURE = not DEBUG
CSRF_COOKIE_SECURE = not DEBUG
SESSION_COOKIE_HTTPONLY = True
CSRF_COOKIE_HTTPONLY = True
SESSION_COOKIE_SAMESITE = "Strict"
CSRF_COOKIE_SAMESITE = "Strict"
SESSION_COOKIE_AGE = 1800  # 30 minutes
SESSION_SAVE_EVERY_REQUEST = True

# (Optional) Timezone/Language defaults
LANGUAGE_CODE = "en-us"
TIME_ZONE = "Pacific/Port_Moresby"
USE_I18N = True
USE_TZ = True

# ==================== Optional: Custom Admin Site ====================
"""
from django.contrib.admin import AdminSite
from django.utils.translation import gettext_lazy as _

class RPNGCAdminSite(AdminSite):
    site_header = _('RPNGC Recruitment Administration')
    site_title = _('RPNGC Admin Portal')
    index_title = _('Dashboard')
    
    def each_context(self, request):
        context = super().each_context(request)
        context.update({'custom_dashboard_data': self.get_dashboard_data(request)})
        return context
    
    def get_dashboard_data(self, request):
        from recruitment.models import Application
        from django.utils import timezone
        from datetime import timedelta
        
        today = timezone.now().date()
        week_ago = today - timedelta(days=7)
        
        return {
            'total_applications': Application.objects.count(),
            'pending_applications': Application.objects.filter(status='pending').count(),
            'applications_this_week': Application.objects.filter(created_at__gte=week_ago).count(),
        }

rpngc_admin_site = RPNGCAdminSite(name='rpngc_admin')
"""
