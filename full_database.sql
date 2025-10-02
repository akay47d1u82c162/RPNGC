--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9
-- Dumped by pg_dump version 16.9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.tests DROP CONSTRAINT IF EXISTS tests_cycle_id_84e5a6af_fk_recruitment_cycles_id;
ALTER TABLE IF EXISTS ONLY public.test_questions DROP CONSTRAINT IF EXISTS test_questions_test_id_a208ce1d_fk_tests_id;
ALTER TABLE IF EXISTS ONLY public.test_choices DROP CONSTRAINT IF EXISTS test_choices_question_id_aae26ef5_fk_test_questions_id;
ALTER TABLE IF EXISTS ONLY public.test_attempts DROP CONSTRAINT IF EXISTS test_attempts_test_id_cea68c14_fk_tests_id;
ALTER TABLE IF EXISTS ONLY public.test_attempts DROP CONSTRAINT IF EXISTS test_attempts_application_id_c2086b9d_fk_applications_id;
ALTER TABLE IF EXISTS ONLY public.test_attempt_answers DROP CONSTRAINT IF EXISTS test_attempt_answers_selected_choice_id_b42c31d4_fk_test_choi;
ALTER TABLE IF EXISTS ONLY public.test_attempt_answers DROP CONSTRAINT IF EXISTS test_attempt_answers_question_id_b181ce43_fk_test_questions_id;
ALTER TABLE IF EXISTS ONLY public.test_attempt_answers DROP CONSTRAINT IF EXISTS test_attempt_answers_attempt_id_c28276bb_fk_test_attempts_id;
ALTER TABLE IF EXISTS ONLY public.screening_actions DROP CONSTRAINT IF EXISTS screening_actions_by_user_id_01160d76_fk_recruitment_user_id;
ALTER TABLE IF EXISTS ONLY public.screening_actions DROP CONSTRAINT IF EXISTS screening_actions_application_id_ebd21d46_fk_applications_id;
ALTER TABLE IF EXISTS ONLY public.recruitment_user_user_permissions DROP CONSTRAINT IF EXISTS recruitment_user_use_user_id_6b57dee3_fk_recruitme;
ALTER TABLE IF EXISTS ONLY public.recruitment_user_user_permissions DROP CONSTRAINT IF EXISTS recruitment_user_use_permission_id_fdb1bf3e_fk_auth_perm;
ALTER TABLE IF EXISTS ONLY public.recruitment_user_groups DROP CONSTRAINT IF EXISTS recruitment_user_groups_user_id_62abfa8c_fk_recruitment_user_id;
ALTER TABLE IF EXISTS ONLY public.recruitment_user_groups DROP CONSTRAINT IF EXISTS recruitment_user_groups_group_id_e5f6bf13_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.recruitment_cycles DROP CONSTRAINT IF EXISTS recruitment_cycles_created_by_id_9d1a5d92_fk_recruitme;
ALTER TABLE IF EXISTS ONLY public.notifications DROP CONSTRAINT IF EXISTS notifications_user_id_468e288d_fk_recruitment_user_id;
ALTER TABLE IF EXISTS ONLY public.interview_scores DROP CONSTRAINT IF EXISTS interview_scores_schedule_id_c30026f3_fk_interview_schedules_id;
ALTER TABLE IF EXISTS ONLY public.interview_scores DROP CONSTRAINT IF EXISTS interview_scores_interviewer_id_13dc829d_fk_recruitment_user_id;
ALTER TABLE IF EXISTS ONLY public.interview_schedules DROP CONSTRAINT IF EXISTS interview_schedules_created_by_id_43f43106_fk_recruitme;
ALTER TABLE IF EXISTS ONLY public.interview_schedules DROP CONSTRAINT IF EXISTS interview_schedules_application_id_7a7f8ea6_fk_applications_id;
ALTER TABLE IF EXISTS ONLY public.geo_districts DROP CONSTRAINT IF EXISTS geo_districts_province_id_416bbbec_fk_geo_provinces_id;
ALTER TABLE IF EXISTS ONLY public.final_selections DROP CONSTRAINT IF EXISTS final_selections_approved_by_id_b6ba3b39_fk_recruitment_user_id;
ALTER TABLE IF EXISTS ONLY public.final_selections DROP CONSTRAINT IF EXISTS final_selections_application_id_81ca0ad3_fk_applications_id;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_user_id_c564eba6_fk_recruitment_user_id;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_content_type_id_c4bce8eb_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_2f476e4b_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_b120cbf9_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissio_permission_id_84c5c92e_fk_auth_perm;
ALTER TABLE IF EXISTS ONLY public.audit_logs DROP CONSTRAINT IF EXISTS audit_logs_actor_id_303d1495_fk_recruitment_user_id;
ALTER TABLE IF EXISTS ONLY public.applications DROP CONSTRAINT IF EXISTS applications_cycle_id_809b7ab4_fk_recruitment_cycles_id;
ALTER TABLE IF EXISTS ONLY public.applications DROP CONSTRAINT IF EXISTS applications_applicant_id_0f5ee165_fk_applicant_profiles_id;
ALTER TABLE IF EXISTS ONLY public.application_eligibility DROP CONSTRAINT IF EXISTS application_eligibil_application_id_7ee9a67b_fk_applicati;
ALTER TABLE IF EXISTS ONLY public.applicant_work_history DROP CONSTRAINT IF EXISTS applicant_work_histo_application_id_42e72e7c_fk_applicati;
ALTER TABLE IF EXISTS ONLY public.applicant_references DROP CONSTRAINT IF EXISTS applicant_references_application_id_8040aa72_fk_applications_id;
ALTER TABLE IF EXISTS ONLY public.applicant_profiles DROP CONSTRAINT IF EXISTS applicant_profiles_user_id_07bdf848_fk_recruitment_user_id;
ALTER TABLE IF EXISTS ONLY public.applicant_profiles DROP CONSTRAINT IF EXISTS applicant_profiles_province_of_origin_i_b8864a9e_fk_geo_provi;
ALTER TABLE IF EXISTS ONLY public.applicant_profiles DROP CONSTRAINT IF EXISTS applicant_profiles_province_id_f9083536_fk_geo_provinces_id;
ALTER TABLE IF EXISTS ONLY public.applicant_profiles DROP CONSTRAINT IF EXISTS applicant_profiles_district_id_9a16ee01_fk_geo_districts_id;
ALTER TABLE IF EXISTS ONLY public.applicant_parents DROP CONSTRAINT IF EXISTS applicant_parents_applicant_id_18eefeac_fk_applicant;
ALTER TABLE IF EXISTS ONLY public.applicant_education DROP CONSTRAINT IF EXISTS applicant_education_province_id_69864504_fk_geo_provinces_id;
ALTER TABLE IF EXISTS ONLY public.applicant_education DROP CONSTRAINT IF EXISTS applicant_education_application_id_f175a15b_fk_applications_id;
ALTER TABLE IF EXISTS ONLY public.applicant_documents DROP CONSTRAINT IF EXISTS applicant_documents_verified_by_id_2822d2dd_fk_recruitme;
ALTER TABLE IF EXISTS ONLY public.applicant_documents DROP CONSTRAINT IF EXISTS applicant_documents_application_id_fddf6e3c_fk_applications_id;
ALTER TABLE IF EXISTS ONLY public.applicant_alt_contact DROP CONSTRAINT IF EXISTS applicant_alt_contac_application_id_4b1e42f7_fk_applicati;
DROP INDEX IF EXISTS public.uniq_nid_when_present_ci;
DROP INDEX IF EXISTS public.tests_cycle_id_84e5a6af;
DROP INDEX IF EXISTS public.test_questions_test_id_a208ce1d;
DROP INDEX IF EXISTS public.test_questions_order_d4b4c35e;
DROP INDEX IF EXISTS public.test_choices_question_id_aae26ef5;
DROP INDEX IF EXISTS public.test_attempts_test_id_cea68c14;
DROP INDEX IF EXISTS public.test_attempts_application_id_c2086b9d;
DROP INDEX IF EXISTS public.test_attempt_answers_selected_choice_id_b42c31d4;
DROP INDEX IF EXISTS public.test_attempt_answers_question_id_b181ce43;
DROP INDEX IF EXISTS public.test_attempt_answers_attempt_id_c28276bb;
DROP INDEX IF EXISTS public.test_attemp_test_id_9cfba9_idx;
DROP INDEX IF EXISTS public.screening_actions_by_user_id_01160d76;
DROP INDEX IF EXISTS public.screening_actions_application_id_ebd21d46;
DROP INDEX IF EXISTS public.recruitment_user_username_8be4a9c8_like;
DROP INDEX IF EXISTS public.recruitment_user_user_permissions_user_id_6b57dee3;
DROP INDEX IF EXISTS public.recruitment_user_user_permissions_permission_id_fdb1bf3e;
DROP INDEX IF EXISTS public.recruitment_user_role_2ae0f92b_like;
DROP INDEX IF EXISTS public.recruitment_user_role_2ae0f92b;
DROP INDEX IF EXISTS public.recruitment_user_groups_user_id_62abfa8c;
DROP INDEX IF EXISTS public.recruitment_user_groups_group_id_e5f6bf13;
DROP INDEX IF EXISTS public.recruitment_cycles_rec_type_110f45bc_like;
DROP INDEX IF EXISTS public.recruitment_cycles_rec_type_110f45bc;
DROP INDEX IF EXISTS public.recruitment_cycles_created_by_id_9d1a5d92;
DROP INDEX IF EXISTS public.notifications_user_id_468e288d;
DROP INDEX IF EXISTS public.notifications_ntype_3117b425_like;
DROP INDEX IF EXISTS public.notifications_ntype_3117b425;
DROP INDEX IF EXISTS public.notificatio_user_id_dc2a8e_idx;
DROP INDEX IF EXISTS public.interview_scores_schedule_id_c30026f3;
DROP INDEX IF EXISTS public.interview_scores_interviewer_id_13dc829d;
DROP INDEX IF EXISTS public.interview_schedules_created_by_id_43f43106;
DROP INDEX IF EXISTS public.interview_schedules_application_id_7a7f8ea6;
DROP INDEX IF EXISTS public.geo_provinces_name_aafdd58f_like;
DROP INDEX IF EXISTS public.geo_provinces_code_490ae875_like;
DROP INDEX IF EXISTS public.geo_districts_province_id_416bbbec;
DROP INDEX IF EXISTS public.final_selections_rank_5644370b;
DROP INDEX IF EXISTS public.final_selections_approved_by_id_b6ba3b39;
DROP INDEX IF EXISTS public.django_session_session_key_c0390e0f_like;
DROP INDEX IF EXISTS public.django_session_expire_date_a5c62663;
DROP INDEX IF EXISTS public.django_admin_log_user_id_c564eba6;
DROP INDEX IF EXISTS public.django_admin_log_content_type_id_c4bce8eb;
DROP INDEX IF EXISTS public.auth_permission_content_type_id_2f476e4b;
DROP INDEX IF EXISTS public.auth_group_permissions_permission_id_84c5c92e;
DROP INDEX IF EXISTS public.auth_group_permissions_group_id_b120cbf9;
DROP INDEX IF EXISTS public.auth_group_name_a6ea08ec_like;
DROP INDEX IF EXISTS public.audit_logs_created_262184_idx;
DROP INDEX IF EXISTS public.audit_logs_actor_id_303d1495;
DROP INDEX IF EXISTS public.audit_logs_action_5fd1bf_idx;
DROP INDEX IF EXISTS public.audit_logs_action_327a0be3_like;
DROP INDEX IF EXISTS public.audit_logs_action_327a0be3;
DROP INDEX IF EXISTS public.applications_total_score_ff488a83;
DROP INDEX IF EXISTS public.applications_status_cbf6eacc_like;
DROP INDEX IF EXISTS public.applications_status_cbf6eacc;
DROP INDEX IF EXISTS public.applications_rec_type_1e3bb44c_like;
DROP INDEX IF EXISTS public.applications_rec_type_1e3bb44c;
DROP INDEX IF EXISTS public.applications_cycle_id_809b7ab4;
DROP INDEX IF EXISTS public.applications_applicant_id_0f5ee165;
DROP INDEX IF EXISTS public.application_rec_typ_08c951_idx;
DROP INDEX IF EXISTS public.application_cycle_i_fedbb2_idx;
DROP INDEX IF EXISTS public.application_cycle_i_a4dfc5_idx;
DROP INDEX IF EXISTS public.applicant_work_history_application_id_42e72e7c;
DROP INDEX IF EXISTS public.applicant_references_application_id_8040aa72;
DROP INDEX IF EXISTS public.applicant_profiles_province_of_origin_id_b8864a9e;
DROP INDEX IF EXISTS public.applicant_profiles_province_id_f9083536;
DROP INDEX IF EXISTS public.applicant_profiles_district_id_9a16ee01;
DROP INDEX IF EXISTS public.applicant_parents_applicant_id_18eefeac;
DROP INDEX IF EXISTS public.applicant_education_province_id_69864504;
DROP INDEX IF EXISTS public.applicant_education_application_id_f175a15b;
DROP INDEX IF EXISTS public.applicant_documents_verified_by_id_2822d2dd;
DROP INDEX IF EXISTS public.applicant_documents_doc_type_49ea08de_like;
DROP INDEX IF EXISTS public.applicant_documents_doc_type_49ea08de;
DROP INDEX IF EXISTS public.applicant_documents_application_id_fddf6e3c;
DROP INDEX IF EXISTS public.applicant_d_doc_typ_83ede9_idx;
ALTER TABLE IF EXISTS ONLY public.tests DROP CONSTRAINT IF EXISTS tests_pkey;
ALTER TABLE IF EXISTS ONLY public.tests DROP CONSTRAINT IF EXISTS tests_cycle_id_name_063fba1d_uniq;
ALTER TABLE IF EXISTS ONLY public.test_questions DROP CONSTRAINT IF EXISTS test_questions_pkey;
ALTER TABLE IF EXISTS ONLY public.test_choices DROP CONSTRAINT IF EXISTS test_choices_pkey;
ALTER TABLE IF EXISTS ONLY public.test_attempts DROP CONSTRAINT IF EXISTS test_attempts_test_id_application_id_d2e56db8_uniq;
ALTER TABLE IF EXISTS ONLY public.test_attempts DROP CONSTRAINT IF EXISTS test_attempts_pkey;
ALTER TABLE IF EXISTS ONLY public.test_attempt_answers DROP CONSTRAINT IF EXISTS test_attempt_answers_pkey;
ALTER TABLE IF EXISTS ONLY public.test_attempt_answers DROP CONSTRAINT IF EXISTS test_attempt_answers_attempt_id_question_id_314a843e_uniq;
ALTER TABLE IF EXISTS ONLY public.screening_actions DROP CONSTRAINT IF EXISTS screening_actions_pkey;
ALTER TABLE IF EXISTS ONLY public.recruitment_user DROP CONSTRAINT IF EXISTS recruitment_user_username_key;
ALTER TABLE IF EXISTS ONLY public.recruitment_user_user_permissions DROP CONSTRAINT IF EXISTS recruitment_user_user_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.recruitment_user_user_permissions DROP CONSTRAINT IF EXISTS recruitment_user_user_pe_user_id_permission_id_c4902334_uniq;
ALTER TABLE IF EXISTS ONLY public.recruitment_user DROP CONSTRAINT IF EXISTS recruitment_user_pkey;
ALTER TABLE IF EXISTS ONLY public.recruitment_user_groups DROP CONSTRAINT IF EXISTS recruitment_user_groups_user_id_group_id_5ef744f5_uniq;
ALTER TABLE IF EXISTS ONLY public.recruitment_user_groups DROP CONSTRAINT IF EXISTS recruitment_user_groups_pkey;
ALTER TABLE IF EXISTS ONLY public.recruitment_cycles DROP CONSTRAINT IF EXISTS recruitment_cycles_pkey;
ALTER TABLE IF EXISTS ONLY public.recruitment_cycles DROP CONSTRAINT IF EXISTS recruitment_cycles_intake_year_name_rec_type_25cbdf1f_uniq;
ALTER TABLE IF EXISTS ONLY public.notifications DROP CONSTRAINT IF EXISTS notifications_pkey;
ALTER TABLE IF EXISTS ONLY public.interview_scores DROP CONSTRAINT IF EXISTS interview_scores_schedule_id_interviewer_id_16443a5a_uniq;
ALTER TABLE IF EXISTS ONLY public.interview_scores DROP CONSTRAINT IF EXISTS interview_scores_pkey;
ALTER TABLE IF EXISTS ONLY public.interview_schedules DROP CONSTRAINT IF EXISTS interview_schedules_pkey;
ALTER TABLE IF EXISTS ONLY public.geo_provinces DROP CONSTRAINT IF EXISTS geo_provinces_pkey;
ALTER TABLE IF EXISTS ONLY public.geo_provinces DROP CONSTRAINT IF EXISTS geo_provinces_name_key;
ALTER TABLE IF EXISTS ONLY public.geo_provinces DROP CONSTRAINT IF EXISTS geo_provinces_code_key;
ALTER TABLE IF EXISTS ONLY public.geo_districts DROP CONSTRAINT IF EXISTS geo_districts_province_id_name_73514ca6_uniq;
ALTER TABLE IF EXISTS ONLY public.geo_districts DROP CONSTRAINT IF EXISTS geo_districts_pkey;
ALTER TABLE IF EXISTS ONLY public.final_selections DROP CONSTRAINT IF EXISTS final_selections_pkey;
ALTER TABLE IF EXISTS ONLY public.final_selections DROP CONSTRAINT IF EXISTS final_selections_application_id_key;
ALTER TABLE IF EXISTS ONLY public.django_session DROP CONSTRAINT IF EXISTS django_session_pkey;
ALTER TABLE IF EXISTS ONLY public.django_migrations DROP CONSTRAINT IF EXISTS django_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_app_label_model_76bd3d3b_uniq;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_codename_01ab375a_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_permission_id_0cd325b0_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_name_key;
ALTER TABLE IF EXISTS ONLY public.audit_logs DROP CONSTRAINT IF EXISTS audit_logs_pkey;
ALTER TABLE IF EXISTS ONLY public.applications DROP CONSTRAINT IF EXISTS applications_pkey;
ALTER TABLE IF EXISTS ONLY public.applications DROP CONSTRAINT IF EXISTS applications_applicant_id_cycle_id_b76bd2f1_uniq;
ALTER TABLE IF EXISTS ONLY public.application_eligibility DROP CONSTRAINT IF EXISTS application_eligibility_pkey;
ALTER TABLE IF EXISTS ONLY public.application_eligibility DROP CONSTRAINT IF EXISTS application_eligibility_application_id_key;
ALTER TABLE IF EXISTS ONLY public.applicant_work_history DROP CONSTRAINT IF EXISTS applicant_work_history_pkey;
ALTER TABLE IF EXISTS ONLY public.applicant_references DROP CONSTRAINT IF EXISTS applicant_references_pkey;
ALTER TABLE IF EXISTS ONLY public.applicant_profiles DROP CONSTRAINT IF EXISTS applicant_profiles_user_id_key;
ALTER TABLE IF EXISTS ONLY public.applicant_profiles DROP CONSTRAINT IF EXISTS applicant_profiles_pkey;
ALTER TABLE IF EXISTS ONLY public.applicant_parents DROP CONSTRAINT IF EXISTS applicant_parents_pkey;
ALTER TABLE IF EXISTS ONLY public.applicant_parents DROP CONSTRAINT IF EXISTS applicant_parents_applicant_id_kind_845cda11_uniq;
ALTER TABLE IF EXISTS ONLY public.applicant_education DROP CONSTRAINT IF EXISTS applicant_education_pkey;
ALTER TABLE IF EXISTS ONLY public.applicant_documents DROP CONSTRAINT IF EXISTS applicant_documents_pkey;
ALTER TABLE IF EXISTS ONLY public.applicant_documents DROP CONSTRAINT IF EXISTS applicant_documents_application_id_doc_type_6a40cd0a_uniq;
ALTER TABLE IF EXISTS ONLY public.applicant_alt_contact DROP CONSTRAINT IF EXISTS applicant_alt_contact_pkey;
ALTER TABLE IF EXISTS ONLY public.applicant_alt_contact DROP CONSTRAINT IF EXISTS applicant_alt_contact_application_id_key;
DROP TABLE IF EXISTS public.tests;
DROP TABLE IF EXISTS public.test_questions;
DROP TABLE IF EXISTS public.test_choices;
DROP TABLE IF EXISTS public.test_attempts;
DROP TABLE IF EXISTS public.test_attempt_answers;
DROP TABLE IF EXISTS public.screening_actions;
DROP TABLE IF EXISTS public.recruitment_user_user_permissions;
DROP TABLE IF EXISTS public.recruitment_user_groups;
DROP TABLE IF EXISTS public.recruitment_user;
DROP TABLE IF EXISTS public.recruitment_cycles;
DROP TABLE IF EXISTS public.notifications;
DROP TABLE IF EXISTS public.interview_scores;
DROP TABLE IF EXISTS public.interview_schedules;
DROP TABLE IF EXISTS public.geo_provinces;
DROP TABLE IF EXISTS public.geo_districts;
DROP TABLE IF EXISTS public.final_selections;
DROP TABLE IF EXISTS public.django_session;
DROP TABLE IF EXISTS public.django_migrations;
DROP TABLE IF EXISTS public.django_content_type;
DROP TABLE IF EXISTS public.django_admin_log;
DROP TABLE IF EXISTS public.auth_permission;
DROP TABLE IF EXISTS public.auth_group_permissions;
DROP TABLE IF EXISTS public.auth_group;
DROP TABLE IF EXISTS public.audit_logs;
DROP TABLE IF EXISTS public.applications;
DROP TABLE IF EXISTS public.application_eligibility;
DROP TABLE IF EXISTS public.applicant_work_history;
DROP TABLE IF EXISTS public.applicant_references;
DROP TABLE IF EXISTS public.applicant_profiles;
DROP TABLE IF EXISTS public.applicant_parents;
DROP TABLE IF EXISTS public.applicant_education;
DROP TABLE IF EXISTS public.applicant_documents;
DROP TABLE IF EXISTS public.applicant_alt_contact;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: applicant_alt_contact; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicant_alt_contact (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    relationship character varying(80) NOT NULL,
    phone character varying(30) NOT NULL,
    address text NOT NULL,
    application_id bigint NOT NULL
);


