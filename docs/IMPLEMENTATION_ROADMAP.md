# 📊 NavigUI Implementation Roadmap - 2 Week Sprint

**Project**: NavigUI - Student-Employer Job Marketplace  
**Deadline**: 2 Weeks  
**Current Status**: Frontend complete, Database architecture ready, Repositories need implementation  
**Last Updated**: December 5, 2025

---

## 🎯 EXECUTIVE SUMMARY

**Goal**: Transform NavigUI from a frontend-only prototype into a fully functional job marketplace with database integration.

**Critical Path**: Auth → Profiles → Jobs → Applications → Testing

**Success Criteria**:

- ✅ Student can register → login → browse jobs → apply
- ✅ Employer can register → login → create job → view applications → respond
- ✅ Admin can login → view dashboard

---

## 📋 DATABASE FEATURES BY PRIORITY

### ⚠️ CRITICAL (Must Have - Week 1)

#### 1. User Authentication & Profiles ⭐⭐⭐⭐⭐

**Priority**: CRITICAL  
**Tables**:

- `users` (base accounts)
- `student_profiles` (student-specific data)
- `employer_profiles` (employer-specific data)

**Models Status**:

- ✅ `user_model.dart` exists
- ✅ `student_model.dart` exists
- ✅ `employer_model.dart` exists

**Repositories Status**:

- 🔶 Folders created: `auth/`, `student_profile/`, `employer_profile/`
- ❌ Implementation needed

**Database Fields**:

```sql
-- users table
id, email, password_hash, account_type, name, phone_number, location,
profile_picture_url, is_email_verified, is_active, last_login_at,
created_at, updated_at, deleted_at

-- student_profiles
user_id (FK), university, faculty, major, year_of_study, bio, cv_url,
availability, transportation, previous_experience, website_url,
is_phone_public, profile_visibility, rating, review_count, jobs_completed

-- employer_profiles
user_id (FK), business_name, business_type, industry, description,
address, location, logo_url, website_url, is_verified, verification_badge,
verification_document_url, total_hires, rating, review_count, active_jobs
```

**Why Critical**: Core identity system - nothing works without user accounts and profiles.

**Estimated Time**: 8-10 hours

- Auth repository: 4-6 hours
- Student profile repository: 2-3 hours
- Employer profile repository: 2-3 hours

---

#### 2. Job Posting System ⭐⭐⭐⭐⭐

**Priority**: CRITICAL  
**Tables**:

- `jobs` (33 fields matching Flutter JobModel)
- `job_photos` (multiple photos per job)
- `job_tags` (search/filtering tags)
- `job_required_skills` (skill requirements)

**Models Status**:

- ✅ `job_model.dart` exists (33 fields)
- ✅ `job_post.dart` exists

**Repositories Status**:

- 🔶 Folder created: `jobs/`
- ❌ Implementation needed

**Database Fields**:

```sql
-- jobs table (33 fields)
id, employer_id, title, description, brief_description, category, job_type,
requirements, pay, payment_type, time_commitment, duration, start_date,
is_recurring, number_of_positions, location, contact_preference, deadline,
is_urgent, requires_cv, is_draft, status, applicants_count, views_count,
saves_count, created_at, updated_at, deleted_at

-- Key Features:
- Supports both home page cards and detailed job pages
- 15 categories (photography, translation, graphic_design, etc.)
- Job types: part_time, task
- Payment types: hourly, daily, weekly, monthly, per_task
- Urgent flagging with deadline tracking
```

**Key Indexes**:

- `idx_jobs_status_type` - Home page filtering
- `idx_jobs_is_urgent` - Urgent jobs section
- `idx_jobs_location_status` - Location search
- `idx_jobs_status_category` - Category filtering

**Why Critical**: Core marketplace functionality - the entire app revolves around jobs.

**Estimated Time**: 10-12 hours

- Basic CRUD: 4-5 hours
- Search & filtering: 3-4 hours
- Photos & tags: 2-3 hours
- Testing: 2 hours

