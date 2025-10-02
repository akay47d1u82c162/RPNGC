
from django.views.decorators.http import require_GET

from django import forms
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.forms import inlineformset_factory, BaseInlineFormSet
from django.utils import timezone

from .models import (
    User,
    ApplicantProfile,
    Application,
    RecruitmentCycle,
    AlternativeContact,
    EducationRecord,
    WorkHistory,
    Reference,
    Document,
    ParentGuardian,
)

# ---------- Auth ----------

class RoleBasedLoginForm(AuthenticationForm):
    """
    Authentication form with a role selector used by RoleBasedLoginView.
    """
    LOGIN_CHOICES = [
        ("auto", "Auto — based on my account"),
        ("applicant", "Applicant"),
        ("panel", "Interview Panel"),
        ("staff", "Staff / Admin"),
    ]
    login_as = forms.ChoiceField(
        choices=LOGIN_CHOICES,
        required=False,
        initial="auto",
        label="Sign in as",
        widget=forms.Select(attrs={"class": "input"}),
    )


class ApplicantRegistrationForm(UserCreationForm):
    email = forms.EmailField(required=True)
    first_name = forms.CharField(required=False)
    last_name = forms.CharField(required=False)

    class Meta(UserCreationForm.Meta):
        model = User
        fields = ("username", "first_name", "last_name", "email")

    def save(self, commit=True):
        user: User = super().save(commit=False)
        user.email = self.cleaned_data.get("email")
        user.first_name = self.cleaned_data.get("first_name", "")
        user.last_name = self.cleaned_data.get("last_name", "")
        user.role = User.Roles.APPLICANT
        if commit:
            user.save()
        return user


# ---------- Profile ----------

class ApplicantProfileForm(forms.ModelForm):
    class Meta:
        model = ApplicantProfile
        fields = (
            "full_name",
            "gender",
            "dob",
            "province_of_origin",
            "province",
            "district",
            "phone",
            "email",
            "nid_number",
            "photo",
            "highest_education_level",
        )
        widgets = {"dob": forms.DateInput(attrs={"type": "date"})}


# ---------- Application ----------

class ApplicationForm(forms.ModelForm):
    cycle = forms.ModelChoiceField(
        queryset=RecruitmentCycle.objects.all().order_by("-is_active", "-intake_year", "-start_date"),
        empty_label="Select recruitment cycle",
    )
    rec_type = forms.ChoiceField(choices=RecruitmentCycle.RecType.choices)

    class Meta:
        model = Application
        fields = (
            "cycle",
            "rec_type",
            "applied_unit",
            "from_bougainville",
            "years_experience",
            "years_experience_other",
            "reservist_2021_2022",
            "reason_for_applying",
            "criminal_conviction",
            "declaration_agreed",
            "signature_name",
            "signature_date",
        )
        widgets = {
            "signature_date": forms.DateInput(attrs={"type": "date"}),
            "reason_for_applying": forms.Textarea(attrs={"rows": 4}),
        }

    def clean(self):
        cleaned = super().clean()
        cycle: RecruitmentCycle | None = cleaned.get("cycle")
        rec_type = cleaned.get("rec_type")
        if cycle and rec_type and cycle.rec_type != rec_type:
            self.add_error("rec_type", "Recruitment type must match the selected cycle’s type.")
        return cleaned

    def submit(self):
        self.instance.submitted_at = timezone.now()
        self.instance.status = Application.Status.PENDING
        return self.instance


# ---------- Inline formsets under Application ----------

class _StrictMaxNumFormSet(BaseInlineFormSet):
    def clean(self):
        super().clean()
        max_num = getattr(self, "max_num", None)
        if max_num is not None:
            active = 0
            for form in self.forms:
                if getattr(form, "cleaned_data", None) and not form.cleaned_data.get("DELETE", False):
                    if any(v not in (None, "", [], {}) for k, v in form.cleaned_data.items() if k != "DELETE"):
                        active += 1
            if active > max_num:
                raise forms.ValidationError(f"You can only provide up to {max_num} entries.")


AlternativeContactFormSet = inlineformset_factory(
    parent_model=Application,
    model=AlternativeContact,
    fields=["name", "relationship", "phone", "address"],
    extra=1,
    can_delete=True,
    max_num=1,
    validate_max=True,
    formset=_StrictMaxNumFormSet,
    widgets={
        "name": forms.TextInput(),
        "relationship": forms.TextInput(),
        "phone": forms.TextInput(),
        "address": forms.Textarea(attrs={"rows": 2}),
    },
)

EducationRecordFormSet = inlineformset_factory(
    parent_model=Application,
    model=EducationRecord,
    fields=[
        "level",
        "institution",
        "province",
        "start_year",
        "end_year",
        "certificate_title",
        "gpa",
        "english_grade",
        "mathematics_grade",
        "science_grade",
        "other_grade",
    ],
    extra=1,
    can_delete=True,
    widgets={
        "start_year": forms.NumberInput(attrs={"min": 1900, "max": 2100}),
        "end_year": forms.NumberInput(attrs={"min": 1900, "max": 2100}),
    },
)

WorkHistoryFormSet = inlineformset_factory(
    parent_model=Application,
    model=WorkHistory,
    fields=["employer", "position", "start_date", "end_date", "duties"],
    extra=1,
    can_delete=True,
    widgets={
        "start_date": forms.DateInput(attrs={"type": "date"}),
        "end_date": forms.DateInput(attrs={"type": "date"}),
        "duties": forms.Textarea(attrs={"rows": 2}),
    },
)

class ReferenceBaseFormSet(_StrictMaxNumFormSet):
    max_num = 3

ReferenceFormSet = inlineformset_factory(
    parent_model=Application,
    model=Reference,
    formset=ReferenceBaseFormSet,
    fields=["name", "position_title", "phone_number", "email"],
    extra=3,
    can_delete=True,
    max_num=3,
    validate_max=True,
)

class DocumentForm(forms.ModelForm):
    class Meta:
        model = Document
        fields = ("doc_type", "file")
        widgets = {"doc_type": forms.Select()}


# ---------- Parent/Guardian (bound to ApplicantProfile) ----------

ParentGuardianFormSet = inlineformset_factory(
    parent_model=ApplicantProfile,
    model=ParentGuardian,
    fields=["kind", "name", "phone", "address", "is_alive"],
    extra=2,
    can_delete=True,
    widgets={"address": forms.Textarea(attrs={"rows": 2})},
)

# Backwards-compatibility aliases for views/imports that might use old names
WorkFormSet = WorkHistoryFormSet
EducationFormSet = EducationRecordFormSet
AltContactFormSet = AlternativeContactFormSet
DocUploadForm = DocumentForm
DocumentUploadForm = DocumentForm

# Expose document type choices safely to views (optional helpers)
try:
    DOC_TYPE_CHOICES = Document.DocType.choices
    REQUIRED_DOC_TYPES = tuple(code for code, _ in DOC_TYPE_CHOICES)
except Exception:
    DOC_TYPE_CHOICES = ()
    REQUIRED_DOC_TYPES = ()