ALTER TABLE public.applicant_alt_contact OWNER TO postgres;

--
-- Name: applicant_alt_contact_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.applicant_alt_contact ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.applicant_alt_contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: applicant_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicant_documents (
    id bigint NOT NULL,
    doc_type character varying(20) NOT NULL,
    file character varying(100) NOT NULL,
    uploaded_at timestamp with time zone NOT NULL,
    verify_status character varying(10) NOT NULL,
    verification_note text NOT NULL,
    verified_by_id bigint,
    application_id bigint NOT NULL
);


ALTER TABLE public.applicant_documents OWNER TO postgres;

--
-- Name: applicant_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.applicant_documents ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.applicant_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: applicant_education; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicant_education (
    id bigint NOT NULL,
    level character varying(12) NOT NULL,
    institution character varying(200) NOT NULL,
    start_year integer,
    end_year integer,
    certificate_title character varying(200) NOT NULL,
    gpa numeric(4,2),
    english_grade character varying(5) NOT NULL,
    mathematics_grade character varying(5) NOT NULL,
    science_grade character varying(5) NOT NULL,
    other_grade character varying(20) NOT NULL,
    province_id bigint,
    application_id bigint NOT NULL,
    CONSTRAINT applicant_education_end_year_check CHECK ((end_year >= 0)),
    CONSTRAINT applicant_education_start_year_check CHECK ((start_year >= 0))
);


