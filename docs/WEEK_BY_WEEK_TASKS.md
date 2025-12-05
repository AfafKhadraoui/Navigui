# 5-WEEK IMPLEMENTATION ROADMAP

## Complete Week-by-Week Task Breakdown

---

## 📅 WEEK 1: Foundation & Authentication (Days 1-5)

**Goal:** Get authentication working with BLoC pattern  
**Priority:** ⭐⭐⭐⭐⭐ HIGHEST - Everything depends on this

### Day 1: Setup & Preparation

**Time Estimate:** 2-3 hours

#### Tasks:

1. **Verify Installation** ✅

   - Run `flutter pub get` ✅ DONE
   - Verify all dependencies installed ✅ DONE
   - Test app runs: `flutter run`
   - Check for compilation errors

2. **Understand Current Auth Flow**

   - Read `lib/logic/services/auth_service.dart` (old implementation)
   - Read `lib/logic/cubits/auth/auth_cubit.dart` (new implementation)
   - Compare the two approaches

3. **Plan Migration Strategy**
   - Identify all screens that use `AuthService`
   - List all `Provider.of<AuthService>` usages
   - Prepare to replace with `context.read<AuthCubit>()`

#### Deliverables:

- [ ] App runs without errors
- [ ] Understanding of old vs new approach
- [ ] List of files to modify

---

### Day 2: Login Screen Migration

**Time Estimate:** 3-4 hours

#### Tasks:

1. **Update `LoginScreen`**

   - **File:** `lib/views/screens/auth/login_screen.dart`

   **Steps:**

   ```dart
   // BEFORE (Old Provider pattern):
   final authService = Provider.of<AuthService>(context);
   authService.login(email, password);

   // AFTER (New BLoC pattern):
   context.read<AuthCubit>().login(email: email, password: password);
   ```

2. **Wrap Login UI with BlocConsumer**

   ```dart
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: BlocConsumer<AuthCubit, AuthState>(
         listener: (context, state) {
           if (state is AuthAuthenticated) {
             // Navigate to home based on user role
             final role = state.user.role;
             if (role == 'student') {
               context.go('/student-home');
             } else if (role == 'employer') {
               context.go('/employer-dashboard');
             }
           } else if (state is AuthError) {
             // Show error message
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                 content: Text(state.message),
                 backgroundColor: Colors.red,
               ),
             );
           }
         },
         builder: (context, state) {
           final isLoading = state is AuthLoading;

           return Center(
             child: Column(
               children: [
                 TextField(/* email field */),
                 TextField(/* password field */),

                 // Login button with loading state
                 ElevatedButton(
                   onPressed: isLoading ? null : () {
                     context.read<AuthCubit>().login(
                       email: _emailController.text,
                       password: _passwordController.text,
                     );
                   },
                   child: isLoading
                     ? CircularProgressIndicator()
                     : Text('Login'),
                 ),
               ],
             ),
           );
         },
       ),
     );
   }
   ```

3. **Test Login Flow**
   - Test with correct credentials
   - Test with wrong credentials
   - Test empty fields
   - Verify loading indicator shows
   - Verify error messages appear

#### Deliverables:

- [ ] LoginScreen uses AuthCubit
- [ ] Loading states working
- [ ] Error handling working
- [ ] Navigation working

---

### Day 3: Signup Screens Migration

**Time Estimate:** 4-5 hours

#### Tasks:

1. **Update Student Signup Screens**

   - **Files:**
     - `lib/views/screens/auth/signup_student_screen.dart`
     - `lib/step1Student.dart`
     - `lib/step2Student.dart`

   **Steps:**

   - Replace `AuthService` with `AuthCubit`
   - Update signup call:
     ```dart
     context.read<AuthCubit>().signup(
       email: email,
       password: password,
       fullName: fullName,
       role: 'student',
       additionalData: {
         'phone': phone,
         'university': university,
         // ... other student data
       },
     );
     ```

