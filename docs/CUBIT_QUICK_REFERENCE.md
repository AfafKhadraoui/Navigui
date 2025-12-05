# QUICK REFERENCE: All Cubits & Their Usage

## 🎯 Quick Cubit Lookup

### 1. AuthCubit

**When to use:** Login, Signup, Logout, Check auth status  
**How to access:**

```dart
context.read<AuthCubit>().login(email: email, password: password);
context.read<AuthCubit>().signup(...);
context.read<AuthCubit>().logout();
```

**States to handle:**

- `AuthLoading` → Show loading indicator
- `AuthAuthenticated(user)` → Navigate to home
- `AuthUnauthenticated` → Navigate to login
- `AuthError(message)` → Show error

---

### 2. JobCubit

**When to use:** Browse jobs, view job details, filter, sort  
**How to access:**

```dart
context.read<JobCubit>().loadJobs();
context.read<JobCubit>().loadJobDetails(jobId);
context.read<JobCubit>().searchJobs(query);
context.read<JobCubit>().filterByCategory(category);
context.read<JobCubit>().sortJobs('salary_high');
```

**States to handle:**

- `JobLoading` → Loading indicator
- `JobLoaded(jobs, filters)` → Show job list
- `JobDetailLoaded(job)` → Show job details
- `JobError(message)` → Error message

---

### 3. ApplicationCubit

**When to use:** Submit/view/withdraw applications (Student side)  
**How to access:**

```dart
context.read<ApplicationCubit>().submitApplication(jobId: id, coverLetter: letter);
context.read<ApplicationCubit>().loadMyApplications();
context.read<ApplicationCubit>().withdrawApplication(appId);
context.read<ApplicationCubit>().filterByStatus('pending');
```

**States to handle:**

- `ApplicationLoading` → Loading
- `ApplicationsLoaded(applications)` → Show list
- `ApplicationSubmitted` → Success message
- `ApplicationError(message)` → Error

---

### 4. StudentProfileCubit

**When to use:** View/edit student profile  
**How to access:**

```dart
context.read<StudentProfileCubit>().loadProfile(userId);
context.read<StudentProfileCubit>().updateProfile(userId: id, bio: bio, ...);
```

**States to handle:**

- `StudentProfileLoading` → Loading
- `StudentProfileLoaded(profile)` → Show profile
- `StudentProfileUpdated(profile)` → Success
- `StudentProfileError(message)` → Error

---

### 5. EmployerProfileCubit

**When to use:** View/edit employer/company profile  
**How to access:**

```dart
context.read<EmployerProfileCubit>().loadProfile(userId);
context.read<EmployerProfileCubit>().updateProfile(userId: id, companyName: name, ...);
```

**States to handle:**

- Same pattern as StudentProfileCubit

---

### 6. EmployerJobCubit

**When to use:** Employer creates/edits/deletes their jobs  
**How to access:**

```dart
context.read<EmployerJobCubit>().loadMyJobs();
context.read<EmployerJobCubit>().createJob(title: title, ...);
context.read<EmployerJobCubit>().updateJob(jobId: id, ...);
context.read<EmployerJobCubit>().deleteJob(jobId);
context.read<EmployerJobCubit>().closeJob(jobId);
```

**States to handle:**

- `EmployerJobLoading` → Loading
- `EmployerJobsLoaded(jobs)` → Show employer's jobs
- `EmployerJobCreated` → Success
- `EmployerJobError(message)` → Error

---

### 7. EmployerApplicationCubit

**When to use:** Employer reviews applications (Accept/Reject/Shortlist)  
**How to access:**

```dart
context.read<EmployerApplicationCubit>().loadJobApplications(jobId: id);
context.read<EmployerApplicationCubit>().acceptApplication(appId);
context.read<EmployerApplicationCubit>().rejectApplication(appId);
context.read<EmployerApplicationCubit>().shortlistApplication(appId);
```

**States to handle:**

- `EmployerApplicationLoading` → Loading
- `EmployerApplicationsLoaded(applications)` → Show list
- `EmployerApplicationUpdated` → Success
- `EmployerApplicationError(message)` → Error

---

### 8. NotificationCubit

**When to use:** Show notifications, mark as read  
**How to access:**