---

#### 3. Application System ⭐⭐⭐⭐⭐

**Priority**: CRITICAL  
**Tables**:

- `applications` (with reapplication support)

**Models Status**:

- ✅ `application_model.dart` exists

**Repositories Status**:

- 🔶 Folder created: `applications/`
- ❌ Implementation needed

**Database Fields**:

```sql
-- applications table
id, job_id, student_id, cover_message, cv_url, portfolio_url,
availability_confirmation, status, is_withdrawn, is_latest,
employer_note, applied_at, responded_at, created_at, updated_at

-- Key Feature: is_latest flag
- Allows students to reapply after rejection
- Tracks most recent application per job
- Maintains full application history
```

**Application Statuses**:

- `pending` - Submitted, awaiting review
- `interviewing` - Under consideration
- `accepted` - Offer extended
- `rejected` - Not selected
- `withdrawn` - Student withdrew
- `offered` - Final offer made

**Reapplication Logic**:

```sql
-- When student reapplies:
1. Set old application is_latest = FALSE
2. Create new application with is_latest = TRUE
3. Maintain full history for both student and employer
```

**Why Critical**: Student-employer connection - primary value of the platform.

**Estimated Time**: 8-10 hours

- Basic CRUD: 3-4 hours
- Reapplication logic: 2-3 hours
- Status workflow: 2-3 hours
- Testing: 2 hours

---

### 🔥 IMPORTANT (Must Have - Week 2)

#### 4. Saved Jobs ⭐⭐⭐⭐

**Priority**: IMPORTANT  
**Tables**:

- `saved_jobs`

**Models Status**:

- ✅ Can use existing `job_model.dart`

**Repositories Status**:

- 🔶 Folder created: `saved_jobs/`
- ❌ Implementation needed

**Database Fields**:

```sql
-- saved_jobs
id, student_id, job_id, created_at
UNIQUE(student_id, job_id)
```

**Why Important**: Key UX feature - students need to bookmark jobs for later.

**Estimated Time**: 3-4 hours

---

#### 5. Notifications ⭐⭐⭐⭐

**Priority**: IMPORTANT  
**Tables**:

- `notifications`

**Models Status**:

- ✅ `notification_model.dart` exists

**Repositories Status**:

- 🔶 Folder created: `notifications/`
- ❌ Implementation needed

**Database Fields**:

```sql
-- notifications
id, user_id, title, message, type, related_id, related_type,
action_url, priority, is_read, is_pushed, created_at

-- Notification Types:
- job_match: New job matches student profile
- application_response: Employer responded to application
- job_update: Job details changed
- review_received: New review posted
- system: General announcements
```

**Why Important**: User engagement and retention - keeps users coming back.

**Estimated Time**: 4-5 hours

---

#### 6. Review System ⭐⭐⭐⭐

**Priority**: IMPORTANT  
**Tables**:

- `reviews` (dual-sided: students ↔ employers)

**Models Status**:

- ✅ `review_model.dart` exists

**Repositories Status**:

- 🔶 Folder created: `review/`
- ❌ Implementation needed

**Database Fields**:

```sql
-- reviews
id, reviewer_id, reviewee_id, job_id, application_id,
rating (1-5), communication_rating, payment_rating,
work_environment_rating, overall_experience_rating,
quality_rating, time_respect_rating, comment,
is_visible, is_reported, created_at, updated_at

-- Dual-sided ratings:
- Students rate employers: communication, payment, work environment
- Employers rate students: quality, time respect, professionalism
```

**Why Important**: Trust and credibility - critical for marketplace success.

**Estimated Time**: 6-7 hours

---

### 📚 MEDIUM (Nice to Have - Post-MVP)

#### 7. Education Content ⭐⭐⭐

**Priority**: MEDIUM  
**Tables**:

- `education_articles`
- `education_categories`

**Models Status**:

- ✅ `education_article_model.dart` exists

**Repositories Status**:

- 🔶 Folder created: `education/`
- ❌ Implementation needed

**Database Fields**:

```sql
-- education_articles
id, title, content, category_id, image_url, author,
read_time, views_count, published_at, created_at, updated_at

-- Categories:
- Resume writing
- Interview preparation
- Application tips
- Career development
- Skills training
```

**Why Medium**: Value-add feature but not blocking core functionality.

**Estimated Time**: 4-5 hours

---

#### 8. Student Skills ⭐⭐⭐

**Priority**: MEDIUM  
**Tables**:

- `student_skills`
- `skills` (master list)

**Models Status**:

- ✅ Part of `student_model.dart`

**Repositories Status**:

- 🔶 Part of `student_profile/` implementation

**Database Fields**:

```sql
-- student_skills
id, student_id, skill_id, proficiency_level, years_experience,
is_verified, created_at

-- skills (master list)
id, name, category, description, created_at
```

**Why Medium**: Enhances matching but not critical for launch.

**Estimated Time**: 3-4 hours

---

#### 9. Search & Filtering ⭐⭐⭐

**Priority**: MEDIUM  
**Tables**:

- Uses existing `jobs` table with indexes

**Models Status**:

- ✅ Uses `job_model.dart`

**Repositories Status**:

- 🔶 Search logic in `jobs/` repository

**Why Medium**: Basic filtering works, advanced search can wait.

**Estimated Time**: 4-5 hours (advanced features)

---

### 🔧 LOW (Post-Launch Enhancements)

#### 10. Admin Moderation ⭐⭐

**Priority**: LOW  
**Tables**:

- `admin_actions`
- `reports`

**Models Status**:

- ❌ Need to create

**Repositories Status**:

- 🔶 Folder created: `admin/`
- ❌ Implementation needed

**Why Low**: Can moderate manually during beta.

**Estimated Time**: 6-8 hours

---

#### 11. Services Marketplace ⭐⭐

**Priority**: LOW  
**Tables**:

- `services`
- `service_categories`
- `service_photos`
- `service_reviews`

**Models Status**:

- ✅ `service_model.dart` exists

**Repositories Status**:

- ❌ Not created

**Why Low**: Future feature - Fiverr-like functionality, not needed for job marketplace MVP.

**Estimated Time**: 12-15 hours

---

#### 12. Multi-language Support ⭐

**Priority**: LOW  
**Tables**:

- `job_translations`
- `article_translations`

**Why Low**: Start with single language, add internationalization later.

**Estimated Time**: 8-10 hours

---

## 🚀 2-WEEK IMPLEMENTATION PLAN

### **WEEK 1: CORE FUNCTIONALITY** ⚡

#### **Day 1-2: Authentication & User Management**

**Goal**: Users can register, login, and manage profiles

**Tasks**:

- [ ] Create `auth_repo_abstract.dart`
- [ ] Create `auth_repo_impl.dart`
- [ ] Implement login method
- [ ] Implement register method (student/employer/admin)
- [ ] Implement logout method
- [ ] Implement getCurrentUser method
- [ ] Implement getUserRole method
- [ ] Connect login screen to auth repository
- [ ] Test role-based navigation (admin/employer/student)

**Deliverables**:

- Working login/register flow
- Role detection working
- Profile data loads correctly

**Time**: 16 hours (2 days)

---

#### **Day 3-4: Student & Employer Profiles**

**Goal**: Users can view and edit their profiles

**Tasks**:

- [ ] Create `student_profile_repo_abstract.dart`
- [ ] Create `student_profile_repo_impl.dart`
- [ ] Implement getProfile method
- [ ] Implement updateProfile method
- [ ] Implement uploadCV method
- [ ] Implement skills management (add/remove)
- [ ] Create `employer_profile_repo_abstract.dart`
- [ ] Create `employer_profile_repo_impl.dart`
- [ ] Implement getProfile method
- [ ] Implement updateProfile method
- [ ] Implement uploadLogo method
- [ ] Implement uploadVerificationDoc method
- [ ] Connect profile screens to repositories
- [ ] Remove hardcoded profile data
- [ ] Test profile CRUD operations