ALTER TABLE public.applicant_education OWNER TO postgres;

--
-- Name: applicant_education_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.applicant_education ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.applicant_education_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: applicant_parents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicant_parents (
    id bigint NOT NULL,
    kind character varying(10) NOT NULL,
    name character varying(150) NOT NULL,
    phone character varying(30) NOT NULL,
    address text NOT NULL,
    is_alive boolean NOT NULL,
    applicant_id bigint NOT NULL
);


ALTER TABLE public.applicant_parents OWNER TO postgres;

--
-- Name: applicant_parents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.applicant_parents ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.applicant_parents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: applicant_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicant_profiles (
    id bigint NOT NULL,
    full_name character varying(150) NOT NULL,
    dob date NOT NULL,
    gender character varying(1) NOT NULL,
    nid_number character varying(30),
    photo character varying(100),
    address text NOT NULL,
    phone character varying(30) NOT NULL,
    highest_education_level integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    district_id bigint,
    province_id bigint,
    user_id bigint NOT NULL,
    email character varying(254) NOT NULL,
    province_of_origin_id bigint
);


ALTER TABLE public.applicant_profiles OWNER TO postgres;

--
-- Name: applicant_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.applicant_profiles ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.applicant_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: applicant_references; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicant_references (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    position_title character varying(120) NOT NULL,
    phone_number character varying(50) NOT NULL,
    email character varying(254) NOT NULL,
    application_id bigint NOT NULL
);


ALTER TABLE public.applicant_references OWNER TO postgres;

--
-- Name: applicant_references_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.applicant_references ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.applicant_references_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: applicant_work_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicant_work_history (
    id bigint NOT NULL,
    employer character varying(200) NOT NULL,
    "position" character varying(120) NOT NULL,
    start_date date,
    end_date date,
    duties text NOT NULL,
    application_id bigint NOT NULL
);


ALTER TABLE public.applicant_work_history OWNER TO postgres;

--
-- Name: applicant_work_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.applicant_work_history ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.applicant_work_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: application_eligibility; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.application_eligibility (
    id bigint NOT NULL,
    age_ok boolean NOT NULL,
    education_ok boolean NOT NULL,
    medical_ok boolean NOT NULL,
    police_ok boolean NOT NULL,
    duplicates_ok boolean NOT NULL,
    result character varying(4) NOT NULL,
    details jsonb,
    run_at timestamp with time zone NOT NULL,
    application_id bigint NOT NULL
);


ALTER TABLE public.application_eligibility OWNER TO postgres;

--
-- Name: application_eligibility_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.application_eligibility ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.application_eligibility_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applications (
    id bigint NOT NULL,
    status character varying(20) NOT NULL,
    applied_unit character varying(120) NOT NULL,
    auto_screen_score numeric(6,2) NOT NULL,
    manual_adjustment numeric(6,2) NOT NULL,
    test_score numeric(6,2) NOT NULL,
    interview_score numeric(6,2) NOT NULL,
    total_score numeric(7,2) NOT NULL,
    eligibility_passed boolean NOT NULL,
    disqualification_reason text NOT NULL,
    submitted_at timestamp with time zone,
    last_updated timestamp with time zone NOT NULL,
    applicant_id bigint NOT NULL,
    cycle_id bigint NOT NULL,
    criminal_conviction boolean,
    declaration_agreed boolean NOT NULL,
    from_bougainville boolean NOT NULL,
    reason_for_applying text NOT NULL,
    reservist_2021_2022 boolean NOT NULL,
    signature_date date,
    signature_name character varying(120) NOT NULL,
    years_experience character varying(8) NOT NULL,
    years_experience_other character varying(50) NOT NULL,
    rec_type character varying(10) NOT NULL
);


ALTER TABLE public.applications OWNER TO postgres;

--
-- Name: applications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.applications ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id bigint NOT NULL,
    action character varying(12) NOT NULL,
    entity character varying(80) NOT NULL,
    entity_id character varying(64) NOT NULL,
    payload jsonb,
    ip_address inet,
    created_at timestamp with time zone NOT NULL,
    actor_id bigint
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.audit_logs ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id bigint NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: final_selections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.final_selections (
    id bigint NOT NULL,
    rank integer NOT NULL,
    total_score_snapshot numeric(7,2) NOT NULL,
    approved_at timestamp with time zone NOT NULL,
    is_published boolean NOT NULL,
    offer_letter character varying(100),
    application_id bigint NOT NULL,
    approved_by_id bigint,
    CONSTRAINT final_selections_rank_check CHECK ((rank >= 0))
);


ALTER TABLE public.final_selections OWNER TO postgres;

--
-- Name: final_selections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.final_selections ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.final_selections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: geo_districts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geo_districts (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    province_id bigint NOT NULL
);


ALTER TABLE public.geo_districts OWNER TO postgres;

--
-- Name: geo_districts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.geo_districts ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.geo_districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: geo_provinces; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geo_provinces (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(10) NOT NULL
);


ALTER TABLE public.geo_provinces OWNER TO postgres;

--
-- Name: geo_provinces_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.geo_provinces ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.geo_provinces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: interview_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.interview_schedules (
    id bigint NOT NULL,
    scheduled_at timestamp with time zone NOT NULL,
    location character varying(200) NOT NULL,
    panel_name character varying(200) NOT NULL,
    status character varying(12) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    application_id bigint NOT NULL,
    created_by_id bigint
);


ALTER TABLE public.interview_schedules OWNER TO postgres;

--
-- Name: interview_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.interview_schedules ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.interview_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: interview_scores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.interview_scores (
    id bigint NOT NULL,
    score numeric(6,2) NOT NULL,
    remarks text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    interviewer_id bigint,
    schedule_id bigint NOT NULL
);


ALTER TABLE public.interview_scores OWNER TO postgres;

--
-- Name: interview_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.interview_scores ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.interview_scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    ntype character varying(12) NOT NULL,
    title character varying(160) NOT NULL,
    body text NOT NULL,
    is_read boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    ref_model character varying(60) NOT NULL,
    ref_id integer,
    user_id bigint NOT NULL,
    CONSTRAINT notifications_ref_id_check CHECK ((ref_id >= 0))
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.notifications ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: recruitment_cycles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recruitment_cycles (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    intake_year integer NOT NULL,
    rec_type character varying(10) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_active boolean NOT NULL,
    min_age smallint NOT NULL,
    max_age smallint NOT NULL,
    min_education_level integer NOT NULL,
    quotas jsonb,
    created_at timestamp with time zone NOT NULL,
    created_by_id bigint,
    CONSTRAINT recruitment_cycles_intake_year_check CHECK ((intake_year >= 0)),
    CONSTRAINT recruitment_cycles_max_age_check CHECK ((max_age >= 0)),
    CONSTRAINT recruitment_cycles_min_age_check CHECK ((min_age >= 0))
);


ALTER TABLE public.recruitment_cycles OWNER TO postgres;

--
-- Name: recruitment_cycles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.recruitment_cycles ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.recruitment_cycles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: recruitment_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recruitment_user (
    id bigint NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL,
    role character varying(16) NOT NULL,
    last_ip inet
);


ALTER TABLE public.recruitment_user OWNER TO postgres;