2. **Update Employer Signup Screens**

   - **Files:**
     - `lib/views/screens/auth/signup_employer_screen.dart`

   **Steps:**

   - Same pattern as student signup
   - Use `role: 'employer'`
   - Pass company information in `additionalData`

3. **Wrap UI with BlocConsumer**
   - Same pattern as LoginScreen
   - Handle loading, success, error states

#### Deliverables:

- [ ] Student signup working with BLoC
- [ ] Employer signup working with BLoC
- [ ] Multi-step signup flows preserved
- [ ] All validation working

---

### Day 4: Logout & Auth Persistence

**Time Estimate:** 2-3 hours

#### Tasks:

1. **Update Profile/Settings Screens**

   - Find all logout buttons in the app
   - Replace with:
     ```dart
     ElevatedButton(
       onPressed: () async {
         await context.read<AuthCubit>().logout();
         context.go('/login');
       },
       child: Text('Logout'),
     )
     ```

2. **Update AppRouter**

   - **File:** `lib/routes/app_router.dart`
   - Update redirect logic to use `AuthCubit` instead of `AuthService`:

     ```dart
     redirect: (context, state) {
       final authState = context.read<AuthCubit>().state;

       if (authState is AuthAuthenticated) {
         // User is logged in
         final user = authState.user;
         // Check role-based routing
       } else if (authState is AuthUnauthenticated) {
         // Redirect to login
       }

       return null; // No redirect needed
     },
     ```

3. **Test Auth Persistence**
   - Login to app
   - Close app completely
   - Reopen app
   - Verify user still logged in (checkAuthStatus called in main.dart)

#### Deliverables:

- [ ] Logout working everywhere
- [ ] AppRouter uses AuthCubit
- [ ] Auth persists across app restarts
- [ ] Role-based routing working

---

### Day 5: Testing & Cleanup

**Time Estimate:** 3-4 hours

#### Tasks:

1. **Comprehensive Auth Testing**

   - [ ] Login with student account
   - [ ] Login with employer account
   - [ ] Login with wrong password
   - [ ] Signup as student
   - [ ] Signup as employer
   - [ ] Logout and verify
   - [ ] App restart persistence
   - [ ] Navigation after login
   - [ ] Navigation after logout

2. **Remove Old Auth Code**

   - **Delete:** `lib/logic/services/auth_service.dart`
   - Remove all `ChangeNotifierProvider` references
   - Remove `provider` package if not used elsewhere

3. **Code Review**
   - Review all auth-related files
   - Check for console errors
   - Verify no memory leaks
   - Clean up unused imports

#### Deliverables:

- [ ] All auth flows tested and working
- [ ] Old auth code removed
- [ ] No compilation errors
- [ ] Clean codebase

---

## 📅 WEEK 2: Core Job Features (Days 6-10)

**Goal:** Implement job browsing, search, filtering, and applications  
**Priority:** ⭐⭐⭐⭐ HIGH

### Day 6: Home Screen & Job Listings

**Time Estimate:** 4-5 hours

#### Tasks:

1. **Update HomeScreen**

   - **File:** `lib/views/screens/homescreen/home_screen.dart`

   **Steps:**

   ```dart
   class HomeScreen extends StatefulWidget {
     @override
     State<HomeScreen> createState() => _HomeScreenState();
   }

   class _HomeScreenState extends State<HomeScreen> {
     @override
     void initState() {
       super.initState();
       // Load jobs when screen opens
       context.read<JobCubit>().loadJobs();
     }

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         body: BlocBuilder<JobCubit, JobState>(
           builder: (context, state) {
             if (state is JobLoading) {
               return Center(child: CircularProgressIndicator());
             } else if (state is JobLoaded) {
               // Show featured jobs (first 5)
               final featuredJobs = state.jobs.take(5).toList();
               return ListView.builder(
                 itemCount: featuredJobs.length,
                 itemBuilder: (context, index) {
                   return JobCard(job: featuredJobs[index]);
                 },
               );
             } else if (state is JobError) {
               return Center(child: Text('Error: ${state.message}'));
             }
             return SizedBox.shrink();
           },
         ),
       );
     }
   }
   ```

