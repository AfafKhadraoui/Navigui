-- ============================================================================
-- NavigUI Database Schema
-- Production-Ready MySQL Schema for Dual-Sided Job Marketplace
-- 
-- NOTE: For PostgreSQL, see database_schema_postgresql.sql
-- This file uses MySQL syntax (ENUM, ENGINE=InnoDB)
--
-- IMPROVEMENTS BASED ON REVIEW:
-- 1. Applications: Allow reapplication (removed unique constraint, added is_latest flag)
-- 2. Reviews: Job completion reviews for both students and employers
-- 3. Notifications: Added is_pushed, action_url, and priority fields for push notifications
-- 4. Skills: Many-to-many for both student profiles and job requirements
-- 5. Availability: Added detailed student_availability calendar table (FUTURE FEATURE)
-- 6. UUIDs: See SCHEMA_IMPROVEMENTS.md for UUID vs INT guidance
-- ============================================================================
-- 
-- Features Covered:
-- - User management (students, employers, admins)
-- - Job postings (part-time jobs and tasks)
-- - Applications system
-- - Dual rating/review system
-- - Notifications
-- - Saved/bookmarked jobs
-- - Skills tracking (student profiles and job requirements)
-- - Educational content
-- - Multi-language support
-- - Admin features
-- - Search and filtering capabilities
--
-- Design Principles:
-- - Proper normalization (3NF)
-- - Foreign key constraints for data integrity
-- - Indexes on frequently queried fields
-- - Soft deletes for audit trails
-- - Timestamps for tracking
-- - Check constraints for data validation
-- ============================================================================

-- ============================================================================
-- CORE USER MANAGEMENT
-- ============================================================================

-- Users table: Base authentication and user information
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    account_type ENUM('student', 'employer', 'admin') NOT NULL,
    name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    location VARCHAR(255), -- City/area
    profile_picture_url TEXT,
    is_email_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    last_login_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    
    -- Indexes
    INDEX idx_users_email (email),
    INDEX idx_users_account_type (account_type),
    INDEX idx_users_location (location),
    INDEX idx_users_deleted_at (deleted_at),
    INDEX idx_users_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Student profiles: Extended information for students
