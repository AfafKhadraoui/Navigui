# NavigUI Database - Quick Reference

## Core Tables Summary

| Table                | Purpose                | Primary Use Case                           |
| -------------------- | ---------------------- | ------------------------------------------ |
| `users`              | Base authentication    | All user accounts (student/employer/admin) |
| `student_profiles`   | Student-specific data  | Student interface data                     |
| `employer_profiles`  | Employer-specific data | Employer interface data                    |
| `jobs`               | Job postings           | Job listings and management                |
| `applications`       | Job applications       | Application tracking with reapplication    |
| `reviews`            | Rating system          | Dual-sided reviews (student/employer)      |
| `notifications`      | User notifications     | All notification types                     |
| `saved_jobs`         | Bookmarked jobs        | Student saved jobs                         |
| `services`           | Service marketplace    | Student services (Fiverr-like)             |
| `education_articles` | Learning content       | Educational resources                      |
| `admin_actions`      | Admin audit trail      | Admin activity logging                     |
| `reports`            | Content moderation     | User-submitted reports                     |

## Interface-Specific Fields

### Student Interface Fields

**Profile Data (student_profiles)**

- `user_id`, `university`, `faculty`, `major`, `year_of_study`
- `bio`, `cv_url`, `availability`, `transportation`, `previous_experience`
- `website_url`, `is_phone_public`, `profile_visibility`
- `rating`, `review_count`, `jobs_completed`

**Related Tables**

- `student_skills` - Skills with proficiency levels
- `student_languages` - Language proficiency
- `student_social_links` - LinkedIn, GitHub, portfolio
- `student_portfolio` - Portfolio items
- `student_availability` - Detailed schedule (future feature)
- `applications` - Job applications
- `saved_jobs` - Bookmarked jobs

### Employer Interface Fields

**Profile Data (employer_profiles)**

- `user_id`, `business_name`, `business_type`, `industry`
- `description`, `address`, `location`, `logo_url`, `website_url`
- `is_verified`, `verification_badge`, `verification_document_url`, `total_hires`
- `rating`, `review_count`, `active_jobs`, `total_jobs_posted`

**Related Tables**

- `employer_social_links` - Social media links
- `jobs` - Posted jobs with full details
- `applications` - Received applications
- `job_photos`, `job_tags`, `job_required_languages`

### Admin Interface Fields

**Admin Features**

- `admin_actions` - Action logging (user_ban, job_delete, review_hide)
- `reports` - Content moderation queue
- All tables accessible for management

**Admin Capabilities**

- User management (view, suspend, delete)
- Job moderation (approve, reject, remove)
- Report handling (review, resolve, dismiss)
- System settings and maintenance

## Critical Fields by Table

### users

- `id`, `email`, `password_hash`, `account_type` (student/employer/admin)
- `name`, `phone_number`, `location`, `profile_picture_url`
- `is_email_verified`, `is_active`, `last_login_at`
- `created_at`, `updated_at`, `deleted_at`

### jobs (33 fields - matches Flutter JobModel)

- `id`, `employer_id`, `title`, `description`, `brief_description`
- `category` (ENUM: photography, translation, graphic_design, tutoring, delivery, writing, marketing, tech_support, event_help, social_media, data_entry, video_editing, web_development, customer_service, other)
- `job_type` (part_time/task), `requirements`
- `pay`, `payment_type` (hourly/daily/weekly/monthly/per_task)
- `time_commitment` (VARCHAR - flexible), `duration` (VARCHAR - flexible), `start_date`, `is_recurring`
- `number_of_positions`, `location`, `contact_preference`
- `deadline`, `is_urgent`, `requires_cv`, `is_draft`
- `status` (draft/active/filled/closed/expired)
- `applicants_count`, `views_count`, `saves_count`
- `created_at`, `updated_at`, `deleted_at`

### applications (with reapplication support)

- `id`, `job_id`, `student_id`, `cover_message`
- `cv_url`, `portfolio_url`, `availability_confirmation`
- `status` (pending/accepted/rejected/withdrawn/interviewing/offered)
- `is_withdrawn`, `is_latest` (critical for reapplication)
- `employer_note`, `applied_at`, `responded_at`
- `created_at`, `updated_at`

## Common Queries

### Student Interface Queries

**Get Active Jobs for Browse**

```sql
SELECT j.*, ep.business_name, ep.rating, ep.logo_url
FROM jobs j
JOIN employer_profiles ep ON j.employer_id = ep.user_id
WHERE j.status = 'active' AND j.deleted_at IS NULL
ORDER BY j.created_at DESC;
```

**Get Student Applications (Latest Only)**

```sql
SELECT a.*, j.title, j.pay, ep.business_name
FROM applications a
JOIN jobs j ON a.job_id = j.id
JOIN employer_profiles ep ON j.employer_id = ep.user_id
WHERE a.student_id = ? AND a.is_latest = TRUE
ORDER BY a.applied_at DESC;
```

**Get Saved Jobs**

```sql
SELECT j.*, ep.business_name
FROM saved_jobs sj
JOIN jobs j ON sj.job_id = j.id
JOIN employer_profiles ep ON j.employer_id = ep.user_id
WHERE sj.student_id = ?
ORDER BY sj.created_at DESC;
```

### Employer Interface Queries

**Get Employer Active Jobs**

```sql
SELECT * FROM jobs
WHERE employer_id = ? AND status = 'active'
ORDER BY created_at DESC;
```

**Get Received Applications**