2. **Update JobsPage**
   - **File:** `lib/views/screens/jobs/jobs_page.dart`
   - Remove hardcoded mock data
   - Use `JobCubit` to load all jobs
   - Same pattern as HomeScreen

#### Deliverables:

- [ ] HomeScreen shows real job data
- [ ] JobsPage shows all jobs
- [ ] Loading states working
- [ ] Error handling implemented

---

### Day 7: Job Details & Categories

**Time Estimate:** 3-4 hours

#### Tasks:

1. **Update JobDetailScreen**

   - **File:** `lib/views/screens/jobs/job_detail_screen.dart`

   ```dart
   class JobDetailScreen extends StatefulWidget {
     final int jobId;

     @override
     State<JobDetailScreen> createState() => _JobDetailScreenState();
   }

   class _JobDetailScreenState extends State<JobDetailScreen> {
     @override
     void initState() {
       super.initState();
       context.read<JobCubit>().loadJobDetails(widget.jobId);
     }

     @override
     Widget build(BuildContext context) {
       return BlocBuilder<JobCubit, JobState>(
         builder: (context, state) {
           if (state is JobDetailLoaded) {
             final job = state.job;
             return Scaffold(
               appBar: AppBar(title: Text(job.title)),
               body: Column(
                 children: [
                   Text(job.description),
                   Text('Salary: ${job.salary} DZD'),
                   Text('Location: ${job.location}'),
                   // ... more job details

                   ElevatedButton(
                     onPressed: () {
                       // Navigate to apply screen
                       context.push('/apply-job/${job.jobId}');
                     },
                     child: Text('Apply Now'),
                   ),
                 ],
               ),
             );
           }
           return Center(child: CircularProgressIndicator());
         },
       );
     }
   }
   ```

2. **Update Category Pages**
   - Filter jobs by category using `filterByCategory()`

#### Deliverables:

- [ ] Job details screen working
- [ ] Category filtering working
- [ ] Navigation between screens smooth

---

### Day 8: Search & Filters

**Time Estimate:** 4-5 hours

#### Tasks:

1. **Update SearchPage**

   - **File:** `lib/views/screens/search/search_page.dart`

   ```dart
   class SearchPage extends StatefulWidget {
     @override
     State<SearchPage> createState() => _SearchPageState();
   }

   class _SearchPageState extends State<SearchPage> {
     final _searchController = TextEditingController();

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(
           title: TextField(
             controller: _searchController,
             decoration: InputDecoration(hintText: 'Search jobs...'),
             onChanged: (query) {
               if (query.length >= 3) {
                 context.read<SearchCubit>().search(query: query);
               }
             },
           ),
         ),
         body: BlocBuilder<SearchCubit, SearchState>(
           builder: (context, state) {
             if (state is SearchLoading) {
               return Center(child: CircularProgressIndicator());
             } else if (state is SearchResultsLoaded) {
               return Column(
                 children: [
                   // Recent searches
                   if (state.recentSearches.isNotEmpty)
                     Wrap(
                       children: state.recentSearches.map((search) {
                         return Chip(label: Text(search));
                       }).toList(),
                     ),

                   // Results
                   Expanded(
                     child: ListView.builder(
                       itemCount: state.results.length,
                       itemBuilder: (context, index) {
                         return JobCard(job: state.results[index]);
                       },
                     ),
                   ),
                 ],
               );
             } else if (state is SearchEmpty) {
               return Center(child: Text('No results for "${state.query}"'));
             }
             return Center(child: Text('Start searching...'));
           },
         ),
       );
     }
   }
   ```

2. **Add Filter Options**
   - Add category dropdown
   - Add sort options (salary high/low, recent)
   - Use `applyFilters()` method

#### Deliverables:

- [ ] Search working in real-time
- [ ] Recent searches shown
- [ ] Filters working
- [ ] Sort options working

---