--
-- Name: recruitment_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recruitment_user_groups (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.recruitment_user_groups OWNER TO postgres;

--
-- Name: recruitment_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.recruitment_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.recruitment_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: recruitment_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.recruitment_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.recruitment_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: recruitment_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recruitment_user_user_permissions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.recruitment_user_user_permissions OWNER TO postgres;

--
-- Name: recruitment_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.recruitment_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.recruitment_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: screening_actions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.screening_actions (
    id bigint NOT NULL,
    auto_score numeric(6,2) NOT NULL,
    manual_adjustment numeric(6,2) NOT NULL,
    reason text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    application_id bigint NOT NULL,
    by_user_id bigint
);


ALTER TABLE public.screening_actions OWNER TO postgres;

--
-- Name: screening_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.screening_actions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.screening_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: test_attempt_answers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_attempt_answers (
    id bigint NOT NULL,
    is_correct boolean NOT NULL,
    awarded_points numeric(5,2) NOT NULL,
    attempt_id bigint NOT NULL,
    question_id bigint NOT NULL,
    selected_choice_id bigint
);


ALTER TABLE public.test_attempt_answers OWNER TO postgres;

--
-- Name: test_attempt_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.test_attempt_answers ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.test_attempt_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: test_attempts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_attempts (
    id bigint NOT NULL,
    status character varying(12) NOT NULL,
    started_at timestamp with time zone NOT NULL,
    submitted_at timestamp with time zone,
    score numeric(6,2) NOT NULL,
    application_id bigint NOT NULL,
    test_id bigint NOT NULL
);


ALTER TABLE public.test_attempts OWNER TO postgres;

--
-- Name: test_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.test_attempts ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.test_attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: test_choices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_choices (
    id bigint NOT NULL,
    text character varying(1000) NOT NULL,
    is_correct boolean NOT NULL,
    question_id bigint NOT NULL
);


ALTER TABLE public.test_choices OWNER TO postgres;

--
-- Name: test_choices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.test_choices ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.test_choices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: test_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_questions (
    id bigint NOT NULL,
    text text NOT NULL,
    points numeric(5,2) NOT NULL,
    "order" integer NOT NULL,
    test_id bigint NOT NULL,
    CONSTRAINT test_questions_order_check CHECK (("order" >= 0))
);


ALTER TABLE public.test_questions OWNER TO postgres;

--
-- Name: test_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.test_questions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.test_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tests (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    instructions text NOT NULL,
    duration_minutes integer NOT NULL,
    max_score numeric(6,2) NOT NULL,
    max_attempts smallint NOT NULL,
    opens_at timestamp with time zone NOT NULL,
    closes_at timestamp with time zone NOT NULL,
    is_published boolean NOT NULL,
    cycle_id bigint NOT NULL,
    CONSTRAINT tests_duration_minutes_check CHECK ((duration_minutes >= 0)),
    CONSTRAINT tests_max_attempts_check CHECK ((max_attempts >= 0))
);


ALTER TABLE public.tests OWNER TO postgres;

--
-- Name: tests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tests ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: applicant_alt_contact; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applicant_alt_contact (id, name, relationship, phone, address, application_id) FROM stdin;
1	Samuel KILA	Friend	71217327	Divie Word University\r\nPO Box 483\r\nMadang	1
2	Samuel KILA	Friend	71362893	Divine Word University\r\nPO Box 483\r\nMadang	2
\.


--
-- Data for Name: applicant_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applicant_documents (id, doc_type, file, uploaded_at, verify_status, verification_note, verified_by_id, application_id) FROM stdin;
\.


--
-- Data for Name: applicant_education; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applicant_education (id, level, institution, start_year, end_year, certificate_title, gpa, english_grade, mathematics_grade, science_grade, other_grade, province_id, application_id) FROM stdin;
1	G12	Sogeri Nationa High	2021	2022	Grade 12 certificate	3.60					2	1
2	BACHELOR	Divine Word	2022	2025	Bachelor Degree	3.00					4	2
\.


--
-- Data for Name: applicant_parents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applicant_parents (id, kind, name, phone, address, is_alive, applicant_id) FROM stdin;
\.


--
-- Data for Name: applicant_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applicant_profiles (id, full_name, dob, gender, nid_number, photo, address, phone, highest_education_level, created_at, district_id, province_id, user_id, email, province_of_origin_id) FROM stdin;
2	Sammy	2000-01-01	O	\N				12	2025-10-01 18:04:42.691138+10	\N	\N	2		\N
3	Kutubu	2000-01-01	O	\N				12	2025-10-01 21:52:58.796011+10	\N	\N	3		\N
4	Cyril	2000-01-01	M	250315200	applicants/4/photo/21.jpg		81634987	12	2025-10-02 00:18:14.922007+10	3	1	4	cryli@applicantt.com	2
1	admin2025	2000-01-01	O	250315320	applicants/1/photo/500227070_122158873034560795_2226696649861604858_n.jpg		71217327	12	2025-10-01 18:02:17.140487+10	5	2	1	cyril@gmail.com	1
5	Baguale	2000-01-01	O	\N				12	2025-10-02 11:33:52.860502+10	\N	\N	5		\N
6	Boi	2000-01-01	O	\N				12	2025-10-02 02:08:16.337622+10	\N	\N	6		\N
\.


--
-- Data for Name: applicant_references; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applicant_references (id, name, position_title, phone_number, email, application_id) FROM stdin;
1	Lyall Dale	HOD	70717273	ldale@gmail.com	1
2	Mathew Aiwe	DEAN	74737271	maiwe@gmail.com	1
3	Ruth Maku	WKSS CEO	67543210	rmaku@gmail.com	1
4	Lyall Dale	HOD	71176532	ldale@gmail.com	2
5	Mathew Aiwe	DEAN	83214567	maiwe@gmail.com	2
6	Samuel Ndranou	Lecturer	67543210	sd@gmail.com	2
\.


--
-- Data for Name: applicant_work_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applicant_work_history (id, employer, "position", start_date, end_date, duties, application_id) FROM stdin;
1	Kalas Construction	site supervisior	2019-01-29	\N	Supervising workers at the site location	1
2	Kalas Construction	site supervisior	2020-01-09	2022-01-01		2
\.


--
-- Data for Name: application_eligibility; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.application_eligibility (id, age_ok, education_ok, medical_ok, police_ok, duplicates_ok, result, details, run_at, application_id) FROM stdin;
1	t	t	f	f	t	FAIL	{"age": 25, "max_age": 30, "min_age": 18, "edu_level": 12, "min_edu_level": 12}	2025-10-02 08:03:23.441049+10	1
2	t	t	f	f	t	FAIL	{"age": 25, "max_age": 30, "min_age": 18, "edu_level": 12, "min_edu_level": 12}	2025-10-02 09:02:28.135276+10	2
\.


--
-- Data for Name: applications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applications (id, status, applied_unit, auto_screen_score, manual_adjustment, test_score, interview_score, total_score, eligibility_passed, disqualification_reason, submitted_at, last_updated, applicant_id, cycle_id, criminal_conviction, declaration_agreed, from_bougainville, reason_for_applying, reservist_2021_2022, signature_date, signature_name, years_experience, years_experience_other, rec_type) FROM stdin;
1	ACCEPTED	Cadet Officer	0.00	0.00	0.00	0.00	0.00	f	Medical clearance missing/not approved. Police clearance missing/not approved.	2025-10-02 08:03:23.39776+10	2025-10-02 09:09:53.891292+10	4	1	f	t	f	To serve the country with pride and transparency	f	2025-01-10	Cyril	1-2		REGULAR
2	SCREENING	Regular Police Officers	0.00	0.00	0.00	0.00	0.00	f	Medical clearance missing/not approved. Police clearance missing/not approved.	2025-10-02 09:02:28.1029+10	2025-10-02 15:09:41.563268+10	1	1	t	t	f	To uphold and strengthen partnership with community to enforce law and order for everyone	f	2025-10-01	Cyril	1-2		REGULAR
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (id, action, entity, entity_id, payload, ip_address, created_at, actor_id) FROM stdin;
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
1	Superuser
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	1	5
6	1	6
7	1	7
8	1	8
9	1	9
10	1	10
11	1	11
12	1	12
13	1	13
14	1	14
15	1	15
16	1	16
17	1	17
18	1	18
19	1	19
20	1	20
21	1	21
22	1	22
23	1	23
24	1	24
25	1	25
26	1	26
27	1	27
28	1	28
29	1	29
30	1	30
31	1	31
32	1	32
33	1	33
34	1	34
35	1	35
36	1	36
37	1	37
38	1	38
39	1	39
40	1	40
41	1	41
42	1	42
43	1	43
44	1	44
45	1	45
46	1	46
47	1	47
48	1	48
49	1	49
50	1	50
51	1	51
52	1	52
53	1	53
54	1	54
55	1	55
56	1	56
57	1	57
58	1	58
59	1	59
60	1	60
61	1	61
62	1	62
63	1	63
64	1	64
65	1	65
66	1	66
67	1	67
68	1	68
69	1	69
70	1	70
71	1	71
72	1	72
73	1	73
74	1	74
75	1	75
76	1	76
77	1	77
78	1	78
79	1	79
80	1	80
81	1	81
82	1	82
83	1	83
84	1	84
85	1	85
86	1	86
87	1	87
88	1	88
89	1	89
90	1	90
91	1	91
92	1	92
93	1	93
94	1	94
95	1	95
96	1	96
97	1	97
98	1	98
99	1	99
100	1	100
101	1	101
102	1	102
103	1	103
104	1	104
105	1	105
106	1	106
107	1	107
108	1	108
109	1	109
110	1	110
111	1	111
112	1	112
113	1	113
114	1	114
115	1	115
116	1	116
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add content type	4	add_contenttype
14	Can change content type	4	change_contenttype
15	Can delete content type	4	delete_contenttype
16	Can view content type	4	view_contenttype
17	Can add session	5	add_session
18	Can change session	5	change_session
19	Can delete session	5	delete_session
20	Can view session	5	view_session
21	Can add user	6	add_user
22	Can change user	6	change_user
23	Can delete user	6	delete_user
24	Can view user	6	view_user
25	Can add province	7	add_province
26	Can change province	7	change_province
27	Can delete province	7	delete_province
28	Can view province	7	view_province
29	Can add district	8	add_district
30	Can change district	8	change_district
31	Can delete district	8	delete_district
32	Can view district	8	view_district
33	Can add applicant profile	9	add_applicantprofile
34	Can change applicant profile	9	change_applicantprofile
35	Can delete applicant profile	9	delete_applicantprofile
36	Can view applicant profile	9	view_applicantprofile
37	Can add recruitment cycle	10	add_recruitmentcycle
38	Can change recruitment cycle	10	change_recruitmentcycle
39	Can delete recruitment cycle	10	delete_recruitmentcycle
40	Can view recruitment cycle	10	view_recruitmentcycle
41	Can add application	11	add_application
42	Can change application	11	change_application
43	Can delete application	11	delete_application
44	Can view application	11	view_application
45	Can add application eligibility	12	add_applicationeligibility
46	Can change application eligibility	12	change_applicationeligibility
47	Can delete application eligibility	12	delete_applicationeligibility
48	Can view application eligibility	12	view_applicationeligibility
49	Can add screening action	13	add_screeningaction
50	Can change screening action	13	change_screeningaction
51	Can delete screening action	13	delete_screeningaction
52	Can view screening action	13	view_screeningaction
53	Can add test	14	add_test
54	Can change test	14	change_test
55	Can delete test	14	delete_test
56	Can view test	14	view_test
57	Can add question	15	add_question
58	Can change question	15	change_question
59	Can delete question	15	delete_question
60	Can view question	15	view_question
61	Can add choice	16	add_choice
62	Can change choice	16	change_choice
63	Can delete choice	16	delete_choice
64	Can view choice	16	view_choice
65	Can add test attempt	17	add_testattempt
66	Can change test attempt	17	change_testattempt
67	Can delete test attempt	17	delete_testattempt
68	Can view test attempt	17	view_testattempt
69	Can add attempt answer	18	add_attemptanswer
70	Can change attempt answer	18	change_attemptanswer
71	Can delete attempt answer	18	delete_attemptanswer
72	Can view attempt answer	18	view_attemptanswer
73	Can add interview schedule	19	add_interviewschedule
74	Can change interview schedule	19	change_interviewschedule
75	Can delete interview schedule	19	delete_interviewschedule
76	Can view interview schedule	19	view_interviewschedule
77	Can add interview score	20	add_interviewscore
78	Can change interview score	20	change_interviewscore
79	Can delete interview score	20	delete_interviewscore
80	Can view interview score	20	view_interviewscore
81	Can add final selection	21	add_finalselection
82	Can change final selection	21	change_finalselection
83	Can delete final selection	21	delete_finalselection
84	Can view final selection	21	view_finalselection
85	Can add notification	22	add_notification
86	Can change notification	22	change_notification
87	Can delete notification	22	delete_notification
88	Can view notification	22	view_notification
89	Can add audit log	23	add_auditlog
90	Can change audit log	23	change_auditlog
91	Can delete audit log	23	delete_auditlog
92	Can view audit log	23	view_auditlog
93	Can add alternative contact	24	add_alternativecontact
94	Can change alternative contact	24	change_alternativecontact
95	Can delete alternative contact	24	delete_alternativecontact
96	Can view alternative contact	24	view_alternativecontact
97	Can add parent guardian	25	add_parentguardian
98	Can change parent guardian	25	change_parentguardian
99	Can delete parent guardian	25	delete_parentguardian
100	Can view parent guardian	25	view_parentguardian
101	Can add education record	26	add_educationrecord
102	Can change education record	26	change_educationrecord
103	Can delete education record	26	delete_educationrecord
104	Can view education record	26	view_educationrecord
105	Can add work history	27	add_workhistory
106	Can change work history	27	change_workhistory
107	Can delete work history	27	delete_workhistory
108	Can view work history	27	view_workhistory
109	Can add reference	28	add_reference
110	Can change reference	28	change_reference
111	Can delete reference	28	delete_reference
112	Can view reference	28	view_reference
113	Can add document	29	add_document
114	Can change document	29	change_document
115	Can delete document	29	delete_document
116	Can view document	29	view_document
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2025-10-01 18:06:56.928597+10	1	Superuser	1	[{"added": {}}]	3	1
2	2025-10-01 20:39:52.955767+10	1	admin2025	2	[{"changed": {"fields": ["First name", "Last name"]}}]	6	1
3	2025-10-02 00:40:09.643666+10	1	Royal Papua New Guinea Constabulary Recruitment Drive 2025 (Regular)	1	[{"added": {}}]	10	1
4	2025-10-02 07:46:15.368787+10	1	admin2025	2	[{"changed": {"fields": ["User permissions"]}}]	6	1
5	2025-10-02 07:48:01.867508+10	1	HELA	1	[{"added": {}}]	7	1
6	2025-10-02 07:48:17.813707+10	2	Southern Highlands	1	[{"added": {}}]	7	1
7	2025-10-02 07:48:26.599084+10	3	ENGA	1	[{"added": {}}]	7	1
8	2025-10-02 07:48:47.583635+10	4	Western Highlands	1	[{"added": {}}]	7	1
9	2025-10-02 07:48:55.193242+10	5	Jiwaka	1	[{"added": {}}]	7	1
10	2025-10-02 07:49:03.193737+10	6	Simbu	1	[{"added": {}}]	7	1
11	2025-10-02 07:49:21.105914+10	7	Eastern Highlands	1	[{"added": {}}]	7	1
12	2025-10-02 07:49:35.771445+10	8	Morobe	1	[{"added": {}}]	7	1
13	2025-10-02 07:49:52.165534+10	9	Madang	1	[{"added": {}}]	7	1
14	2025-10-02 07:50:01.729649+10	10	East Sepik	1	[{"added": {}}]	7	1
15	2025-10-02 07:50:45.526731+10	1	Tari Pori (01)	1	[{"added": {}}]	8	1
16	2025-10-02 07:51:00.396538+10	2	Magarima (01)	1	[{"added": {}}]	8	1
17	2025-10-02 07:51:15.742562+10	3	Komo Hulia (01)	1	[{"added": {}}]	8	1
18	2025-10-02 07:51:32.445042+10	4	Koroba Kopiago (01)	1	[{"added": {}}]	8	1
19	2025-10-02 07:51:44.6738+10	5	Nipa Kutubu (02)	1	[{"added": {}}]	8	1
20	2025-10-02 07:51:56.875058+10	6	Mendi Central (02)	1	[{"added": {}}]	8	1
21	2025-10-02 07:52:13.787726+10	7	Mendi Munihu (02)	1	[{"added": {}}]	8	1
22	2025-10-02 07:52:29.995274+10	8	Imbonggu (02)	1	[{"added": {}}]	8	1
23	2025-10-02 07:52:43.50411+10	9	Ialibu Pangia (02)	1	[{"added": {}}]	8	1
24	2025-10-02 07:52:59.650085+10	10	Kagua Erave (02)	1	[{"added": {}}]	8	1
25	2025-10-02 07:54:56.290223+10	2	Police Recruitment Alert 2025 (Cadet)	1	[{"added": {}}]	10	1
26	2025-10-02 08:08:52.866655+10	1	ScreeningAction object (1)	1	[{"added": {}}]	13	1
27	2025-10-02 08:31:46.456938+10	1	Cyril - Royal Papua New Guinea Constabulary Recruitment Drive 2025 (Regular)	2	[{"changed": {"fields": ["Status"]}}]	11	1
28	2025-10-02 09:09:53.926321+10	1	Cyril - Royal Papua New Guinea Constabulary Recruitment Drive 2025 (Regular)	2	[{"changed": {"fields": ["Status"]}}]	11	1
29	2025-10-02 13:13:29.740634+10	5	Baguale	2	[{"changed": {"fields": ["First name", "Last name", "Groups"]}}]	6	5
30	2025-10-02 15:09:41.590861+10	2	admin2025 - Royal Papua New Guinea Constabulary Recruitment Drive 2025 (Regular)	2	[{"changed": {"fields": ["Status"]}}]	11	5
31	2025-10-02 15:12:39.121398+10	1	Interview for App#1 at 2025-10-03 09:11:29	1	[{"added": {}}]	19	5
32	2025-10-02 15:17:48.899114+10	1	Interview for App#1 at 2025-10-03 09:11:29	2	[]	19	5
33	2025-10-02 15:21:00.560055+10	1	Entry Test (Royal Papua New Guinea Constabulary Recruitment Drive 2025 (Regular))	1	[{"added": {}}]	14	5
34	2025-10-02 15:47:07.732379+10	1	FinalSelection object (1)	1	[{"added": {}}]	21	5
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	contenttypes	contenttype
5	sessions	session
6	recruitment	user
7	recruitment	province
8	recruitment	district
9	recruitment	applicantprofile
10	recruitment	recruitmentcycle
11	recruitment	application
12	recruitment	applicationeligibility
13	recruitment	screeningaction
14	recruitment	test
15	recruitment	question
16	recruitment	choice
17	recruitment	testattempt
18	recruitment	attemptanswer
19	recruitment	interviewschedule
20	recruitment	interviewscore
21	recruitment	finalselection
22	recruitment	notification
23	recruitment	auditlog
24	recruitment	alternativecontact
25	recruitment	parentguardian
26	recruitment	educationrecord
27	recruitment	workhistory
28	recruitment	reference
29	recruitment	document
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
19	contenttypes	0001_initial	2025-09-25 07:13:38.622673+10
20	contenttypes	0002_remove_content_type_name	2025-09-25 07:13:38.631091+10
21	auth	0001_initial	2025-09-25 07:13:38.701641+10
22	auth	0002_alter_permission_name_max_length	2025-09-25 07:13:38.708023+10
23	auth	0003_alter_user_email_max_length	2025-09-25 07:13:38.710707+10
24	auth	0004_alter_user_username_opts	2025-09-25 07:13:38.715439+10
25	auth	0005_alter_user_last_login_null	2025-09-25 07:13:38.724556+10
26	auth	0006_require_contenttypes_0002	2025-09-25 07:13:38.724556+10
27	auth	0007_alter_validators_add_error_messages	2025-09-25 07:13:38.731905+10
28	auth	0008_alter_user_username_max_length	2025-09-25 07:13:38.74347+10
29	auth	0009_alter_user_last_name_max_length	2025-09-25 07:13:38.748911+10
30	auth	0010_alter_group_name_max_length	2025-09-25 07:13:38.758352+10
31	auth	0011_update_proxy_permissions	2025-09-25 07:13:38.765184+10
32	auth	0012_alter_user_first_name_max_length	2025-09-25 07:13:38.774311+10
33	recruitment	0001_initial	2025-09-25 07:13:39.582273+10
34	admin	0001_initial	2025-09-25 07:13:39.63534+10
35	admin	0002_logentry_remove_auto_add	2025-09-25 07:13:39.655668+10
36	admin	0003_logentry_add_action_flag_choices	2025-09-25 07:13:39.67017+10
37	recruitment	0002_profile_nid_nullable_and_constraint	2025-09-25 08:04:28.739509+10
38	sessions	0001_initial	2025-09-25 08:55:20.366516+10
39	recruitment	0003_full_form_structures	2025-09-25 10:34:17.496924+10
40	recruitment	0004_applicantprofile_email_and_more	2025-09-26 02:54:24.19181+10
41	recruitment	0005_create_reference	2025-09-26 08:14:53.554647+10
42	recruitment	0006_merge_20250925_1714	2025-09-26 08:14:53.558691+10
43	recruitment	0007_alter_reference_id_delete_backgroundreference	2025-09-26 11:57:05.092955+10
44	recruitment	0008_alter_educationrecord_province_and_more	2025-09-28 01:47:54.28905+10
45	recruitment	0009_migrate_education_province_fk	2025-09-28 01:47:54.404328+10
46	recruitment	0010_recruitmentcycle_criteria_alter_application_status	2025-09-28 03:43:26.171856+10
47	recruitment	0011_remove_recruitmentcycle_criteria	2025-09-28 06:01:05.325504+10
48	recruitment	0012_alter_document_unique_together_and_more	2025-10-01 17:26:49.559601+10
49	recruitment	0013_alter_alternativecontact_application_and_more	2025-10-01 17:55:20.086319+10
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
ighxs7s2gfddhxpq0iwypah5m4aszc8x	.eJxVjMEOgyAQRP-Fc0MWtkXosXe_gSywqK2BRPTU9N-riRdPk5k3M18x12Eqnpp4CtrWKm7C7zr6rfHip7THj2sWKH64HCC9qQxVxlrWZQryqMiTNtnXxPPr7F4ORmrjvrbRaAwQtQPmZFA5BURoFOiMgYOOQGgxZIjswFKyhyXMznadgbv4_QEUzT2A:1v3yDZ:EaVB61MuvBjNFGtv61zQ0T4EkfKnIKtSWCd-jrQ6GN0	2025-10-02 16:24:09.232431+10
vyvjucuxkdmhonp0qal84y8uft323klx	.eJxVjDEOwyAQBP9CHSEgBEPK9H4DugPOOLFAMnYV5e_BkhtXK83O7pctdZqLh8aeDPatshvzPbPfW1r9HDvWV4YQPqkcRXxDmSoPtWzrjPxQ-Nk2PtaYltfpXg4ytNzXZIyT7mHJKqkxIVhSyqIShowTNgodbdJCRj1IcDSgTMaFeyByJFED-_0BCmc93Q:1v41xo:aO3j-d1Yl7oW3wm4w-rPKJEwqcWAoYTPpT3ic1ApXzE	2025-10-02 05:24:08.51122+10
mblei42hfrmrs6t192nie095u7tmjmmc	.eJxVjEEKwyAURO_iuogGrabL7nsG-X6_0TYoxGRVevcqZJPVwJs382VrXXJx0NiDwbFXdmOuZ3JHo83l0LG6Mg_4oTKK8IayVI617Fv2fCj8bBt_1UDr83QvBwla6us4eznJYFEYbZQiHw1NdwHSGu1JK4lC0ECBpEW06EkRWugoinmO7PcHHxU-YQ:1v40lB:JpGtQ_h3KmTgPa_-q6mO0iaXgb2ur7Qd1qLREbo7HBY	2025-10-02 19:07:01.298962+10
\.


--
-- Data for Name: final_selections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.final_selections (id, rank, total_score_snapshot, approved_at, is_published, offer_letter, application_id, approved_by_id) FROM stdin;
1	1	75.00	2025-10-02 15:47:07.717394+10	t	offers/1/CONGRATULATIONS.pdf	1	5
\.


--
-- Data for Name: geo_districts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.geo_districts (id, name, province_id) FROM stdin;
1	Tari Pori	1
2	Magarima	1
3	Komo Hulia	1
4	Koroba Kopiago	1
5	Nipa Kutubu	2
6	Mendi Central	2
7	Mendi Munihu	2
8	Imbonggu	2
9	Ialibu Pangia	2
10	Kagua Erave	2
\.


--
-- Data for Name: geo_provinces; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.geo_provinces (id, name, code) FROM stdin;
1	HELA	01
2	Southern Highlands	02
3	ENGA	03
4	Western Highlands	04
5	Jiwaka	05
6	Simbu	06
7	Eastern Highlands	07
8	Morobe	08
9	Madang	09
10	East Sepik	10
\.


--
-- Data for Name: interview_schedules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.interview_schedules (id, scheduled_at, location, panel_name, status, created_at, application_id, created_by_id) FROM stdin;
1	2025-10-04 00:11:29+10	Jomba Police Station	Panel	SCHEDULED	2025-10-02 15:12:39.113896+10	1	5
\.


--
-- Data for Name: interview_scores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.interview_scores (id, score, remarks, created_at, interviewer_id, schedule_id) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, ntype, title, body, is_read, created_at, ref_model, ref_id, user_id) FROM stdin;
1	application_	Application status updated	Your application (ID 1) is now ACCEPTED.	t	2025-10-02 09:09:53.909321+10		\N	4
2	application_	Application status updated	Your application (ID 2) is now SCREENING.	f	2025-10-02 15:09:41.577285+10		\N	1
\.