```dart
context.read<NotificationCubit>().loadNotifications();
context.read<NotificationCubit>().markAsRead(notifId);
context.read<NotificationCubit>().markAllAsRead();
context.read<NotificationCubit>().deleteNotification(notifId);
```

**States to handle:**

- `NotificationLoading` → Loading
- `NotificationsLoaded(notifications, unreadCount)` → Show list + badge
- `NotificationError(message)` → Error

---

### 9. SearchCubit

**When to use:** Advanced job search with filters  
**How to access:**

```dart
context.read<SearchCubit>().search(query: query, filters: {...});
context.read<SearchCubit>().applyFilters(query: query, filters: {...});
context.read<SearchCubit>().clearSearch();
```

**States to handle:**

- `SearchLoading` → Loading
- `SearchResultsLoaded(results, query, filters, recentSearches)` → Show results
- `SearchEmpty(query)` → No results message
- `SearchError(message)` → Error

---

### 10. SavedJobsCubit

**When to use:** Bookmark/unbookmark jobs  
**How to access:**

```dart
context.read<SavedJobsCubit>().loadSavedJobs();
context.read<SavedJobsCubit>().saveJob(jobId);
context.read<SavedJobsCubit>().unsaveJob(jobId);
context.read<SavedJobsCubit>().toggleSaveJob(jobId); // Smart toggle

// Check if saved:
final cubit = context.read<SavedJobsCubit>();
bool isSaved = cubit.isJobSaved(jobId);
```

**States to handle:**

- `SavedJobsLoading` → Loading
- `SavedJobsLoaded(savedJobs, savedJobIds)` → Show bookmarked jobs
- `JobSaved` → Success feedback
- `JobUnsaved` → Success feedback
- `SavedJobsError(message)` → Error

---

### 11. ReviewCubit

**When to use:** Submit/view reviews for employers or students  
**How to access:**

```dart
context.read<ReviewCubit>().loadReviews(employerId: id); // or studentId: id
context.read<ReviewCubit>().submitReview(
  revieweeId: id,
  revieweeType: 'employer', // or 'student'
  rating: 4.5,
  comment: comment,
);
context.read<ReviewCubit>().updateReview(reviewId: id, rating: 5.0);
context.read<ReviewCubit>().deleteReview(reviewId);
```

**States to handle:**

- `ReviewLoading` → Loading
- `ReviewsLoaded(reviews, averageRating, ratingDistribution)` → Show reviews + stats
- `ReviewSubmitted` → Success
- `ReviewError(message)` → Error

---

### 12. EducationCubit

**When to use:** Browse educational articles  
**How to access:**

```dart
context.read<EducationCubit>().loadArticles();
context.read<EducationCubit>().loadArticleDetail(articleId);
context.read<EducationCubit>().searchArticles(query);
context.read<EducationCubit>().filterByCategory(category);
```

**States to handle:**

- `EducationLoading` → Loading
- `EducationArticlesLoaded(articles)` → Show articles
- `EducationArticleDetailLoaded(article)` → Show single article
- `EducationError(message)` → Error

---

### 13. AdminCubit

**When to use:** Admin panel operations  
**How to access:**

```dart
context.read<AdminCubit>().loadDashboard();
context.read<AdminCubit>().loadUsers(roleFilter: 'student');
context.read<AdminCubit>().loadJobs(statusFilter: 'active');
context.read<AdminCubit>().verifyEmployer(userId);
context.read<AdminCubit>().suspendUser(userId);
context.read<AdminCubit>().deleteJob(jobId);
```

**States to handle:**

- `AdminLoading` → Loading
- `AdminDashboardLoaded(statistics)` → Show dashboard
- `AdminUsersLoaded(users)` → Show user list
- `AdminJobsLoaded(jobs)` → Show job list
- `AdminError(message)` → Error

---

## 🎨 Common UI Patterns

### Pattern 1: Simple Display (Use BlocBuilder)

```dart
BlocBuilder<JobCubit, JobState>(
  builder: (context, state) {
    if (state is JobLoading) return CircularProgressIndicator();
    if (state is JobLoaded) return ListView(...);
    if (state is JobError) return Text(state.message);
    return SizedBox.shrink();
  },
)
```

### Pattern 2: Display + Actions (Use BlocConsumer)