### Day 9: Job Applications

**Time Estimate:** 4-5 hours

#### Tasks:

1. **Update ApplyJobScreen**

   - **File:** `lib/views/screens/jobs/apply_job_screen.dart`

   ```dart
   class ApplyJobScreen extends StatefulWidget {
     final int jobId;

     @override
     State<ApplyJobScreen> createState() => _ApplyJobScreenState();
   }

   class _ApplyJobScreenState extends State<ApplyJobScreen> {
     final _coverLetterController = TextEditingController();

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(title: Text('Apply for Job')),
         body: BlocConsumer<ApplicationCubit, ApplicationState>(
           listener: (context, state) {
             if (state is ApplicationSubmitted) {
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text('Application submitted!')),
               );
               context.pop(); // Go back
             } else if (state is ApplicationError) {
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text(state.message)),
               );
             }
           },
           builder: (context, state) {
             final isLoading = state is ApplicationLoading;

             return Padding(
               padding: EdgeInsets.all(16),
               child: Column(
                 children: [
                   TextField(
                     controller: _coverLetterController,
                     decoration: InputDecoration(
                       labelText: 'Cover Letter',
                       hintText: 'Tell us why you\'re a good fit...',
                     ),
                     maxLines: 10,
                   ),

                   SizedBox(height: 20),

                   ElevatedButton(
                     onPressed: isLoading ? null : () {
                       context.read<ApplicationCubit>().submitApplication(
                         jobId: widget.jobId,
                         coverLetter: _coverLetterController.text,
                       );
                     },
                     child: isLoading
                       ? CircularProgressIndicator()
                       : Text('Submit Application'),
                   ),
                 ],
               ),
             );
           },
         ),
       );
     }
   }
   ```

2. **Update MyApplicationsScreen**

   - **File:** `lib/views/screens/student/my_applications_screen.dart`

   ```dart
   class MyApplicationsScreen extends StatefulWidget {
     @override
     State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
   }

   class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
     @override
     void initState() {
       super.initState();
       context.read<ApplicationCubit>().loadMyApplications();
     }

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(title: Text('My Applications')),
         body: Column(
           children: [
             // Status filter chips
             SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: Row(
                 children: [
                   FilterChip(
                     label: Text('All'),
                     onSelected: (_) {
                       context.read<ApplicationCubit>().loadMyApplications();
                     },
                   ),
                   FilterChip(
                     label: Text('Pending'),
                     onSelected: (_) {
                       context.read<ApplicationCubit>().filterByStatus('pending');
                     },
                   ),
                   FilterChip(
                     label: Text('Accepted'),
                     onSelected: (_) {
                       context.read<ApplicationCubit>().filterByStatus('accepted');
                     },
                   ),
                   FilterChip(
                     label: Text('Rejected'),
                     onSelected: (_) {
                       context.read<ApplicationCubit>().filterByStatus('rejected');
                     },
                   ),
                 ],
               ),
             ),

             // Applications list
             Expanded(
               child: BlocBuilder<ApplicationCubit, ApplicationState>(
                 builder: (context, state) {
                   if (state is ApplicationLoading) {
                     return Center(child: CircularProgressIndicator());
                   } else if (state is ApplicationsLoaded) {
                     if (state.applications.isEmpty) {
                       return Center(child: Text('No applications yet'));
                     }

                     return RefreshIndicator(
                       onRefresh: () async {
                         await context.read<ApplicationCubit>().refreshApplications();
                       },
                       child: ListView.builder(
                         itemCount: state.applications.length,
                         itemBuilder: (context, index) {
                           final app = state.applications[index];
                           return ListTile(
                             title: Text('Job ID: ${app.jobId}'),
                             subtitle: Text('Status: ${app.status}'),
                             trailing: Text(app.appliedAt.toString()),
                             onTap: () {
                               // Navigate to application details
                             },
                           );
                         },
                       ),
                     );
                   }
                   return SizedBox.shrink();
                 },
               ),
             ),
           ],
         ),
       );
     }
   }
   ```

