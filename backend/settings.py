import os
from pathlib import Path
from urllib.parse import urlparse
import dj_database_url  # <- ensure in requirements.txt
from dotenv import load_dotenv
load_dotenv()

BASE_DIR = Path(__file__).resolve().parent.parent

# ======================= Security / Env =======================
SECRET_KEY = os.environ.get("SECRET_KEY", "changeme-in-prod")
DEBUG = os.environ.get("DEBUG", "False").lower() == "true"

# Allow local by default; merge any comma-separated hosts from env
_raw_hosts = os.environ.get("ALLOWED_HOSTS", "127.0.0.1,localhost")
ALLOWED_HOSTS = [h.strip() for h in _raw_hosts.split(",") if h.strip()]

# Render can provide hostname or full URL
RENDER_EXTERNAL_HOSTNAME = os.environ.get("RENDER_EXTERNAL_HOSTNAME", "").strip()
RENDER_EXTERNAL_URL = os.environ.get("RENDER_EXTERNAL_URL", "").strip()

def _add_host(host: str):
    if not host:
        return
    host = host.strip().lower()
    if host and host not in ALLOWED_HOSTS:
        ALLOWED_HOSTS.append(host)

# If a bare hostname was provided
_add_host(RENDER_EXTERNAL_HOSTNAME)

# If a full URL was provided, extract the netloc (domain:port)
if RENDER_EXTERNAL_URL:
    try:
        parsed = urlparse(RENDER_EXTERNAL_URL)
        if parsed.netloc:
            _add_host(parsed.netloc)
    except Exception:
        pass

# Same-origin iframes (you already add a middleware allowing admin in iframe)
X_FRAME_OPTIONS = "SAMEORIGIN"

# Honor X-Forwarded-Proto from the platform proxy
SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")

# HTTPS-only toggles (default secure in prod; override via env if needed)
SECURE_SSL_REDIRECT = os.environ.get("SECURE_SSL_REDIRECT", "true").lower() == "true" and not DEBUG
SESSION_COOKIE_SECURE = os.environ.get("SESSION_COOKIE_SECURE", "true").lower() == "true" and not DEBUG
CSRF_COOKIE_SECURE = os.environ.get("CSRF_COOKIE_SECURE", "true").lower() == "true" and not DEBUG

SESSION_COOKIE_HTTPONLY = True
CSRF_COOKIE_HTTPONLY = True
SESSION_COOKIE_SAMESITE = "Strict"
CSRF_COOKIE_SAMESITE = "Strict"

# ======================= Installed apps =======================
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

# ======================= Middleware =======================
MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "whitenoise.middleware.WhiteNoiseMiddleware",  # serve static files
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
    "recruitment.middleware.AdminIframeXFrameMiddleware",
]

ROOT_URLCONF = "backend.urls"

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

WSGI_APPLICATION = "backend.wsgi.application"

# ======================= Database =======================
# Local default (Postgres on your machine). Keep your custom port if you use 5433.
_BASE_DB = {
    "ENGINE": "django.db.backends.postgresql",
    "NAME": os.environ.get("DB_NAME", "RPNGC"),
    "USER": os.environ.get("DB_USER", "postgres"),
    "PASSWORD": os.environ.get("DB_PASSWORD", "akay47d1u82c"),
    "HOST": os.environ.get("DB_HOST", "localhost"),
    "PORT": os.environ.get("DB_PORT", "5433"),
}

if os.environ.get("DATABASE_URL"):  # e.g., Render/Railway/Heroku
    DATABASES = {
        "default": dj_database_url.config(
            env="DATABASE_URL",
            conn_max_age=600,
            ssl_require=not DEBUG,
        )
    }
else:
    DATABASES = {"default": _BASE_DB}

# ======================= Auth / redirects =======================
AUTH_USER_MODEL = "recruitment.User"
LOGIN_URL = "recruitment:login"
LOGIN_REDIRECT_URL = "recruitment:applicant_form"
LOGOUT_REDIRECT_URL = "recruitment:landing"

# ======================= Static & Media =======================
STATIC_URL = "/static/"
STATIC_ROOT = BASE_DIR / "static_root"  # where collectstatic puts files
# Only add global /static if it exists to avoid noisy errors
_static_dir = BASE_DIR / "static"
STATICFILES_DIRS = [_static_dir] if _static_dir.exists() else []

# WhiteNoise: compressed & hashed filenames (cache-friendly)
STATICFILES_STORAGE = "whitenoise.storage.CompressedManifestStaticFilesStorage"

MEDIA_URL = "/media/"
MEDIA_ROOT = BASE_DIR / "media"

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# ======================= CSRF Trusted Origins =======================
# Start with dev
CSRF_TRUSTED_ORIGINS = [
    "http://127.0.0.1:8000",
    "http://localhost:8000",
]

# Add https://<host> for any dotted hosts (public domains)
for host in ALLOWED_HOSTS:
    # Skip plain 'localhost' or '127.0.0.1'
    if "." in host:
        CSRF_TRUSTED_ORIGINS.append(f"https://{host}")
        # If you sometimes hit over http during staging/debug
        if os.environ.get("ALLOW_HTTP_CSRF", "false").lower() == "true":
            CSRF_TRUSTED_ORIGINS.append(f"http://{host}")

# If RENDER_EXTERNAL_URL is already a full scheme URL, include it directly
if RENDER_EXTERNAL_URL and RENDER_EXTERNAL_URL not in CSRF_TRUSTED_ORIGINS:
    CSRF_TRUSTED_ORIGINS.append(RENDER_EXTERNAL_URL)

# ======================= Recruitment knobs =======================
RECRUITMENT_REQUIRED_DOCS = [
    "G12_CERT", "BIRTH_CERT", "NID_PASSPORT",
    "MED_CLEAR", "POL_CLEAR", "CHAR_REF",
]
RECRUITMENT_DOCS_MUST_BE_APPROVED = True
RECRUITMENT_ENFORCE_AGE_EDU = True

# ======================= Jazzmin (your config kept) =======================
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

# ======================= Session / Timezone =======================
SESSION_COOKIE_AGE = 1800  # 30 minutes
SESSION_SAVE_EVERY_REQUEST = True

TIME_ZONE = os.environ.get("TIME_ZONE", "Pacific/Port_Moresby")
USE_TZ = True

# ======================= Optional logging =======================
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {"console": {"class": "logging.StreamHandler"}},
    "root": {"handlers": ["console"], "level": os.environ.get("LOG_LEVEL", "INFO")},
}