CREATE TABLE student_profiles (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL UNIQUE,
    university VARCHAR(255) NOT NULL,
    faculty VARCHAR(255) NOT NULL,
    major VARCHAR(255) NOT NULL,
    year_of_study VARCHAR(50) NOT NULL, -- "1st year", "2nd year", etc.
    bio TEXT,
    cv_url VARCHAR(500), -- Student's CV/Resume (can be null)
    availability VARCHAR(50), -- "weekdays", "weekends", "evenings", "flexible" (quick filter)
    transportation VARCHAR(50), -- "car", "motorcycle", "public_transport", "none"
    previous_experience TEXT,
    website_url VARCHAR(500),
    is_phone_public BOOLEAN DEFAULT TRUE,
    profile_visibility ENUM('everyone', 'employers_only') DEFAULT 'everyone',
    rating DECIMAL(3,2) DEFAULT 0.00 CHECK (rating >= 0 AND rating <= 5),
    review_count INT DEFAULT 0,
    jobs_completed INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    -- Indexes
    INDEX idx_student_profiles_university (university),
    INDEX idx_student_profiles_major (major),
    INDEX idx_student_profiles_rating (rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Student availability calendar: Detailed working hours/days
-- FUTURE FEATURE: Complements the simple availability enum in student_profiles
-- For MVP, the enum field is sufficient. This table enables future detailed scheduling.
CREATE TABLE student_availability (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    student_id VARCHAR(36) NOT NULL,
    day_of_week ENUM('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES student_profiles(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_student_day (student_id, day_of_week),
    INDEX idx_student_availability_student (student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Employer profiles: Extended information for employers
CREATE TABLE employer_profiles (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL UNIQUE,
    business_name VARCHAR(255) NOT NULL,
    business_type VARCHAR(100) NOT NULL,
    industry VARCHAR(100) NOT NULL,
    description TEXT,
    address TEXT,
    location VARCHAR(255), -- City/area where business operates
    logo_url TEXT,
    website_url VARCHAR(500),
    is_verified BOOLEAN DEFAULT FALSE,
    verification_badge VARCHAR(100),
    verification_document_url VARCHAR(500), -- Government ID, business license, etc. for identity verification
    total_hires INT DEFAULT 0, -- Total number of students hired
    rating DECIMAL(3,2) DEFAULT 0.00 CHECK (rating >= 0 AND rating <= 5),
    review_count INT DEFAULT 0,
    active_jobs INT DEFAULT 0,
    total_jobs_posted INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    -- Indexes
    INDEX idx_employer_profiles_business_name (business_name),
    INDEX idx_employer_profiles_industry (industry),
    INDEX idx_employer_profiles_is_verified (is_verified),
    INDEX idx_employer_profiles_rating (rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- SKILLS AND LANGUAGES (Many-to-Many Relationships)
-- ============================================================================

-- Skills master table
CREATE TABLE skills (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(100), -- e.g., "Technical", "Soft Skills", "Administrative"
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_skills_name (name),
    INDEX idx_skills_category (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Student skills: Many-to-many relationship
CREATE TABLE student_skills (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    student_id VARCHAR(36) NOT NULL,
    skill_id VARCHAR(36) NOT NULL,
    proficiency_level ENUM('beginner', 'intermediate', 'advanced', 'expert') DEFAULT 'intermediate',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES student_profiles(user_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_student_skill (student_id, skill_id),
    INDEX idx_student_skills_student (student_id),
    INDEX idx_student_skills_skill (skill_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Languages master table
CREATE TABLE languages (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    code VARCHAR(10) UNIQUE NOT NULL, -- ISO 639-1 code (e.g., 'en', 'ar', 'fr')
    name VARCHAR(100) NOT NULL,
    native_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_languages_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Student languages: Many-to-many relationship
CREATE TABLE student_languages (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    student_id VARCHAR(36) NOT NULL,
    language_id VARCHAR(36) NOT NULL,
    proficiency_level ENUM('basic', 'conversational', 'fluent', 'native') DEFAULT 'conversational',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES student_profiles(user_id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_student_language (student_id, language_id),
    INDEX idx_student_languages_student (student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Social media links for students
CREATE TABLE student_social_links (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    student_id VARCHAR(36) NOT NULL,
    platform VARCHAR(50) NOT NULL, -- 'linkedin', 'github', 'portfolio', etc.
    url VARCHAR(500) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES student_profiles(user_id) ON DELETE CASCADE,
    INDEX idx_student_social_links_student (student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Social media links for employers
CREATE TABLE employer_social_links (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    employer_id VARCHAR(36) NOT NULL,
    platform VARCHAR(50) NOT NULL,
    url VARCHAR(500) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (employer_id) REFERENCES employer_profiles(user_id) ON DELETE CASCADE,
    INDEX idx_employer_social_links_employer (employer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Student portfolio items
CREATE TABLE student_portfolio (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    student_id VARCHAR(36) NOT NULL,
    title VARCHAR(255),
    description TEXT,
    url VARCHAR(500),
    file_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES student_profiles(user_id) ON DELETE CASCADE,
    INDEX idx_student_portfolio_student (student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- JOB POSTINGS
-- ============================================================================

-- Job categories
CREATE TABLE job_categories (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    icon_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_job_categories_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Job postings: Main table for jobs and tasks
CREATE TABLE jobs (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    employer_id VARCHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    brief_description VARCHAR(500),
    category ENUM('photography', 'translation', 'graphic_design', 'tutoring', 'delivery', 'writing', 'marketing', 'tech_support', 'event_help', 'social_media', 'data_entry', 'video_editing', 'web_development', 'customer_service', 'other') NOT NULL,
    job_type ENUM('part_time', 'task') NOT NULL,
    requirements TEXT,
    pay DECIMAL(10,2) NOT NULL CHECK (pay >= 0),
    payment_type ENUM('hourly', 'daily', 'weekly', 'monthly', 'per_task') NOT NULL,
    time_commitment VARCHAR(100), -- Changed from ENUM for flexibility: "full_day", "half_day", "few_hours", "flexible", or custom
    duration VARCHAR(100), -- Changed from ENUM for flexibility: "one_time", "1_week", "1_month", "ongoing", or custom
    start_date TIMESTAMP NULL,
    is_recurring BOOLEAN DEFAULT FALSE,
    number_of_positions INT DEFAULT 1 CHECK (number_of_positions > 0),
    location VARCHAR(255),
    contact_preference ENUM('phone', 'email', 'whatsapp'),
    deadline TIMESTAMP NULL,
    is_urgent BOOLEAN DEFAULT FALSE,
    requires_cv BOOLEAN DEFAULT FALSE,
    is_draft BOOLEAN DEFAULT FALSE,
    status ENUM('draft', 'active', 'filled', 'closed', 'expired') DEFAULT 'draft',
    applicants_count INT DEFAULT 0,
    views_count INT DEFAULT 0,
    saves_count INT DEFAULT 0, -- Track how many users saved/bookmarked this job
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    
    FOREIGN KEY (employer_id) REFERENCES users(id) ON DELETE CASCADE,
    
    -- Indexes for performance
    INDEX idx_jobs_employer (employer_id),
    INDEX idx_jobs_category (category),
    INDEX idx_jobs_job_type (job_type),
    INDEX idx_jobs_status (status),
    INDEX idx_jobs_location (location),
    INDEX idx_jobs_is_urgent (is_urgent),
    INDEX idx_jobs_deadline (deadline),
    INDEX idx_jobs_created_at (created_at),
    INDEX idx_jobs_deleted_at (deleted_at),
    -- Composite indexes for common queries
    INDEX idx_jobs_status_type (status, job_type),
    INDEX idx_jobs_status_category (status, category),
    INDEX idx_jobs_location_status (location, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Job photos
CREATE TABLE job_photos (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    job_id VARCHAR(36) NOT NULL,
    photo_url VARCHAR(500) NOT NULL,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    INDEX idx_job_photos_job (job_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Job tags
CREATE TABLE job_tags (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    job_id VARCHAR(36) NOT NULL,
    tag VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    UNIQUE KEY unique_job_tag (job_id, tag),
    INDEX idx_job_tags_job (job_id),
    INDEX idx_job_tags_tag (tag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Job required languages
CREATE TABLE job_required_languages (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    job_id VARCHAR(36) NOT NULL,
    language_id VARCHAR(36) NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_job_language (job_id, language_id),
    INDEX idx_job_required_languages_job (job_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Job required skills: Skills required/preferred for each job
CREATE TABLE job_required_skills (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    job_id VARCHAR(36) NOT NULL,
    skill_id VARCHAR(36) NOT NULL,
    is_required BOOLEAN DEFAULT TRUE, -- TRUE = required, FALSE = preferred/nice-to-have
    proficiency_level ENUM('beginner', 'intermediate', 'advanced', 'expert') DEFAULT 'intermediate',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_job_skill (job_id, skill_id),
    INDEX idx_job_required_skills_job (job_id),
    INDEX idx_job_required_skills_skill (skill_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- APPLICATIONS
-- ============================================================================

-- Applications: Students applying to jobs
CREATE TABLE applications (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    job_id VARCHAR(36) NOT NULL,
    student_id VARCHAR(36) NOT NULL,
    cover_message TEXT,
    cv_url VARCHAR(500),
    portfolio_url VARCHAR(500),
    availability_confirmation BOOLEAN DEFAULT TRUE,
    status ENUM('pending', 'accepted', 'rejected', 'withdrawn', 'interviewing', 'offered') DEFAULT 'pending',
    is_withdrawn BOOLEAN DEFAULT FALSE,
    is_latest BOOLEAN DEFAULT TRUE, -- ✅ CRITICAL: Track most recent application for reapplication support
    employer_note TEXT,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    responded_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    
    -- Allow reapplication: Remove unique constraint, use is_latest flag instead
    -- Business logic: Only one application per (job_id, student_id) can have is_latest = TRUE
    -- When student reapplies: Set old application is_latest = FALSE, create new with is_latest = TRUE
    -- Note: previous_application_id removed for MVP simplicity - can add later if needed for audit trail
    
    -- Indexes
    INDEX idx_applications_job (job_id),
    INDEX idx_applications_student (student_id),
    INDEX idx_applications_status (status),
    INDEX idx_applications_applied_at (applied_at),
    INDEX idx_applications_latest (job_id, student_id, is_latest)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- RATINGS AND REVIEWS (Dual-Sided System)
-- ============================================================================

-- Reviews: Comprehensive rating system for both students and employers after job completion
CREATE TABLE reviews (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    reviewer_id VARCHAR(36) NOT NULL, -- Who gave the review
    reviewee_id VARCHAR(36) NOT NULL, -- Who received the review
    job_id VARCHAR(36), -- Related job (optional)
    application_id VARCHAR(36), -- Related application (optional)
    
    -- Overall rating
    rating DECIMAL(3,2) NOT NULL CHECK (rating >= 1 AND rating <= 5),
    
    -- Detailed ratings (for employers rating students)
    communication_rating DECIMAL(3,2) CHECK (communication_rating >= 1 AND communication_rating <= 5),
    payment_rating DECIMAL(3,2) CHECK (payment_rating >= 1 AND payment_rating <= 5),
    work_environment_rating DECIMAL(3,2) CHECK (work_environment_rating >= 1 AND work_environment_rating <= 5),
    overall_experience_rating DECIMAL(3,2) CHECK (overall_experience_rating >= 1 AND overall_experience_rating <= 5),
    
    -- Detailed ratings (for students rating employers)
    quality_rating DECIMAL(3,2) CHECK (quality_rating >= 1 AND quality_rating <= 5),
    time_respect_rating DECIMAL(3,2) CHECK (time_respect_rating >= 1 AND time_respect_rating <= 5),
    
    comment TEXT,
    is_visible BOOLEAN DEFAULT TRUE,
    is_reported BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewee_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE SET NULL,
    FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE SET NULL,
    
    -- Prevent duplicate reviews for same job/application
    UNIQUE KEY unique_review_job (reviewer_id, reviewee_id, job_id),
    
    -- Indexes
    INDEX idx_reviews_reviewer (reviewer_id),
    INDEX idx_reviews_reviewee (reviewee_id),
    INDEX idx_reviews_job (job_id),
    INDEX idx_reviews_rating (rating),
    INDEX idx_reviews_is_visible (is_visible),
    INDEX idx_reviews_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Review tags (e.g., "punctual", "professional", "poor_communication")
CREATE TABLE review_tags (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    review_id VARCHAR(36) NOT NULL,
    tag VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
    INDEX idx_review_tags_review (review_id),
    INDEX idx_review_tags_tag (tag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- NOTIFICATIONS
-- ============================================================================

-- Notifications: System notifications for users
-- NOTE: Using polymorphic related_id/related_type for flexibility
-- For better type safety at scale, consider separate notification tables
-- (see SCHEMA_IMPROVEMENTS.md for alternative design)
CREATE TABLE notifications (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL, -- 'job_match', 'application_response', 'new_applicant', 'review_received', etc.
    related_id VARCHAR(36), -- Related job/application/review/service ID
    related_type VARCHAR(50), -- 'job', 'application', 'review', 'service', etc.
    action_url VARCHAR(500), -- Screen to navigate to when notification is clicked (e.g., '/job/123', '/application/456')
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    is_read BOOLEAN DEFAULT FALSE,
    is_pushed BOOLEAN DEFAULT FALSE, -- Track if notification was sent via push notification
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    -- Indexes
    INDEX idx_notifications_user (user_id),
    INDEX idx_notifications_is_read (is_read),
    INDEX idx_notifications_type (type),
    INDEX idx_notifications_related (related_type, related_id),
    INDEX idx_notifications_created_at (created_at),
    INDEX idx_notifications_user_read (user_id, is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Helper views for type-safe notification queries (optional, see SCHEMA_IMPROVEMENTS.md)
-- Uncomment if you want type-safe queries without separate tables
/*
CREATE VIEW job_notifications_view AS
SELECT n.*, j.title as job_title, j.id as job_id
FROM notifications n
JOIN jobs j ON n.related_id = j.id
WHERE n.related_type = 'job';

CREATE VIEW application_notifications_view AS
SELECT n.*, a.id as application_id, j.title as job_title
FROM notifications n
JOIN applications a ON n.related_id = a.id
JOIN jobs j ON a.job_id = j.id
WHERE n.related_type = 'application';
*/

-- ============================================================================
-- SAVED/BOOKMARKED JOBS
-- ============================================================================

-- Saved jobs: Jobs bookmarked by students
CREATE TABLE saved_jobs (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    student_id VARCHAR(36) NOT NULL,
    job_id VARCHAR(36) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    
    -- Prevent duplicate saves
    UNIQUE KEY unique_saved_job (student_id, job_id),
    
    -- Indexes
    INDEX idx_saved_jobs_student (student_id),
    INDEX idx_saved_jobs_job (job_id),
    INDEX idx_saved_jobs_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- EDUCATIONAL CONTENT
-- ============================================================================

-- Education article categories
CREATE TABLE education_categories (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    icon_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_education_categories_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Education articles: Educational content for students
CREATE TABLE education_articles (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    category_id VARCHAR(36) NOT NULL,
    image_url VARCHAR(500),
    author VARCHAR(255),
    read_time INT DEFAULT 5, -- in minutes
    views_count INT DEFAULT 0,
    published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    
    FOREIGN KEY (category_id) REFERENCES education_categories(id),
    
    -- Indexes
    INDEX idx_education_articles_category (category_id),
    INDEX idx_education_articles_published_at (published_at),
    INDEX idx_education_articles_deleted_at (deleted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- MULTI-LANGUAGE SUPPORT
-- ============================================================================

-- Job translations: Multi-language support for job postings
CREATE TABLE job_translations (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    job_id VARCHAR(36) NOT NULL,
    language_id VARCHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    brief_description VARCHAR(500),
    requirements TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_job_translation (job_id, language_id),
    INDEX idx_job_translations_job (job_id),
    INDEX idx_job_translations_language (language_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Education article translations
CREATE TABLE education_article_translations (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    article_id VARCHAR(36) NOT NULL,
    language_id VARCHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (article_id) REFERENCES education_articles(id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_article_translation (article_id, language_id),
    INDEX idx_education_article_translations_article (article_id),
    INDEX idx_education_article_translations_language (language_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- ADMIN FEATURES
-- ============================================================================

-- Admin actions log: Track admin activities
CREATE TABLE admin_actions (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    admin_id VARCHAR(36) NOT NULL,
    action_type VARCHAR(100) NOT NULL, -- 'user_ban', 'job_delete', 'review_hide', etc.
    target_type VARCHAR(50), -- 'user', 'job', 'review', etc.
    target_id VARCHAR(36), -- ID of the target entity
    description TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (admin_id) REFERENCES users(id) ON DELETE CASCADE,
    
    -- Indexes
    INDEX idx_admin_actions_admin (admin_id),
    INDEX idx_admin_actions_type (action_type),
    INDEX idx_admin_actions_target (target_type, target_id),
    INDEX idx_admin_actions_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Reports: User reports for content moderation
CREATE TABLE reports (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    reporter_id VARCHAR(36) NOT NULL,
    content_type ENUM('job', 'user', 'review') NOT NULL,
    content_id VARCHAR(36) NOT NULL,
    reason ENUM('spam', 'inappropriate', 'fraud', 'harassment', 'other') NOT NULL,
    description TEXT,
    status ENUM('pending', 'reviewing', 'resolved', 'dismissed') DEFAULT 'pending',
    reviewed_by VARCHAR(36), -- Admin who reviewed the report
    resolved_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (reporter_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL,
    
    -- Indexes
    INDEX idx_reports_reporter (reporter_id),
    INDEX idx_reports_content_type (content_type),
    INDEX idx_reports_content_id (content_id),
    INDEX idx_reports_content (content_type, content_id),
    INDEX idx_reports_status (status),
    INDEX idx_reports_created_at (created_at DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- SEARCH AND ANALYTICS
-- ============================================================================

-- Search history: Track user searches for analytics
CREATE TABLE search_history (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36),
    search_query VARCHAR(500) NOT NULL,
    filters JSON, -- Store filter criteria as JSON
    results_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    
    -- Indexes
    INDEX idx_search_history_user (user_id),
    INDEX idx_search_history_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Job views: Track job views for analytics
CREATE TABLE job_views (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    job_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36), -- NULL for anonymous views
    ip_address VARCHAR(45),
    user_agent TEXT,
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    
    -- Indexes
    INDEX idx_job_views_job (job_id),
    INDEX idx_job_views_user (user_id),
    INDEX idx_job_views_viewed_at (viewed_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- ============================================================================

-- Trigger to manage is_latest flag for reapplications
DELIMITER //
CREATE TRIGGER before_application_insert
BEFORE INSERT ON applications
FOR EACH ROW
BEGIN
    -- When a new application is inserted with is_latest = TRUE,
    -- set all previous applications from same student for same job to is_latest = FALSE
    IF NEW.is_latest = TRUE THEN
        UPDATE applications 
        SET is_latest = FALSE 
        WHERE job_id = NEW.job_id 
        AND student_id = NEW.student_id 
        AND is_latest = TRUE;
    END IF;
END//
DELIMITER ;

-- Trigger to update job applicants_count
DELIMITER //
CREATE TRIGGER update_job_applicants_count
AFTER INSERT ON applications
FOR EACH ROW
BEGIN
    UPDATE jobs
    SET applicants_count = (
        SELECT COUNT(*) 
        FROM applications 
        WHERE job_id = NEW.job_id AND status != 'withdrawn'
    )
    WHERE id = NEW.job_id;
END//
DELIMITER ;

-- Trigger to update student review_count and rating
DELIMITER //
CREATE TRIGGER update_student_ratings
AFTER INSERT ON reviews
FOR EACH ROW
BEGIN
    IF (SELECT account_type FROM users WHERE id = NEW.reviewee_id) = 'student' THEN
        UPDATE student_profiles
        SET review_count = (
            SELECT COUNT(*) 
            FROM reviews 
            WHERE reviewee_id = NEW.reviewee_id AND is_visible = TRUE
        ),
        rating = (
            SELECT AVG(rating) 
            FROM reviews 
            WHERE reviewee_id = NEW.reviewee_id AND is_visible = TRUE
        )
        WHERE user_id = NEW.reviewee_id;
    END IF;
END//
DELIMITER ;

-- Trigger to update employer review_count and rating
DELIMITER //
CREATE TRIGGER update_employer_ratings
AFTER INSERT ON reviews
FOR EACH ROW
BEGIN
    IF (SELECT account_type FROM users WHERE id = NEW.reviewee_id) = 'employer' THEN
        UPDATE employer_profiles
        SET review_count = (
            SELECT COUNT(*) 
            FROM reviews 
            WHERE reviewee_id = NEW.reviewee_id AND is_visible = TRUE
        ),
        rating = (
            SELECT AVG(rating) 
            FROM reviews 
            WHERE reviewee_id = NEW.reviewee_id AND is_visible = TRUE
        )
        WHERE user_id = NEW.reviewee_id;
    END IF;
END//
DELIMITER ;

-- Trigger to update job views_count
DELIMITER //
CREATE TRIGGER update_job_views_count
AFTER INSERT ON job_views
FOR EACH ROW
BEGIN
    UPDATE jobs
    SET views_count = views_count + 1
    WHERE id = NEW.job_id;
END//
DELIMITER ;

-- ============================================================================
-- ADDITIONAL PERFORMANCE INDEXES (RECOMMENDED)
-- ============================================================================

-- Composite index for notifications - improve unread notification queries
CREATE INDEX idx_notifications_user_unread ON notifications(user_id, is_read, created_at);

-- Index for job pay - useful for salary range filtering
CREATE INDEX idx_jobs_pay ON jobs(pay);

-- Composite index for deadline + status - useful for expiring jobs queries
CREATE INDEX idx_jobs_deadline_status ON jobs(deadline, status);

-- ============================================================================
-- INITIAL DATA (Seed Data)
-- ============================================================================

-- Insert default languages
INSERT INTO languages (id, code, name, native_name) VALUES
(UUID(), 'en', 'English', 'English'),
(UUID(), 'ar', 'Arabic', 'العربية'),
(UUID(), 'fr', 'French', 'Français');

-- Insert default job categories
INSERT INTO job_categories (id, name, description) VALUES
(UUID(), 'Hospitality', 'Restaurant, hotel, and service industry jobs'),
(UUID(), 'Retail', 'Store and sales positions'),
(UUID(), 'Tutoring', 'Educational and tutoring services'),
(UUID(), 'Delivery', 'Food and package delivery'),
(UUID(), 'Administrative', 'Office and administrative work'),
(UUID(), 'Event Staff', 'Event planning and staffing'),
(UUID(), 'Other', 'Other job categories');

-- Insert default education categories
INSERT INTO education_categories (id, name, description) VALUES
(UUID(), 'Resume', 'Resume writing and optimization tips'),
(UUID(), 'Interview', 'Interview preparation and techniques'),
(UUID(), 'Application', 'Job application best practices'),
(UUID(), 'Career Development', 'Career growth and development'),
(UUID(), 'Skills', 'Skill development and learning');

-- Insert default skills
INSERT INTO skills (id, name, category) VALUES
(UUID(), 'Customer Service', 'Soft Skills'),
(UUID(), 'Communication', 'Soft Skills'),
(UUID(), 'Time Management', 'Soft Skills'),
(UUID(), 'Teamwork', 'Soft Skills'),
(UUID(), 'Problem Solving', 'Soft Skills'),
(UUID(), 'Microsoft Office', 'Technical'),
(UUID(), 'Photoshop', 'Technical'),
(UUID(), 'Web Design', 'Technical'),
(UUID(), 'Data Entry', 'Administrative'),
(UUID(), 'Social Media Management', 'Administrative');