#### Deliverables:

- [ ] Can submit applications
- [ ] Can view all applications
- [ ] Status filtering working
- [ ] Pull-to-refresh working

---

### Day 10: Testing Week 2 Features

**Time Estimate:** 3-4 hours

#### Complete Testing Checklist:

- [ ] Browse jobs on home screen
- [ ] View all jobs on jobs page
- [ ] Click on job to see details
- [ ] Search for specific jobs
- [ ] Filter jobs by category
- [ ] Sort jobs by salary/date
- [ ] Apply to a job
- [ ] View my applications
- [ ] Filter applications by status
- [ ] Refresh application list
- [ ] All loading states show correctly
- [ ] All error states handled
- [ ] No console errors

#### Deliverables:

- [ ] All job features working end-to-end
- [ ] No bugs found
- [ ] Performance is good

---

## 📅 WEEK 3: User Profiles & Saved Jobs (Days 11-15)

**Goal:** Profile management and bookmarking  
**Priority:** ⭐⭐⭐ MEDIUM-HIGH

### Day 11-12: Student Profile

**Time Estimate:** 6-7 hours total

#### Tasks:

1. **Update ProfileScreen (View Mode)**

   ```dart
   @override
   void initState() {
     super.initState();
     final userId = context.read<AuthCubit>().state.user.userId;
     context.read<StudentProfileCubit>().loadProfile(userId);
   }

   @override
   Widget build(BuildContext context) {
     return BlocBuilder<StudentProfileCubit, StudentProfileState>(
       builder: (context, state) {
         if (state is StudentProfileLoaded) {
           final profile = state.profile;
           return Column(
             children: [
               CircleAvatar(child: Text(profile.fullName[0])),
               Text(profile.fullName),
               Text(profile.email),
               Text(profile.university ?? 'No university'),
               Text('Skills: ${profile.skills?.join(", ") ?? "None"}'),

               ElevatedButton(
                 onPressed: () => context.push('/edit-profile'),
                 child: Text('Edit Profile'),
               ),
             ],
           );
         }
         return CircularProgressIndicator();
       },
     );
   }
   ```

2. **Update EditProfileScreen**
   - Create form with all fields
   - Pre-fill with current profile data
   - Call `updateProfile()` on save
   - Handle success/error states

#### Deliverables:

- [ ] Can view student profile
- [ ] Can edit profile
- [ ] Changes saved successfully
- [ ] Validation working

---

### Day 13: Employer Profile

**Time Estimate:** 4-5 hours

#### Tasks:

1. **Update EmployerProfileScreen**

   - Same pattern as StudentProfile
   - Use `EmployerProfileCubit`
   - Show company information

2. **Update EditCompanyProfileScreen**
   - Company details form
   - Update company info

#### Deliverables:

- [ ] Employer profile view working
- [ ] Company info editable
- [ ] Updates persist

---

### Day 14-15: Saved Jobs Feature

**Time Estimate:** 6-7 hours total

#### Tasks:

1. **Add Bookmark Button to Job Cards**

   ```dart
   BlocBuilder<SavedJobsCubit, SavedJobsState>(
     builder: (context, state) {
       final isSaved = state is SavedJobsLoaded &&
                       state.isJobSaved(job.jobId);

       return IconButton(
         icon: Icon(
           isSaved ? Icons.bookmark : Icons.bookmark_border,
           color: isSaved ? Colors.blue : Colors.grey,
         ),
         onPressed: () {
           context.read<SavedJobsCubit>().toggleSaveJob(job.jobId);
         },
       );
     },
   )
   ```

2. **Create SavedJobsScreen**

   ```dart
   @override
   void initState() {
     super.initState();
     context.read<SavedJobsCubit>().loadSavedJobs();
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: Text('Saved Jobs')),
       body: BlocBuilder<SavedJobsCubit, SavedJobsState>(
         builder: (context, state) {
           if (state is SavedJobsLoaded) {
             if (state.savedJobs.isEmpty) {
               return Center(child: Text('No saved jobs yet'));
             }

             return ListView.builder(
               itemCount: state.savedJobs.length,
               itemBuilder: (context, index) {
                 return JobCard(job: state.savedJobs[index]);
               },
             );
           }
           return CircularProgressIndicator();
         },
       ),
     );
   }
   ```