--
-- Data for Name: recruitment_cycles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recruitment_cycles (id, name, intake_year, rec_type, start_date, end_date, is_active, min_age, max_age, min_education_level, quotas, created_at, created_by_id) FROM stdin;
1	Royal Papua New Guinea Constabulary Recruitment Drive	2025	REGULAR	2025-09-30	2025-11-15	t	18	30	12	2500	2025-10-02 00:40:09.632754+10	1
2	Police Recruitment Alert	2025	SPECIAL	2025-10-01	2025-11-27	t	18	30	12	3500	2025-10-02 07:54:56.286997+10	1
\.


--
-- Data for Name: recruitment_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recruitment_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined, role, last_ip) FROM stdin;
2	pbkdf2_sha256$600000$4hG2yDVdMVCvCUhsdtKEJS$B+AGrR1r0Z20hCVhmHD6jqSDZHcHkDSVHTZBnNrwWOU=	2025-10-01 18:04:42.698496+10	f	Sammy			190250@student.dwu.ac.pg	f	t	2025-10-01 18:04:42.116752+10	APPLICANT	\N
5	pbkdf2_sha256$1000000$zk0Laru3fxUIHmwdfSsRpX$MCG8SWnU9ca0I4mujN/idl3ziYzJrVOqoDxI+ClcUg0=	2025-10-02 04:45:58.630472+10	t	Baguale	Baguale	Sammy	baguale@gmail.com	t	t	2025-10-02 11:33:52+10	ADMIN	\N
4	pbkdf2_sha256$1000000$YVvMyVsZHVNNwL5KHxhKEC$jo5dC5f+RGUl8yzHh0leNwx6dk5KQJcXokOW2KsENN8=	2025-10-02 04:50:54.486199+10	f	Cyril			cyril@gmail.com	f	t	2025-10-02 00:18:14.600113+10	APPLICANT	\N
3	pbkdf2_sha256$600000$ifNDgTHOEMeeP3qFW7GsKK$xLCY45MuCIQqKJrznWIzzUh1eiLUf88bvmCoxWSpqUA=	2025-10-01 21:52:58.803469+10	f	Kutubu			kutubu123@gmail.com	f	t	2025-10-01 21:52:58.452776+10	APPLICANT	\N
1	pbkdf2_sha256$600000$GdeEesyHTKSCa0KNRtFXQx$wjYCDAPLv+XRL7w8hFrJ+Md6EqWbG6rQ0r/8kJDuVuQ=	2025-10-02 13:42:24.639387+10	t	admin2025	Admin	User	admin@rpngc.com	t	t	2025-10-01 18:02:16+10	APPLICANT	\N
6	pbkdf2_sha256$1000000$n5KAhj31MaF52LxuxMScDJ$VPNpW3wAKfkz/6dgl5pG57DZ49DZIP0svjLCCrDHTR4=	2025-10-02 03:03:18.570883+10	f	Boi			boiyal@rpngc.com	f	t	2025-10-02 02:08:15.651342+10	APPLICANT	\N
\.