**Deliverables**:

- Student profiles fully functional
- Employer profiles fully functional
- Profile editing works
- File uploads work

**Time**: 16 hours (2 days)

---

#### **Day 5-6: Job Posting System**

**Goal**: Employers can create jobs, students can browse

**Tasks**:

- [ ] Create `job_repo_abstract.dart`
- [ ] Create `job_repo_impl.dart`
- [ ] Implement getActiveJobs method
- [ ] Implement getUrgentJobs method
- [ ] Implement getJobById method
- [ ] Implement searchJobs method
- [ ] Implement createJob method (employer)
- [ ] Implement updateJob method (employer)
- [ ] Implement deleteJob method (employer)
- [ ] Implement getMyJobs method (employer)
- [ ] Implement closeJob method (employer)
- [ ] Connect home screen to jobs repository
- [ ] Connect job detail screen to jobs repository
- [ ] Connect employer job creation screen
- [ ] Connect employer job list screen
- [ ] Test job CRUD operations
- [ ] Test job filtering (category, location, type)

**Deliverables**:

- Students see real jobs on home screen
- Job detail pages work
- Employers can create/edit/delete jobs
- Job search and filtering works

**Time**: 16 hours (2 days)

---

#### **Day 7: Application System (Part 1)**

**Goal**: Students can apply to jobs

**Tasks**:

- [ ] Create `application_repo_abstract.dart`
- [ ] Create `application_repo_impl.dart`
- [ ] Implement submitApplication method
- [ ] Implement getMyApplications method (student)
- [ ] Implement canReapply method
- [ ] Implement withdrawApplication method
- [ ] Connect apply job screen to repository
- [ ] Connect my applications screen to repository
- [ ] Test application submission
- [ ] Test application listing

**Deliverables**:

- Students can apply to jobs
- Application history displays correctly
- Reapplication logic works

**Time**: 8 hours (1 day)

---

### **WEEK 2: ESSENTIAL FEATURES** 🔥

#### **Day 8: Application System (Part 2)**

**Goal**: Employers can view and respond to applications

**Tasks**:

- [ ] Implement getJobApplications method (employer)
- [ ] Implement updateApplicationStatus method
- [ ] Implement acceptApplication method
- [ ] Implement rejectApplication method
- [ ] Connect employer applications screen
- [ ] Connect job requests screen
- [ ] Test application workflow end-to-end
- [ ] Test status updates

**Deliverables**:

- Employers see applications for their jobs
- Employers can accept/reject applications
- Students see status updates
- Full application flow works

**Time**: 8 hours (1 day)

---

#### **Day 9: Saved Jobs & Notifications**

**Goal**: Students can save jobs, all users get notifications

**Tasks**:

- [ ] Create `saved_jobs_repo_abstract.dart`
- [ ] Create `saved_jobs_repo_impl.dart`
- [ ] Implement saveJob method
- [ ] Implement unsaveJob method
- [ ] Implement getSavedJobs method
- [ ] Implement isJobSaved method
- [ ] Create `notifications_repo_abstract.dart`
- [ ] Create `notifications_repo_impl.dart`
- [ ] Implement getNotifications method
- [ ] Implement markAsRead method
- [ ] Implement markAllAsRead method
- [ ] Implement deleteNotification method
- [ ] Connect saved jobs screen
- [ ] Connect notifications screen
- [ ] Add notification badges
- [ ] Test bookmarking flow
- [ ] Test notification flow

**Deliverables**:

- Saved jobs screen works with real data
- Notifications screen works with real data
- Bookmark buttons work throughout app
- Notification badges show unread count

**Time**: 8 hours (1 day)

---

#### **Day 10-11: Review System**

**Goal**: Students and employers can rate each other

**Tasks**:

- [ ] Create `review_repo_abstract.dart`
- [ ] Create `review_repo_impl.dart`
- [ ] Implement getReviews method
- [ ] Implement submitReview method (student → employer)
- [ ] Implement submitReview method (employer → student)
- [ ] Implement updateReview method
- [ ] Implement deleteReview method
- [ ] Implement calculateAverageRating method
- [ ] Connect rate employer screen
- [ ] Connect rate student screen
- [ ] Display ratings on student profiles
- [ ] Display ratings on employer profiles
- [ ] Test review submission
- [ ] Test rating calculations

**Deliverables**:

- Students can rate employers after job completion
- Employers can rate students after job completion
- Ratings display on profiles
- Average ratings calculate correctly

**Time**: 16 hours (2 days)

---

#### **Day 12-14: Integration, Testing & Polish**

**Goal**: Everything works together seamlessly

**Tasks**:

- [ ] Replace all remaining mock data with real data
- [ ] Update dependency injection to use new repositories
- [ ] Remove all TODO comments for implemented features
- [ ] End-to-end testing: Student flow
  - Register → Login → Browse jobs → Apply → View applications
- [ ] End-to-end testing: Employer flow
  - Register → Login → Create job → View applications → Respond
- [ ] End-to-end testing: Admin flow
  - Login → View dashboard → Manage users
- [ ] Test edge cases:
  - Empty states (no jobs, no applications)
  - Error handling (network failures, validation errors)
  - Loading states
- [ ] Performance optimization:
  - Query optimization
  - Image loading optimization
  - Pagination for large lists
- [ ] Bug fixes
- [ ] UI polish
- [ ] Documentation updates

**Deliverables**:

- All critical flows work end-to-end
- No mock data remains
- App handles errors gracefully
- Performance is acceptable
- Ready for demo/testing

**Time**: 24 hours (3 days)

---

## 🎯 TOP 5 IMMEDIATE PRIORITIES

### **1. Authentication Repository** 🔥

**Start**: NOW  
**Time**: 4-6 hours  
**Impact**: UNBLOCKS EVERYTHING

**Files to Create**:

```
lib/data/repositories/auth/
  ├── auth_repo_abstract.dart
  └── auth_repo_impl.dart
```

**Methods to Implement**:

```dart
abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    required String role, // 'student' | 'employer' | 'admin'
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<String> getUserRole(); // Returns 'student' | 'employer' | 'admin'
  Future<bool> isAuthenticated();
}
```

**Why First**: Nothing else works without authentication. This is the foundation.

---

### **2. Jobs Repository** 🔥

**Start**: Day 1-2  
**Time**: 8-10 hours  
**Impact**: CORE MARKETPLACE FUNCTIONALITY

**Files to Create**:

```
lib/data/repositories/jobs/
  ├── job_repo_abstract.dart
  └── job_repo_impl.dart
```

**Methods to Implement**:

```dart
abstract class JobRepository {
  // Student Interface
  Future<List<JobModel>> getActiveJobs({
    String? category,
    String? jobType,
    int? limit,
  });
  Future<List<JobModel>> getUrgentJobs();
  Future<JobModel> getJobById(String id);
  Future<List<JobModel>> searchJobs(
    String query,
    Map<String, dynamic> filters,
  );
  Future<List<JobModel>> getJobsByCategory(String category);

  // Employer Interface
  Future<JobModel> createJob(JobModel job);
  Future<JobModel> updateJob(String id, JobModel job);
  Future<void> deleteJob(String id);
  Future<List<JobModel>> getMyJobs(
    String employerId,
    {String? status}
  );
  Future<void> closeJob(String id);
  Future<void> markJobAsUrgent(String id);

  // Analytics
  Future<void> incrementViewCount(String id);
  Future<Map<String, dynamic>> getJobStatistics(String id);
}
```

**Why Second**: The entire app is about jobs. Students browse jobs, employers create jobs.

---

### **3. Applications Repository** 🔥

**Start**: Day 3-4  
**Time**: 6-8 hours  
**Impact**: CONNECTS STUDENTS WITH EMPLOYERS