```dart
BlocConsumer<ApplicationCubit, ApplicationState>(
  listener: (context, state) {
    if (state is ApplicationSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Success!')),
      );
      context.pop();
    }
  },
  builder: (context, state) {
    return Form(...); // Your UI
  },
)
```

### Pattern 3: Load on Init

```dart
@override
void initState() {
  super.initState();
  context.read<JobCubit>().loadJobs();
}
```

### Pattern 4: Pull to Refresh

```dart
RefreshIndicator(
  onRefresh: () async {
    await context.read<JobCubit>().refreshJobs();
  },
  child: ListView(...),
)
```

### Pattern 5: Check State Before Action

```dart
final authState = context.read<AuthCubit>().state;
if (authState is AuthAuthenticated) {
  final userId = authState.user.userId;
  // Use userId
}
```

---

## 🔧 Common Operations

### Get Current User

```dart
final authState = context.read<AuthCubit>().state;
if (authState is AuthAuthenticated) {
  final user = authState.user;
  print('User: ${user.fullName}, Role: ${user.role}');
}
```

### Conditional UI Based on Auth

```dart
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    if (state is AuthAuthenticated) {
      final isStudent = state.user.role == 'student';
      return isStudent ? StudentHomeScreen() : EmployerDashboardScreen();
    }
    return LoginScreen();
  },
)
```

### Show Loading Button

```dart
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    final isLoading = state is AuthLoading;

    return ElevatedButton(
      onPressed: isLoading ? null : () {
        context.read<AuthCubit>().login(...);
      },
      child: isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text('Login'),
    );
  },
)
```

### Multiple Cubits in One Screen

```dart
MultiBlocListener(
  listeners: [
    BlocListener<ApplicationCubit, ApplicationState>(
      listener: (context, state) {
        if (state is ApplicationSubmitted) {
          // Handle application submitted
        }
      },
    ),
    BlocListener<NotificationCubit, NotificationState>(
      listener: (context, state) {
        // Handle notifications
      },
    ),
  ],
  child: YourScreenContent(),
)
```

---

## 📋 Testing Checklist Template

For each screen you migrate:

- [ ] Removed all `setState` calls
- [ ] Removed `Provider.of` references
- [ ] Using `BlocBuilder` or `BlocConsumer`
- [ ] Calling cubit methods correctly
- [ ] Handling `Loading` state
- [ ] Handling `Loaded/Success` state
- [ ] Handling `Error` state
- [ ] Loading indicators show
- [ ] Error messages display
- [ ] Navigation works
- [ ] No console errors

---

## 🚨 Common Mistakes to Avoid

❌ **Don't do this:**

```dart
// DON'T use context.watch in event handlers
ElevatedButton(
  onPressed: () {
    context.watch<AuthCubit>().login(); // WRONG
  },
)
```

✅ **Do this instead:**

```dart
ElevatedButton(
  onPressed: () {
    context.read<AuthCubit>().login(); // CORRECT
  },
)
```

---

❌ **Don't access cubit in initState like this:**

```dart
@override
void initState() {
  super.initState();
  context.read<JobCubit>().loadJobs(); // WRONG - context not ready
}
```

✅ **Do this instead:**

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<JobCubit>().loadJobs(); // CORRECT
  });
}

// OR use didChangeDependencies:
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (!_initialized) {
    context.read<JobCubit>().loadJobs();
    _initialized = true;
  }
}
```

---

❌ **Don't forget to provide cubits:**

```dart
// If cubit not in main.dart MultiBlocProvider:
Navigator.push(context, MaterialPageRoute(
  builder: (_) => SomeScreen(), // WRONG - no cubit access
));
```

✅ **Do this instead:**

```dart
Navigator.push(context, MaterialPageRoute(
  builder: (_) => BlocProvider.value(
    value: context.read<SomeCubit>(),
    child: SomeScreen(), // CORRECT
  ),
));

// OR use go_router which handles this automatically
context.push('/some-screen');
```

---

## 💡 Pro Tips

1. **Load data in initState:** Always load data when screen opens
2. **Use pull-to-refresh:** Let users refresh data easily
3. **Handle all states:** Don't forget Initial, Loading, Error states
4. **Show feedback:** Use SnackBars for success/error messages
5. **Disable buttons:** Disable action buttons during loading
6. **Test thoroughly:** Test happy path AND error cases

---

**🎯 Use this as your quick reference while implementing!**