--
-- Data for Name: recruitment_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recruitment_user_groups (id, user_id, group_id) FROM stdin;
1	5	1
\.


--
-- Data for Name: recruitment_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recruitment_user_user_permissions (id, user_id, permission_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	1	5
6	1	6
7	1	7
8	1	8
9	1	9
10	1	10
11	1	11
12	1	12
13	1	13
14	1	14
15	1	15
16	1	16
17	1	17
18	1	18
19	1	19
20	1	20
21	1	21
22	1	22
23	1	23
24	1	24
25	1	25
26	1	26
27	1	27
28	1	28
29	1	29
30	1	30
31	1	31
32	1	32
33	1	33
34	1	34
35	1	35
36	1	36
37	1	37
38	1	38
39	1	39
40	1	40
41	1	41
42	1	42
43	1	43
44	1	44
45	1	45
46	1	46
47	1	47
48	1	48
49	1	49
50	1	50
51	1	51
52	1	52
53	1	53
54	1	54
55	1	55
56	1	56
57	1	57
58	1	58
59	1	59
60	1	60
61	1	61
62	1	62
63	1	63
64	1	64
65	1	65
66	1	66
67	1	67
68	1	68
69	1	69
70	1	70
71	1	71
72	1	72
73	1	73
74	1	74
75	1	75
76	1	76
77	1	77
78	1	78
79	1	79
80	1	80
81	1	81
82	1	82
83	1	83
84	1	84
85	1	85
86	1	86
87	1	87
88	1	88
89	1	89
90	1	90
91	1	91
92	1	92
93	1	93
94	1	94
95	1	95
96	1	96
97	1	97
98	1	98
99	1	99
100	1	100
101	1	101
102	1	102
103	1	103
104	1	104
105	1	105
106	1	106
107	1	107
108	1	108
109	1	109
110	1	110
111	1	111
112	1	112
113	1	113
114	1	114
115	1	115
116	1	116
\.


--
-- Data for Name: screening_actions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.screening_actions (id, auto_score, manual_adjustment, reason, created_at, application_id, by_user_id) FROM stdin;
1	60.00	25.00		2025-10-02 08:08:52.854116+10	1	1
\.


--
-- Data for Name: test_attempt_answers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_attempt_answers (id, is_correct, awarded_points, attempt_id, question_id, selected_choice_id) FROM stdin;
\.


--
-- Data for Name: test_attempts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_attempts (id, status, started_at, submitted_at, score, application_id, test_id) FROM stdin;
\.


--
-- Data for Name: test_choices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_choices (id, text, is_correct, question_id) FROM stdin;
\.


--
-- Data for Name: test_questions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_questions (id, text, points, "order", test_id) FROM stdin;
\.


--
-- Data for Name: tests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tests (id, name, instructions, duration_minutes, max_score, max_attempts, opens_at, closes_at, is_published, cycle_id) FROM stdin;
1	Entry Test	Write an essay of 250 words about why you should be considered for this recruitment.	30	100.00	1	2025-10-02 09:00:00+10	2025-10-04 15:00:00+10	t	1
\.


--
-- Name: applicant_alt_contact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applicant_alt_contact_id_seq', 2, true);


--
-- Name: applicant_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applicant_documents_id_seq', 1, false);


--
-- Name: applicant_education_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applicant_education_id_seq', 2, true);


--
-- Name: applicant_parents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applicant_parents_id_seq', 1, false);


--
-- Name: applicant_profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applicant_profiles_id_seq', 6, true);


--
-- Name: applicant_references_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applicant_references_id_seq', 6, true);


--
-- Name: applicant_work_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applicant_work_history_id_seq', 2, true);


--
-- Name: application_eligibility_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.application_eligibility_id_seq', 2, true);


--
-- Name: applications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applications_id_seq', 2, true);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 1, false);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, true);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 116, true);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 116, true);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 34, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 29, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 49, true);


--
-- Name: final_selections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.final_selections_id_seq', 1, true);


--
-- Name: geo_districts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.geo_districts_id_seq', 10, true);


--
-- Name: geo_provinces_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.geo_provinces_id_seq', 10, true);


--
-- Name: interview_schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.interview_schedules_id_seq', 1, true);


--
-- Name: interview_scores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.interview_scores_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 2, true);


--
-- Name: recruitment_cycles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recruitment_cycles_id_seq', 2, true);


--
-- Name: recruitment_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recruitment_user_groups_id_seq', 1, true);


--
-- Name: recruitment_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recruitment_user_id_seq', 6, true);


--
-- Name: recruitment_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recruitment_user_user_permissions_id_seq', 116, true);


--
-- Name: screening_actions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.screening_actions_id_seq', 1, true);


--
-- Name: test_attempt_answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.test_attempt_answers_id_seq', 1, false);


--
-- Name: test_attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.test_attempts_id_seq', 1, false);


--
-- Name: test_choices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.test_choices_id_seq', 1, false);


--
-- Name: test_questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.test_questions_id_seq', 1, false);


--
-- Name: tests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tests_id_seq', 1, true);


--
-- Name: applicant_alt_contact applicant_alt_contact_application_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_alt_contact
    ADD CONSTRAINT applicant_alt_contact_application_id_key UNIQUE (application_id);


--
-- Name: applicant_alt_contact applicant_alt_contact_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_alt_contact
    ADD CONSTRAINT applicant_alt_contact_pkey PRIMARY KEY (id);


--
-- Name: applicant_documents applicant_documents_application_id_doc_type_6a40cd0a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_documents
    ADD CONSTRAINT applicant_documents_application_id_doc_type_6a40cd0a_uniq UNIQUE (application_id, doc_type);


--
-- Name: applicant_documents applicant_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_documents
    ADD CONSTRAINT applicant_documents_pkey PRIMARY KEY (id);


--
-- Name: applicant_education applicant_education_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_education
    ADD CONSTRAINT applicant_education_pkey PRIMARY KEY (id);


--
-- Name: applicant_parents applicant_parents_applicant_id_kind_845cda11_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_parents
    ADD CONSTRAINT applicant_parents_applicant_id_kind_845cda11_uniq UNIQUE (applicant_id, kind);


--
-- Name: applicant_parents applicant_parents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_parents
    ADD CONSTRAINT applicant_parents_pkey PRIMARY KEY (id);


--
-- Name: applicant_profiles applicant_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_profiles
    ADD CONSTRAINT applicant_profiles_pkey PRIMARY KEY (id);


--
-- Name: applicant_profiles applicant_profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_profiles
    ADD CONSTRAINT applicant_profiles_user_id_key UNIQUE (user_id);


--
-- Name: applicant_references applicant_references_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_references
    ADD CONSTRAINT applicant_references_pkey PRIMARY KEY (id);


--
-- Name: applicant_work_history applicant_work_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_work_history
    ADD CONSTRAINT applicant_work_history_pkey PRIMARY KEY (id);


--
-- Name: application_eligibility application_eligibility_application_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_eligibility
    ADD CONSTRAINT application_eligibility_application_id_key UNIQUE (application_id);


--
-- Name: application_eligibility application_eligibility_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_eligibility
    ADD CONSTRAINT application_eligibility_pkey PRIMARY KEY (id);


--
-- Name: applications applications_applicant_id_cycle_id_b76bd2f1_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_applicant_id_cycle_id_b76bd2f1_uniq UNIQUE (applicant_id, cycle_id);


--
-- Name: applications applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: final_selections final_selections_application_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_selections
    ADD CONSTRAINT final_selections_application_id_key UNIQUE (application_id);


--
-- Name: final_selections final_selections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_selections
    ADD CONSTRAINT final_selections_pkey PRIMARY KEY (id);


--
-- Name: geo_districts geo_districts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_districts
    ADD CONSTRAINT geo_districts_pkey PRIMARY KEY (id);


--
-- Name: geo_districts geo_districts_province_id_name_73514ca6_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_districts
    ADD CONSTRAINT geo_districts_province_id_name_73514ca6_uniq UNIQUE (province_id, name);


--
-- Name: geo_provinces geo_provinces_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_provinces
    ADD CONSTRAINT geo_provinces_code_key UNIQUE (code);


--
-- Name: geo_provinces geo_provinces_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_provinces
    ADD CONSTRAINT geo_provinces_name_key UNIQUE (name);


--
-- Name: geo_provinces geo_provinces_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_provinces
    ADD CONSTRAINT geo_provinces_pkey PRIMARY KEY (id);


--
-- Name: interview_schedules interview_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interview_schedules
    ADD CONSTRAINT interview_schedules_pkey PRIMARY KEY (id);


--
-- Name: interview_scores interview_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interview_scores
    ADD CONSTRAINT interview_scores_pkey PRIMARY KEY (id);