**Files to Create**:

```
lib/data/repositories/applications/
  ├── application_repo_abstract.dart
  └── application_repo_impl.dart
```

**Methods to Implement**:

```dart
abstract class ApplicationRepository {
  // Student Interface
  Future<ApplicationModel> submitApplication(
    ApplicationModel application,
  );
  Future<List<ApplicationModel>> getMyApplications(
    String studentId,
    {String? status},
  );
  Future<bool> canReapply(String jobId, String studentId);
  Future<void> withdrawApplication(String id);

  // Employer Interface
  Future<List<ApplicationModel>> getJobApplications(
    String jobId,
    {String? status},
  );
  Future<void> updateApplicationStatus(
    String id,
    String status,
    String? employerNote,
  );
  Future<void> acceptApplication(String id);
  Future<void> rejectApplication(String id, String reason);
  Future<void> shortlistApplication(String id);

  // Common
  Future<ApplicationModel> getApplicationById(String id);
  Future<int> getApplicationCount(String jobId);
}
```

**Why Third**: This is how students get jobs. This is your revenue model.

---

### **4. Student Profile Repository** 🔥

**Start**: Day 1  
**Time**: 4-5 hours  
**Impact**: STUDENT IDENTITY

**Files to Create**:

```
lib/data/repositories/student_profile/
  ├── student_profile_repo_abstract.dart
  └── student_profile_repo_impl.dart
```

**Methods to Implement**:

```dart
abstract class StudentProfileRepository {
  Future<StudentModel> getProfile(String userId);
  Future<StudentModel> updateProfile(String userId, StudentModel profile);
  Future<void> uploadCV(String userId, File cvFile);
  Future<void> uploadProfilePicture(String userId, File imageFile);

  // Skills Management
  Future<void> addSkill(String userId, String skill, String proficiency);
  Future<void> removeSkill(String userId, String skillId);
  Future<List<String>> getSkills(String userId);

  // Statistics
  Future<Map<String, dynamic>> getStatistics(String userId);
  // Returns: { jobs_completed, rating, review_count }
}
```

**Why Fourth**: Students need profiles to apply for jobs. Employers view student profiles.

---

### **5. Employer Profile Repository** 🔥

**Start**: Day 1  
**Time**: 4-5 hours  
**Impact**: EMPLOYER CREDIBILITY

**Files to Create**:

```
lib/data/repositories/employer_profile/
  ├── employer_profile_repo_abstract.dart
  └── employer_profile_repo_impl.dart
```

**Methods to Implement**:

```dart
abstract class EmployerProfileRepository {
  Future<EmployerModel> getProfile(String userId);
  Future<EmployerModel> updateProfile(String userId, EmployerModel profile);
  Future<void> uploadLogo(String userId, File logoFile);
  Future<void> uploadVerificationDoc(String userId, File docFile);

  // Verification
  Future<void> requestVerification(String userId);
  Future<bool> isVerified(String userId);

  // Statistics
  Future<Map<String, dynamic>> getStatistics(String userId);
  // Returns: { active_jobs, total_jobs_posted, total_hires, rating, review_count }
}
```

**Why Fifth**: Employers need credible profiles to attract students. Trust is everything.

---

## 📋 IMPLEMENTATION CHECKLIST

### **TODAY (Day 0)**

- [ ] Read this entire document
- [ ] Set up development environment
- [ ] Ensure database schema is deployed
- [ ] Create git branch: `feature/database-integration`
- [ ] Start with Priority #1: Authentication Repository

---

### **Week 1 Checklist**

#### **Day 1-2: Authentication**

- [ ] Auth repository abstract interface created
- [ ] Auth repository implementation created
- [ ] Login method works
- [ ] Register method works (all 3 roles)
- [ ] Logout method works
- [ ] getCurrentUser works
- [ ] getUserRole works
- [ ] Login screen connected to repository
- [ ] Role-based navigation works
- [ ] SharedPreferences replaced with real auth
- [ ] End-to-end auth flow tested