#### Deliverables:

- [ ] Can bookmark jobs
- [ ] Bookmark status shows everywhere
- [ ] Saved jobs screen shows all bookmarks
- [ ] Can unbookmark from saved list

---

## 📅 WEEK 4: Employer Features & Notifications (Days 16-20)

**Goal:** Complete employer dashboard and notification system  
**Priority:** ⭐⭐⭐ MEDIUM

### Day 16-17: Employer Job Management

**Time Estimate:** 6-8 hours total

#### Tasks:

1. **Update EmployerDashboardScreen**

   - Show job statistics
   - Use `EmployerJobCubit`

2. **Update CreateJobScreen**

   - Job creation form
   - Call `createJob()`

3. **Update EmployerJobsListScreen**

   - Show all employer's jobs
   - Filter by status

4. **Update EditJobScreen**
   - Edit job details
   - Delete job option

#### Deliverables:

- [ ] Can create new jobs
- [ ] Can edit existing jobs
- [ ] Can delete jobs
- [ ] Can filter by job status

---

### Day 18: Employer Application Management

**Time Estimate:** 4-5 hours

#### Tasks:

1. **Update EmployerApplicationsScreen**

   ```dart
   @override
   void initState() {
     super.initState();
     context.read<EmployerApplicationCubit>().loadJobApplications();
   }
   ```

2. **Add Accept/Reject/Shortlist Actions**
   ```dart
   Row(
     children: [
       IconButton(
         icon: Icon(Icons.check, color: Colors.green),
         onPressed: () {
           context.read<EmployerApplicationCubit>()
             .acceptApplication(application.applicationId);
         },
       ),
       IconButton(
         icon: Icon(Icons.close, color: Colors.red),
         onPressed: () {
           context.read<EmployerApplicationCubit>()
             .rejectApplication(application.applicationId);
         },
       ),
       IconButton(
         icon: Icon(Icons.star, color: Colors.orange),
         onPressed: () {
           context.read<EmployerApplicationCubit>()
             .shortlistApplication(application.applicationId);
         },
       ),
     ],
   )
   ```

#### Deliverables:

- [ ] View all applications for employer's jobs
- [ ] Accept/reject applications
- [ ] Shortlist candidates
- [ ] Filter by status

---

### Day 19-20: Notification System

**Time Estimate:** 6-7 hours total

#### Tasks:

1. **Update NotificationsScreen**

   ```dart
   @override
   void initState() {
     super.initState();
     context.read<NotificationCubit>().loadNotifications();
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text('Notifications'),
         actions: [
           TextButton(
             onPressed: () {
               context.read<NotificationCubit>().markAllAsRead();
             },
             child: Text('Mark all read'),
           ),
         ],
       ),
       body: BlocBuilder<NotificationCubit, NotificationState>(
         builder: (context, state) {
           if (state is NotificationsLoaded) {
             return ListView.builder(
               itemCount: state.notifications.length,
               itemBuilder: (context, index) {
                 final notif = state.notifications[index];
                 return ListTile(
                   leading: Icon(
                     notif.isRead
                       ? Icons.notifications_none
                       : Icons.notifications_active,
                   ),
                   title: Text(notif.title),
                   subtitle: Text(notif.message),
                   trailing: IconButton(
                     icon: Icon(Icons.delete),
                     onPressed: () {
                       context.read<NotificationCubit>()
                         .deleteNotification(notif.id);
                     },
                   ),
                   onTap: () {
                     if (!notif.isRead) {
                       context.read<NotificationCubit>()
                         .markAsRead(notif.id);
                     }
                   },
                 );
               },
             );
           }
           return CircularProgressIndicator();
         },
       ),
     );
   }
   ```