--
-- Name: interview_scores interview_scores_schedule_id_interviewer_id_16443a5a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interview_scores
    ADD CONSTRAINT interview_scores_schedule_id_interviewer_id_16443a5a_uniq UNIQUE (schedule_id, interviewer_id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: recruitment_cycles recruitment_cycles_intake_year_name_rec_type_25cbdf1f_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_cycles
    ADD CONSTRAINT recruitment_cycles_intake_year_name_rec_type_25cbdf1f_uniq UNIQUE (intake_year, name, rec_type);


--
-- Name: recruitment_cycles recruitment_cycles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_cycles
    ADD CONSTRAINT recruitment_cycles_pkey PRIMARY KEY (id);


--
-- Name: recruitment_user_groups recruitment_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_user_groups
    ADD CONSTRAINT recruitment_user_groups_pkey PRIMARY KEY (id);


--
-- Name: recruitment_user_groups recruitment_user_groups_user_id_group_id_5ef744f5_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_user_groups
    ADD CONSTRAINT recruitment_user_groups_user_id_group_id_5ef744f5_uniq UNIQUE (user_id, group_id);


--
-- Name: recruitment_user recruitment_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_user
    ADD CONSTRAINT recruitment_user_pkey PRIMARY KEY (id);


--
-- Name: recruitment_user_user_permissions recruitment_user_user_pe_user_id_permission_id_c4902334_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_user_user_permissions
    ADD CONSTRAINT recruitment_user_user_pe_user_id_permission_id_c4902334_uniq UNIQUE (user_id, permission_id);


--
-- Name: recruitment_user_user_permissions recruitment_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_user_user_permissions
    ADD CONSTRAINT recruitment_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: recruitment_user recruitment_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_user
    ADD CONSTRAINT recruitment_user_username_key UNIQUE (username);


--
-- Name: screening_actions screening_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screening_actions
    ADD CONSTRAINT screening_actions_pkey PRIMARY KEY (id);


--
-- Name: test_attempt_answers test_attempt_answers_attempt_id_question_id_314a843e_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_attempt_answers
    ADD CONSTRAINT test_attempt_answers_attempt_id_question_id_314a843e_uniq UNIQUE (attempt_id, question_id);


--
-- Name: test_attempt_answers test_attempt_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_attempt_answers
    ADD CONSTRAINT test_attempt_answers_pkey PRIMARY KEY (id);


--
-- Name: test_attempts test_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_attempts
    ADD CONSTRAINT test_attempts_pkey PRIMARY KEY (id);


--
-- Name: test_attempts test_attempts_test_id_application_id_d2e56db8_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_attempts
    ADD CONSTRAINT test_attempts_test_id_application_id_d2e56db8_uniq UNIQUE (test_id, application_id);


--
-- Name: test_choices test_choices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_choices
    ADD CONSTRAINT test_choices_pkey PRIMARY KEY (id);


--
-- Name: test_questions test_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_questions
    ADD CONSTRAINT test_questions_pkey PRIMARY KEY (id);


--
-- Name: tests tests_cycle_id_name_063fba1d_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_cycle_id_name_063fba1d_uniq UNIQUE (cycle_id, name);


--
-- Name: tests tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_pkey PRIMARY KEY (id);


--
-- Name: applicant_d_doc_typ_83ede9_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applicant_d_doc_typ_83ede9_idx ON public.applicant_documents USING btree (doc_type, verify_status);


--
-- Name: applicant_documents_application_id_fddf6e3c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applicant_documents_application_id_fddf6e3c ON public.applicant_documents USING btree (application_id);


--
-- Name: applicant_documents_doc_type_49ea08de; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applicant_documents_doc_type_49ea08de ON public.applicant_documents USING btree (doc_type);


--
-- Name: applicant_documents_doc_type_49ea08de_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applicant_documents_doc_type_49ea08de_like ON public.applicant_documents USING btree (doc_type varchar_pattern_ops);


--
-- Name: applicant_documents_verified_by_id_2822d2dd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applicant_documents_verified_by_id_2822d2dd ON public.applicant_documents USING btree (verified_by_id);


--
-- Name: applicant_education_application_id_f175a15b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applicant_education_application_id_f175a15b ON public.applicant_education USING btree (application_id);


--
-- Name: applicant_education_province_id_69864504; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applicant_education_province_id_69864504 ON public.applicant_education USING btree (province_id);


--
-- Name: applicant_parents_applicant_id_18eefeac; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applicant_parents_applicant_id_18eefeac ON public.applicant_parents USING btree (applicant_id);


--
-- Name: applicant_profiles_district_id_9a16ee01; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applicant_profiles_district_id_9a16ee01 ON public.applicant_profiles USING btree (district_id);


--
-- Name: applicant_profiles_province_id_f9083536; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applicant_profiles_province_id_f9083536 ON public.applicant_profiles USING btree (province_id);


--
-- Name: applicant_profiles_province_of_origin_id_b8864a9e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applicant_profiles_province_of_origin_id_b8864a9e ON public.applicant_profiles USING btree (province_of_origin_id);


--
-- Name: applicant_references_application_id_8040aa72; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applicant_references_application_id_8040aa72 ON public.applicant_references USING btree (application_id);


--
-- Name: applicant_work_history_application_id_42e72e7c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applicant_work_history_application_id_42e72e7c ON public.applicant_work_history USING btree (application_id);


--
-- Name: application_cycle_i_a4dfc5_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX application_cycle_i_a4dfc5_idx ON public.applications USING btree (cycle_id, total_score);


--
-- Name: application_cycle_i_fedbb2_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX application_cycle_i_fedbb2_idx ON public.applications USING btree (cycle_id, status);


--
-- Name: application_rec_typ_08c951_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX application_rec_typ_08c951_idx ON public.applications USING btree (rec_type);


--
-- Name: applications_applicant_id_0f5ee165; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applications_applicant_id_0f5ee165 ON public.applications USING btree (applicant_id);


--
-- Name: applications_cycle_id_809b7ab4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applications_cycle_id_809b7ab4 ON public.applications USING btree (cycle_id);


--
-- Name: applications_rec_type_1e3bb44c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applications_rec_type_1e3bb44c ON public.applications USING btree (rec_type);


--
-- Name: applications_rec_type_1e3bb44c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applications_rec_type_1e3bb44c_like ON public.applications USING btree (rec_type varchar_pattern_ops);


--
-- Name: applications_status_cbf6eacc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applications_status_cbf6eacc ON public.applications USING btree (status);


--
-- Name: applications_status_cbf6eacc_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applications_status_cbf6eacc_like ON public.applications USING btree (status varchar_pattern_ops);


--
-- Name: applications_total_score_ff488a83; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX applications_total_score_ff488a83 ON public.applications USING btree (total_score);


--
-- Name: audit_logs_action_327a0be3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_logs_action_327a0be3 ON public.audit_logs USING btree (action);


--
-- Name: audit_logs_action_327a0be3_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_logs_action_327a0be3_like ON public.audit_logs USING btree (action varchar_pattern_ops);


--
-- Name: audit_logs_action_5fd1bf_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_logs_action_5fd1bf_idx ON public.audit_logs USING btree (action, entity);


--
-- Name: audit_logs_actor_id_303d1495; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_logs_actor_id_303d1495 ON public.audit_logs USING btree (actor_id);


--
-- Name: audit_logs_created_262184_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX audit_logs_created_262184_idx ON public.audit_logs USING btree (created_at);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: final_selections_approved_by_id_b6ba3b39; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX final_selections_approved_by_id_b6ba3b39 ON public.final_selections USING btree (approved_by_id);


--
-- Name: final_selections_rank_5644370b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX final_selections_rank_5644370b ON public.final_selections USING btree (rank);


--
-- Name: geo_districts_province_id_416bbbec; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX geo_districts_province_id_416bbbec ON public.geo_districts USING btree (province_id);


--
-- Name: geo_provinces_code_490ae875_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX geo_provinces_code_490ae875_like ON public.geo_provinces USING btree (code varchar_pattern_ops);


--
-- Name: geo_provinces_name_aafdd58f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX geo_provinces_name_aafdd58f_like ON public.geo_provinces USING btree (name varchar_pattern_ops);


--
-- Name: interview_schedules_application_id_7a7f8ea6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX interview_schedules_application_id_7a7f8ea6 ON public.interview_schedules USING btree (application_id);


--
-- Name: interview_schedules_created_by_id_43f43106; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX interview_schedules_created_by_id_43f43106 ON public.interview_schedules USING btree (created_by_id);


--
-- Name: interview_scores_interviewer_id_13dc829d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX interview_scores_interviewer_id_13dc829d ON public.interview_scores USING btree (interviewer_id);


--
-- Name: interview_scores_schedule_id_c30026f3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX interview_scores_schedule_id_c30026f3 ON public.interview_scores USING btree (schedule_id);


--
-- Name: notificatio_user_id_dc2a8e_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notificatio_user_id_dc2a8e_idx ON public.notifications USING btree (user_id, is_read, ntype);


--
-- Name: notifications_ntype_3117b425; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_ntype_3117b425 ON public.notifications USING btree (ntype);


--
-- Name: notifications_ntype_3117b425_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_ntype_3117b425_like ON public.notifications USING btree (ntype varchar_pattern_ops);


--
-- Name: notifications_user_id_468e288d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_user_id_468e288d ON public.notifications USING btree (user_id);


--
-- Name: recruitment_cycles_created_by_id_9d1a5d92; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recruitment_cycles_created_by_id_9d1a5d92 ON public.recruitment_cycles USING btree (created_by_id);


--
-- Name: recruitment_cycles_rec_type_110f45bc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recruitment_cycles_rec_type_110f45bc ON public.recruitment_cycles USING btree (rec_type);


--
-- Name: recruitment_cycles_rec_type_110f45bc_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recruitment_cycles_rec_type_110f45bc_like ON public.recruitment_cycles USING btree (rec_type varchar_pattern_ops);


--
-- Name: recruitment_user_groups_group_id_e5f6bf13; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recruitment_user_groups_group_id_e5f6bf13 ON public.recruitment_user_groups USING btree (group_id);


--
-- Name: recruitment_user_groups_user_id_62abfa8c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recruitment_user_groups_user_id_62abfa8c ON public.recruitment_user_groups USING btree (user_id);


--
-- Name: recruitment_user_role_2ae0f92b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recruitment_user_role_2ae0f92b ON public.recruitment_user USING btree (role);


--
-- Name: recruitment_user_role_2ae0f92b_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recruitment_user_role_2ae0f92b_like ON public.recruitment_user USING btree (role varchar_pattern_ops);


--
-- Name: recruitment_user_user_permissions_permission_id_fdb1bf3e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recruitment_user_user_permissions_permission_id_fdb1bf3e ON public.recruitment_user_user_permissions USING btree (permission_id);


--
-- Name: recruitment_user_user_permissions_user_id_6b57dee3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recruitment_user_user_permissions_user_id_6b57dee3 ON public.recruitment_user_user_permissions USING btree (user_id);


--
-- Name: recruitment_user_username_8be4a9c8_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX recruitment_user_username_8be4a9c8_like ON public.recruitment_user USING btree (username varchar_pattern_ops);


--
-- Name: screening_actions_application_id_ebd21d46; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screening_actions_application_id_ebd21d46 ON public.screening_actions USING btree (application_id);


--
-- Name: screening_actions_by_user_id_01160d76; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screening_actions_by_user_id_01160d76 ON public.screening_actions USING btree (by_user_id);


--
-- Name: test_attemp_test_id_9cfba9_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX test_attemp_test_id_9cfba9_idx ON public.test_attempts USING btree (test_id, application_id, status);


--
-- Name: test_attempt_answers_attempt_id_c28276bb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX test_attempt_answers_attempt_id_c28276bb ON public.test_attempt_answers USING btree (attempt_id);


--
-- Name: test_attempt_answers_question_id_b181ce43; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX test_attempt_answers_question_id_b181ce43 ON public.test_attempt_answers USING btree (question_id);


--
-- Name: test_attempt_answers_selected_choice_id_b42c31d4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX test_attempt_answers_selected_choice_id_b42c31d4 ON public.test_attempt_answers USING btree (selected_choice_id);


--
-- Name: test_attempts_application_id_c2086b9d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX test_attempts_application_id_c2086b9d ON public.test_attempts USING btree (application_id);


--
-- Name: test_attempts_test_id_cea68c14; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX test_attempts_test_id_cea68c14 ON public.test_attempts USING btree (test_id);


--
-- Name: test_choices_question_id_aae26ef5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX test_choices_question_id_aae26ef5 ON public.test_choices USING btree (question_id);


--
-- Name: test_questions_order_d4b4c35e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX test_questions_order_d4b4c35e ON public.test_questions USING btree ("order");


--
-- Name: test_questions_test_id_a208ce1d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX test_questions_test_id_a208ce1d ON public.test_questions USING btree (test_id);


--
-- Name: tests_cycle_id_84e5a6af; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tests_cycle_id_84e5a6af ON public.tests USING btree (cycle_id);


--
-- Name: uniq_nid_when_present_ci; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_nid_when_present_ci ON public.applicant_profiles USING btree (lower((nid_number)::text)) WHERE ((nid_number IS NOT NULL) AND (NOT (((nid_number)::text = ''::text) AND (nid_number IS NOT NULL))));


--
-- Name: applicant_alt_contact applicant_alt_contac_application_id_4b1e42f7_fk_applicati; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_alt_contact
    ADD CONSTRAINT applicant_alt_contac_application_id_4b1e42f7_fk_applicati FOREIGN KEY (application_id) REFERENCES public.applications(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: applicant_documents applicant_documents_application_id_fddf6e3c_fk_applications_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_documents
    ADD CONSTRAINT applicant_documents_application_id_fddf6e3c_fk_applications_id FOREIGN KEY (application_id) REFERENCES public.applications(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: applicant_documents applicant_documents_verified_by_id_2822d2dd_fk_recruitme; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_documents
    ADD CONSTRAINT applicant_documents_verified_by_id_2822d2dd_fk_recruitme FOREIGN KEY (verified_by_id) REFERENCES public.recruitment_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: applicant_education applicant_education_application_id_f175a15b_fk_applications_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_education
    ADD CONSTRAINT applicant_education_application_id_f175a15b_fk_applications_id FOREIGN KEY (application_id) REFERENCES public.applications(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: applicant_education applicant_education_province_id_69864504_fk_geo_provinces_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_education
    ADD CONSTRAINT applicant_education_province_id_69864504_fk_geo_provinces_id FOREIGN KEY (province_id) REFERENCES public.geo_provinces(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: applicant_parents applicant_parents_applicant_id_18eefeac_fk_applicant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_parents
    ADD CONSTRAINT applicant_parents_applicant_id_18eefeac_fk_applicant FOREIGN KEY (applicant_id) REFERENCES public.applicant_profiles(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: applicant_profiles applicant_profiles_district_id_9a16ee01_fk_geo_districts_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_profiles
    ADD CONSTRAINT applicant_profiles_district_id_9a16ee01_fk_geo_districts_id FOREIGN KEY (district_id) REFERENCES public.geo_districts(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: applicant_profiles applicant_profiles_province_id_f9083536_fk_geo_provinces_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_profiles
    ADD CONSTRAINT applicant_profiles_province_id_f9083536_fk_geo_provinces_id FOREIGN KEY (province_id) REFERENCES public.geo_provinces(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: applicant_profiles applicant_profiles_province_of_origin_i_b8864a9e_fk_geo_provi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_profiles
    ADD CONSTRAINT applicant_profiles_province_of_origin_i_b8864a9e_fk_geo_provi FOREIGN KEY (province_of_origin_id) REFERENCES public.geo_provinces(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: applicant_profiles applicant_profiles_user_id_07bdf848_fk_recruitment_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_profiles
    ADD CONSTRAINT applicant_profiles_user_id_07bdf848_fk_recruitment_user_id FOREIGN KEY (user_id) REFERENCES public.recruitment_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: applicant_references applicant_references_application_id_8040aa72_fk_applications_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_references
    ADD CONSTRAINT applicant_references_application_id_8040aa72_fk_applications_id FOREIGN KEY (application_id) REFERENCES public.applications(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: applicant_work_history applicant_work_histo_application_id_42e72e7c_fk_applicati; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_work_history
    ADD CONSTRAINT applicant_work_histo_application_id_42e72e7c_fk_applicati FOREIGN KEY (application_id) REFERENCES public.applications(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: application_eligibility application_eligibil_application_id_7ee9a67b_fk_applicati; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.application_eligibility
    ADD CONSTRAINT application_eligibil_application_id_7ee9a67b_fk_applicati FOREIGN KEY (application_id) REFERENCES public.applications(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: applications applications_applicant_id_0f5ee165_fk_applicant_profiles_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_applicant_id_0f5ee165_fk_applicant_profiles_id FOREIGN KEY (applicant_id) REFERENCES public.applicant_profiles(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: applications applications_cycle_id_809b7ab4_fk_recruitment_cycles_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_cycle_id_809b7ab4_fk_recruitment_cycles_id FOREIGN KEY (cycle_id) REFERENCES public.recruitment_cycles(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: audit_logs audit_logs_actor_id_303d1495_fk_recruitment_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_actor_id_303d1495_fk_recruitment_user_id FOREIGN KEY (actor_id) REFERENCES public.recruitment_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_recruitment_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_recruitment_user_id FOREIGN KEY (user_id) REFERENCES public.recruitment_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: final_selections final_selections_application_id_81ca0ad3_fk_applications_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_selections
    ADD CONSTRAINT final_selections_application_id_81ca0ad3_fk_applications_id FOREIGN KEY (application_id) REFERENCES public.applications(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: final_selections final_selections_approved_by_id_b6ba3b39_fk_recruitment_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_selections
    ADD CONSTRAINT final_selections_approved_by_id_b6ba3b39_fk_recruitment_user_id FOREIGN KEY (approved_by_id) REFERENCES public.recruitment_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: geo_districts geo_districts_province_id_416bbbec_fk_geo_provinces_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geo_districts
    ADD CONSTRAINT geo_districts_province_id_416bbbec_fk_geo_provinces_id FOREIGN KEY (province_id) REFERENCES public.geo_provinces(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: interview_schedules interview_schedules_application_id_7a7f8ea6_fk_applications_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interview_schedules
    ADD CONSTRAINT interview_schedules_application_id_7a7f8ea6_fk_applications_id FOREIGN KEY (application_id) REFERENCES public.applications(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: interview_schedules interview_schedules_created_by_id_43f43106_fk_recruitme; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interview_schedules
    ADD CONSTRAINT interview_schedules_created_by_id_43f43106_fk_recruitme FOREIGN KEY (created_by_id) REFERENCES public.recruitment_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: interview_scores interview_scores_interviewer_id_13dc829d_fk_recruitment_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interview_scores
    ADD CONSTRAINT interview_scores_interviewer_id_13dc829d_fk_recruitment_user_id FOREIGN KEY (interviewer_id) REFERENCES public.recruitment_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: interview_scores interview_scores_schedule_id_c30026f3_fk_interview_schedules_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interview_scores
    ADD CONSTRAINT interview_scores_schedule_id_c30026f3_fk_interview_schedules_id FOREIGN KEY (schedule_id) REFERENCES public.interview_schedules(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: notifications notifications_user_id_468e288d_fk_recruitment_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_468e288d_fk_recruitment_user_id FOREIGN KEY (user_id) REFERENCES public.recruitment_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: recruitment_cycles recruitment_cycles_created_by_id_9d1a5d92_fk_recruitme; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_cycles
    ADD CONSTRAINT recruitment_cycles_created_by_id_9d1a5d92_fk_recruitme FOREIGN KEY (created_by_id) REFERENCES public.recruitment_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: recruitment_user_groups recruitment_user_groups_group_id_e5f6bf13_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_user_groups
    ADD CONSTRAINT recruitment_user_groups_group_id_e5f6bf13_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: recruitment_user_groups recruitment_user_groups_user_id_62abfa8c_fk_recruitment_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_user_groups
    ADD CONSTRAINT recruitment_user_groups_user_id_62abfa8c_fk_recruitment_user_id FOREIGN KEY (user_id) REFERENCES public.recruitment_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: recruitment_user_user_permissions recruitment_user_use_permission_id_fdb1bf3e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_user_user_permissions
    ADD CONSTRAINT recruitment_user_use_permission_id_fdb1bf3e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: recruitment_user_user_permissions recruitment_user_use_user_id_6b57dee3_fk_recruitme; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recruitment_user_user_permissions
    ADD CONSTRAINT recruitment_user_use_user_id_6b57dee3_fk_recruitme FOREIGN KEY (user_id) REFERENCES public.recruitment_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: screening_actions screening_actions_application_id_ebd21d46_fk_applications_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screening_actions
    ADD CONSTRAINT screening_actions_application_id_ebd21d46_fk_applications_id FOREIGN KEY (application_id) REFERENCES public.applications(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: screening_actions screening_actions_by_user_id_01160d76_fk_recruitment_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screening_actions
    ADD CONSTRAINT screening_actions_by_user_id_01160d76_fk_recruitment_user_id FOREIGN KEY (by_user_id) REFERENCES public.recruitment_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_attempt_answers test_attempt_answers_attempt_id_c28276bb_fk_test_attempts_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_attempt_answers
    ADD CONSTRAINT test_attempt_answers_attempt_id_c28276bb_fk_test_attempts_id FOREIGN KEY (attempt_id) REFERENCES public.test_attempts(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_attempt_answers test_attempt_answers_question_id_b181ce43_fk_test_questions_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_attempt_answers
    ADD CONSTRAINT test_attempt_answers_question_id_b181ce43_fk_test_questions_id FOREIGN KEY (question_id) REFERENCES public.test_questions(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_attempt_answers test_attempt_answers_selected_choice_id_b42c31d4_fk_test_choi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_attempt_answers
    ADD CONSTRAINT test_attempt_answers_selected_choice_id_b42c31d4_fk_test_choi FOREIGN KEY (selected_choice_id) REFERENCES public.test_choices(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_attempts test_attempts_application_id_c2086b9d_fk_applications_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_attempts
    ADD CONSTRAINT test_attempts_application_id_c2086b9d_fk_applications_id FOREIGN KEY (application_id) REFERENCES public.applications(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_attempts test_attempts_test_id_cea68c14_fk_tests_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_attempts
    ADD CONSTRAINT test_attempts_test_id_cea68c14_fk_tests_id FOREIGN KEY (test_id) REFERENCES public.tests(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_choices test_choices_question_id_aae26ef5_fk_test_questions_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_choices
    ADD CONSTRAINT test_choices_question_id_aae26ef5_fk_test_questions_id FOREIGN KEY (question_id) REFERENCES public.test_questions(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: test_questions test_questions_test_id_a208ce1d_fk_tests_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_questions
    ADD CONSTRAINT test_questions_test_id_a208ce1d_fk_tests_id FOREIGN KEY (test_id) REFERENCES public.tests(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tests tests_cycle_id_84e5a6af_fk_recruitment_cycles_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_cycle_id_84e5a6af_fk_recruitment_cycles_id FOREIGN KEY (cycle_id) REFERENCES public.recruitment_cycles(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