#### **Day 3-4: Profiles**

- [ ] Student profile repository created
- [ ] Employer profile repository created
- [ ] Profile screens connected to repositories
- [ ] Profile editing works
- [ ] CV upload works
- [ ] Logo upload works
- [ ] Skills management works
- [ ] Profile statistics display correctly
- [ ] All mock profile data removed

#### **Day 5-6: Jobs**

- [ ] Jobs repository created
- [ ] Home screen shows real jobs
- [ ] Job detail screen shows real data
- [ ] Urgent jobs section works
- [ ] Category filtering works
- [ ] Search functionality works
- [ ] Employer can create jobs
- [ ] Employer can edit jobs
- [ ] Employer can delete jobs
- [ ] Job photos upload works
- [ ] All mock job data removed

#### **Day 7: Applications (Part 1)**

- [ ] Applications repository created
- [ ] Student can submit applications
- [ ] Application form validation works
- [ ] CV upload with application works
- [ ] Student sees application history
- [ ] Application status displays correctly
- [ ] Reapplication logic works
- [ ] Student can withdraw applications

---

### **Week 2 Checklist**

#### **Day 8: Applications (Part 2)**

- [ ] Employer sees applications for their jobs
- [ ] Employer can filter applications by status
- [ ] Employer can accept applications
- [ ] Employer can reject applications
- [ ] Status changes reflect in student view
- [ ] Employer notes save correctly
- [ ] Application counts update correctly
- [ ] Full application workflow tested

#### **Day 9: Saved Jobs & Notifications**

- [ ] Saved jobs repository created
- [ ] Notifications repository created
- [ ] Student can save jobs
- [ ] Student can unsave jobs
- [ ] Saved jobs screen shows real data
- [ ] Bookmark icon state works everywhere
- [ ] Notifications screen shows real data
- [ ] Mark as read works
- [ ] Notification badges show correct count
- [ ] Notification types work correctly

#### **Day 10-11: Reviews**

- [ ] Review repository created
- [ ] Student can rate employers
- [ ] Employer can rate students
- [ ] Ratings display on profiles
- [ ] Average rating calculates correctly
- [ ] Review comments display
- [ ] Review editing works
- [ ] Cannot review without completed job
- [ ] Dual-sided rating system works

#### **Day 12-14: Integration & Polish**

- [ ] All TODO comments addressed
- [ ] All mock data removed
- [ ] Dependency injection updated
- [ ] Error handling implemented everywhere
- [ ] Loading states implemented everywhere
- [ ] Empty states implemented everywhere
- [ ] Student flow tested end-to-end
- [ ] Employer flow tested end-to-end
- [ ] Admin flow tested end-to-end
- [ ] Performance optimized
- [ ] Images load efficiently
- [ ] Queries are optimized
- [ ] Pagination implemented for large lists
- [ ] App ready for demo

---

## 🎓 QUICK WINS (Already 80% Done)

These screens have UI but need repository connection:

1. **Saved Jobs Screen** ✅

   - UI: Complete
   - Need: `saved_jobs` repository
   - Time: 2 hours
   - File: `lib/views/screens/jobs/saved_jobs_screen.dart`

2. **Notifications Screen** ✅

   - UI: Complete
   - Need: `notifications` repository
   - Time: 2 hours
   - File: `lib/views/screens/notifications/notifications_screen.dart`

3. **My Applications Screen** ✅

   - UI: Complete
   - Need: `applications` repository
   - Time: 3 hours
   - File: `lib/views/screens/jobs/my_applications_screen.dart`

4. **Job Detail Screen** ✅

   - UI: Complete
   - Need: `jobs` repository
   - Time: 2 hours
   - File: `lib/views/screens/jobs/job_detail_screen.dart`

5. **Profile Screens** ✅
   - UI: Complete
   - Need: `student_profile` and `employer_profile` repositories
   - Time: 4 hours
   - Files:
     - `lib/views/screens/profile/student_profile_screen.dart`
     - `lib/views/screens/profile/employer_profile_screen.dart`

