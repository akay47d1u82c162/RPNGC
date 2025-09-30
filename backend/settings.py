import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

# --- Security ---
SECRET_KEY = os.getenv("5x48==udk3bxuo#rb_12g#hmin6qeb^e_-6srp-d)y&j#^q^7e", "changeme-in-prod")  # <- fixed
DEBUG = os.getenv("DEBUG", "True").lower() == "true"
ALLOWED_HOSTS = [h.strip() for h in os.getenv("ALLOWED_HOSTS", "127.0.0.1,localhost").split(",")]

# Same-origin iframes (to embed admin in Staff Dashboard)
X_FRAME_OPTIONS = "SAMEORIGIN"
# If you use CSP, also: CSP_FRAME_ANCESTORS = ("'self'",)

# Useful for local dev with 127.0.0.1/localhost
CSRF_TRUSTED_ORIGINS = [
    "http://127.0.0.1:8000",
    "http://localhost:8000",
]

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

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
    # allows admin pages to be iframed (same origin) inside /staff/
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

# --- Database ---
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.getenv("DB_NAME", "RPNGC"),
        "USER": os.getenv("DB_USER", "postgres"),
        "PASSWORD": os.getenv("DB_PASSWORD", "akay47d1u82c"),
        "HOST": os.getenv("DB_HOST", "localhost"),
        "PORT": os.getenv("DB_PORT", "5433"),
    }
}

# --- Auth / redirects (namespaced) ---
AUTH_USER_MODEL = "recruitment.User"
LOGIN_URL = "recruitment:login"
LOGIN_REDIRECT_URL = "recruitment:applicant_form"  # role-based view will override when appropriate
LOGOUT_REDIRECT_URL = "recruitment:landing"

# --- Static & media ---
STATIC_URL = "/static/"
STATICFILES_DIRS = [BASE_DIR / "static"]       # dev/global static
STATIC_ROOT = BASE_DIR / "static_root"         # collectstatic target

MEDIA_URL = "/media/"
MEDIA_ROOT = BASE_DIR / "media"

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# --- Recruitment policy knobs ---
RECRUITMENT_REQUIRED_DOCS = [
    "G12_CERT", "BIRTH_CERT", "NID_PASSPORT",
    "MED_CLEAR", "POL_CLEAR", "CHAR_REF",
]
RECRUITMENT_DOCS_MUST_BE_APPROVED = True
RECRUITMENT_ENFORCE_AGE_EDU = True

JAZZMIN_SETTINGS = {
    "site_title": "RPNGC Admin",
    "site_header": "RPNGC",
    "site_brand": "Recruitment",
    "welcome_sign": "Welcome to RPNGC Recruitment Admin",
    "site_logo": "recruitment/images/logo.png",
    "login_logo": "recruitment/images/logo.png",
    "copyright": "© 2025 Royal Papua New Guinea Constabulary",
    "site_footer": "Internal system — for authorized staff only.",
    "site_url": "/staff/",

    # Left menu — group like the screenshot
    "order_with_respect_to": [
        "recruitment.ApplicantProfile",
        "recruitment.Application",
        "recruitment.RecruitmentCycle",
        "recruitment.Document",
        "recruitment.Test",
        "recruitment.Question",
        "recruitment.TestAttempt",
        "recruitment.InterviewSchedule",
        "recruitment.InterviewScore",
        "recruitment.FinalSelection",
        "recruitment.Notification",
        "recruitment.AuditLog",
        "recruitment.Province",
        "recruitment.District",
        "auth.User",
    ],

    "hide_apps": [],
    "hide_models": [],

    # Icons (Lucide/FontAwesome supported by Jazzmin)
    "icons": {
        "recruitment.ApplicantProfile": "fas fa-user",
        "recruitment.Application": "fas fa-clipboard-list",
        "recruitment.RecruitmentCycle": "fas fa-calendar-alt",
        "recruitment.Document": "fas fa-file",
        "recruitment.Test": "fas fa-check-square",
        "recruitment.Question": "fas fa-question",
        "recruitment.TestAttempt": "fas fa-laptop-code",
        "recruitment.InterviewSchedule": "fas fa-users",
        "recruitment.InterviewScore": "fas fa-star-half-alt",
        "recruitment.FinalSelection": "fas fa-award",
        "recruitment.Notification": "fas fa-bell",
        "recruitment.AuditLog": "fas fa-shield-alt",
        "recruitment.Province": "fas fa-map-marked-alt",
        "recruitment.District": "fas fa-map-marker-alt",
        "auth.User": "fas fa-user-cog",
    },

    # “Add” button as a green pill on changelist (like the screenshot)
    "button_classes": {
        "add": "btn btn-success",
        "save": "btn btn-primary",
        "delete": "btn btn-danger",
    },

    # Custom assets
    "custom_css": "recruitment/css/admin_overrides.css",
    "custom_js": "recruitment/js/admin_overrides.js",

    # Sidebar & search
    "show_sidebar": True,
    "navigation_expanded": False,  # collapsed by default (compact)
    "search_model": "recruitment.ApplicantProfile",  # quick search focus
}

# Subtle spacing, smaller fonts, teal topbar & dark sidebar
JAZZMIN_UI_TWEAKS = {
    "theme": "minty",  # base — we override colors via CSS
    "navbar_small_text": True,
    "footer_small_text": True,
    "sidebar_fixed": True,
    "sidebar_nav_small_text": True,
    "sidebar_dark": True,
    "brand_small_text": False,
    "actions_sticky_top": True,
    "dark_mode_theme": None,
}