```sql
SELECT a.*, sp.university, sp.major, sp.rating, u.name, u.profile_picture_url
FROM applications a
JOIN jobs j ON a.job_id = j.id
JOIN student_profiles sp ON a.student_id = sp.user_id
JOIN users u ON a.student_id = u.id
WHERE j.employer_id = ? AND a.is_latest = TRUE
ORDER BY a.applied_at DESC;
```

**Get Employer Statistics**

```sql
SELECT
  COUNT(CASE WHEN status = 'active' THEN 1 END) as active_posts,
  (SELECT COUNT(*) FROM applications WHERE job_id IN (SELECT id FROM jobs WHERE employer_id = ?)) as total_applications,
  (SELECT COUNT(*) FROM applications WHERE job_id IN (SELECT id FROM jobs WHERE employer_id = ?) AND status = 'accepted') as hired
FROM jobs
WHERE employer_id = ?;
```

### Admin Interface Queries

**Get All Users with Counts**

```sql
SELECT u.*,
  COALESCE(sp.jobs_completed, 0) as jobs_completed,
  COALESCE(ep.total_jobs_posted, 0) as total_jobs_posted,
  (SELECT COUNT(*) FROM reports WHERE content_type = 'user' AND content_id = u.id) as report_count
FROM users u
LEFT JOIN student_profiles sp ON u.id = sp.user_id
LEFT JOIN employer_profiles ep ON u.id = ep.user_id
ORDER BY u.created_at DESC;
```

**Get Pending Reports**

```sql
SELECT r.*, u.name as reporter_name
FROM reports r
JOIN users u ON r.reporter_id = u.id
WHERE r.status = 'pending'
ORDER BY r.created_at DESC;
```

**Get Admin Action Log**

```sql
SELECT aa.*, u.name as admin_name
FROM admin_actions aa
JOIN users u ON aa.admin_id = u.id
ORDER BY aa.created_at DESC
LIMIT 100;
```

## ENUM Values

**account_type**: `student`, `employer`, `admin`

**job_category**: `photography`, `translation`, `graphic_design`, `tutoring`, `delivery`, `writing`, `marketing`, `tech_support`, `event_help`, `social_media`, `data_entry`, `video_editing`, `web_development`, `customer_service`, `other`

**job_type**: `part_time`, `task`

**job_status**: `draft`, `active`, `filled`, `closed`, `expired`

**application_status**: `pending`, `accepted`, `rejected`, `withdrawn`, `interviewing`, `offered`

**payment_type**: `hourly`, `daily`, `weekly`, `monthly`, `per_task`

**contact_preference**: `phone`, `email`, `whatsapp`

**notification_priority**: `low`, `medium`, `high`, `urgent`

**report_reason**: `spam`, `inappropriate`, `fraud`, `harassment`, `other`

**report_content_type**: `job`, `user`, `review`

**report_status**: `pending`, `reviewing`, `resolved`, `dismissed`

**Note**: `time_commitment` and `duration` changed from ENUM to VARCHAR for flexibility (see Version 2.2)

## Key Relationships

```
users (1) -- (1) student_profiles
users (1) -- (1) employer_profiles
users (1) -- (N) jobs (as employer)
users (1) -- (N) applications (as student)
users (1) -- (N) reviews (bidirectional)
users (1) -- (N) notifications
users (1) -- (N) admin_actions (as admin)

jobs (1) -- (N) applications
jobs (1) -- (N) job_photos
jobs (1) -- (N) job_tags
jobs (1) -- (N) saved_jobs
jobs (1) -- (N) job_required_languages

student_profiles (1) -- (N) student_skills
student_profiles (1) -- (N) student_languages
student_profiles (1) -- (N) student_social_links
student_profiles (1) -- (N) student_portfolio
```

## Performance Indexes

**Jobs Table**

- `idx_jobs_status_type` - Home page filtering
- `idx_jobs_is_urgent` - Urgent jobs section
- `idx_jobs_location_status` - Location-based search
- `idx_jobs_pay` - Salary filtering
- `idx_jobs_deadline_status` - Expiring jobs

**Applications Table**

- `idx_applications_latest` - Current applications (reapplication support)
- `idx_applications_job` - Applications per job
- `idx_applications_student` - Student's applications
- `idx_applications_status` - Filter by status

**Notifications Table**

- `idx_notifications_user_read` - Unread notifications
- `idx_notifications_user_unread` - Composite for performance

**Reviews Table**

- `idx_reviews_reviewee` - User profile ratings
- `idx_reviews_reviewer` - Given reviews

## Field Verification Checklist

**Student Interface - Complete**

- User profile fields: name, email, phone, location, profile_picture
- Student profile: university, faculty, major, year_of_study, bio
- Skills and languages with proficiency levels
- Portfolio items and social links
- Application tracking with reapplication support
- Saved jobs functionality
- Work history (accepted applications + reviews)
- Reviews received and given
- Notifications

**Employer Interface - Complete**

- User profile fields: name, email, phone, location
- Employer profile: business_name, business_type, industry, description
- Logo, website, verification badge
- Job posting with 33 fields (matches Flutter JobModel)
- Application management with student details
- Statistics: active_jobs, total_jobs_posted, applicants_count
- Reviews and ratings
- Notifications

**Admin Interface - Complete**

- Full access to all tables
- Admin action logging (admin_actions)
- Content moderation (reports table)
- User management capabilities
- Job approval/rejection workflow
- System-wide statistics and analytics
- Settings and configuration

**For detailed schema documentation, see DATABASE_SCHEMA.md**