2. **Add Notification Badge to AppBar**

   ```dart
   BlocBuilder<NotificationCubit, NotificationState>(
     builder: (context, state) {
       int unreadCount = 0;
       if (state is NotificationsLoaded) {
         unreadCount = state.unreadCount;
       }

       return Stack(
         children: [
           IconButton(
             icon: Icon(Icons.notifications),
             onPressed: () => context.push('/notifications'),
           ),
           if (unreadCount > 0)
             Positioned(
               right: 8,
               top: 8,
               child: Container(
                 padding: EdgeInsets.all(4),
                 decoration: BoxDecoration(
                   color: Colors.red,
                   shape: BoxShape.circle,
                 ),
                 child: Text(
                   '$unreadCount',
                   style: TextStyle(color: Colors.white, fontSize: 10),
                 ),
               ),
             ),
         ],
       );
     },
   )
   ```

#### Deliverables:

- [ ] Notifications screen working
- [ ] Unread count badge in AppBar
- [ ] Mark as read working
- [ ] Mark all as read working
- [ ] Delete notifications working

---

## 📅 WEEK 5: Reviews, Education & Admin (Days 21-25)

**Goal:** Complete remaining features and polish  
**Priority:** ⭐⭐ MEDIUM-LOW

### Day 21-22: Review System

**Time Estimate:** 5-6 hours total

#### Tasks:

1. **Create SubmitReviewScreen**
2. **Update ReviewsListScreen**
3. **Show reviews on profiles**
4. **Show rating statistics**

#### Deliverables:

- [ ] Can submit reviews
- [ ] Reviews display on profiles
- [ ] Average rating shown
- [ ] Rating distribution shown

---

### Day 23: Education Section

**Time Estimate:** 3-4 hours

#### Tasks:

1. **Create EducationRepository** (if needed)
2. **Update education screens**
3. **Article browsing**

#### Deliverables:

- [ ] Education articles browsing
- [ ] Article search working

---

### Day 24: Admin Panel

**Time Estimate:** 4-5 hours

#### Tasks:

1. **Create AdminRepository** (if needed)
2. **Admin dashboard**
3. **User management**
4. **Job moderation**

#### Deliverables:

- [ ] Admin dashboard working
- [ ] Can manage users
- [ ] Can moderate jobs

---

### Day 25: Final Testing & Polish

**Time Estimate:** Full day

#### Complete App Testing:

- [ ] All authentication flows
- [ ] All job features
- [ ] All profile features
- [ ] All employer features
- [ ] All notification features
- [ ] All review features
- [ ] Navigation everywhere
- [ ] Error handling everywhere
- [ ] Loading states everywhere

#### Polish:

- [ ] Fix UI inconsistencies
- [ ] Improve loading indicators
- [ ] Better error messages
- [ ] Code cleanup
- [ ] Remove console logs
- [ ] Update documentation

---

## 🎯 Success Criteria

By the end of 5 weeks, you should have:

- ✅ Complete BLoC architecture implemented
- ✅ All 75+ screens updated to use Cubits
- ✅ No more Provider pattern or setState
- ✅ Proper state management everywhere
- ✅ Clean, maintainable codebase
- ✅ All features working end-to-end
- ✅ Ready for API integration

---

## 📝 Daily Workflow Template

**For each day:**

1. ☀️ **Morning:** Read task list, understand requirements
2. 🔨 **Work:** Implement tasks systematically
3. 🧪 **Afternoon:** Test what you built
4. 📝 **Evening:** Document issues, plan next day
5. ✅ **Before bed:** Mark completed tasks

---

## ⚠️ Important Reminders

- **Don't skip weeks** - Each builds on the previous
- **Test frequently** - Don't wait until the end
- **Ask for help** - If stuck > 30 minutes, reach out
- **Take breaks** - Avoid burnout
- **Celebrate progress** - Mark achievements!

---

**🚀 START WITH WEEK 1, DAY 1 NOW!**