**Total Quick Win Time**: ~13 hours (Day 8-9 of Week 2)

---

## 🔴 CRITICAL PATH

```
┌─────────────┐
│    Auth     │  Day 1-2: Users can login
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Profiles   │  Day 3-4: Users have identity
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    Jobs     │  Day 5-6: Content to browse
└──────┬──────┘
       │
       ▼
┌─────────────┐
│Applications │  Day 7-8: Connection happens
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Testing   │  Day 12-14: Everything works
└─────────────┘
```

**DO NOT** deviate from this path. Each step depends on the previous one.

---

## ⚠️ WHAT NOT TO DO

### **Don't Start With These (Yet):**

1. ❌ Education content - Nice to have, not critical
2. ❌ Services marketplace - Future feature
3. ❌ Admin moderation - Can do manually
4. ❌ Multi-language - Start with one language
5. ❌ Advanced analytics - Focus on core functionality
6. ❌ Social features - Not needed for MVP
7. ❌ Chat system - Not in current scope

### **Don't Over-Engineer:**

1. ❌ Don't build a complex recommendation engine
2. ❌ Don't implement real-time features yet
3. ❌ Don't optimize prematurely
4. ❌ Don't add features not in the database schema
5. ❌ Don't rewrite working UI code

### **Focus Only On:**

1. ✅ Auth → Profiles → Jobs → Applications
2. ✅ Making the critical path work
3. ✅ Real data instead of mock data
4. ✅ End-to-end user flows
5. ✅ Meeting the 2-week deadline

---

## 💡 SUCCESS METRICS

### **Week 1 Success (End of Day 7)**

- [ ] Users can register and login
- [ ] Profiles display real data
- [ ] Students can browse real jobs
- [ ] Employers can create real jobs
- [ ] Students can submit applications

### **Week 2 Success (End of Day 14)**

- [ ] Employers can view and respond to applications
- [ ] Students can save jobs
- [ ] Notifications work
- [ ] Reviews work
- [ ] All critical flows tested and working

### **Demo Ready Checklist**

- [ ] Can demo: Student registers → browses jobs → applies
- [ ] Can demo: Employer registers → creates job → views applications
- [ ] Can demo: Application accepted → both parties notified
- [ ] Can demo: Job completed → reviews submitted
- [ ] No crashes on critical paths
- [ ] Acceptable performance (< 2s page loads)

---

## 📞 NEED HELP?

### **If You Get Stuck:**

1. Check the DATABASE_SCHEMA.md for table structure
2. Check existing model files for data structure
3. Check existing UI screens for expected behavior
4. Search for similar implementations in codebase
5. Break the problem into smaller steps

### **Common Issues:**

- **Auth not working**: Check SharedPreferences is properly replaced
- **Data not loading**: Check repository is registered in dependency injection
- **UI not updating**: Check BlocProvider/StateManagement is connected
- **Null errors**: Check all fields are properly initialized
- **Foreign key errors**: Check relationships match database schema

---

## 🎉 FINAL RECOMMENDATION

**Focus 90% of your time on CRITICAL features**:

1. Authentication & Profiles (Days 1-4)
2. Job Posting System (Days 5-6)
3. Application System (Days 7-8)

Get these three working perfectly. Everything else is secondary.

**Your mantra for the next 2 weeks:**

> "Does this feature help students find jobs or employers find students? If not, it waits."

---

## 📚 RELATED DOCUMENTATION

- `DATABASE_SCHEMA.md` - Complete database schema with 40+ tables
- `DATABASE_QUICK_REFERENCE.md` - Quick reference for common queries
- `NAVIGATION_GUIDE.md` - App navigation structure
- `FRONTEND_README.md` - Frontend architecture overview

---

**Last Updated**: December 5, 2025  
**Next Review**: After Week 1 (Day 7)  
**Status**: Ready to implement

---

**Good luck! You've got this! 🚀**
