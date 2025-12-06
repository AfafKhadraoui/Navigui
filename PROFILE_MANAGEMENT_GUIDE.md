# Profile Management Implementation Guide

## Overview
This guide explains how to use the profile cubits (StudentProfileCubit and EmployerProfileCubit) to manage user profiles in the app.

## Architecture

```
┌─────────────────┐
│   UI (Screen)   │
│  BlocConsumer   │
└────────┬────────┘
         │
         │ calls methods
         ▼
┌─────────────────┐
│  Profile Cubit  │
│  (State Mgmt)   │
└────────┬────────┘
         │
         │ uses
         ▼
┌─────────────────┐
│ UserRepository  │
│  (Data Layer)   │
└────────┬────────┘
         │
         │ HTTP/Mock
         ▼
┌─────────────────┐
│  Backend API    │
│  or Mock Data   │
└─────────────────┘
```

## Cubits Implemented

### 1. StudentProfileCubit
Manages student profile state with these methods:

#### `loadProfile(String userId)`
Loads a student profile from the repository.
```dart
final cubit = context.read<StudentProfileCubit>();
await cubit.loadProfile('student-001');
```

**States:**
- `StudentProfileLoading` - While fetching
- `StudentProfileLoaded(profile)` - Success with StudentModel
- `StudentProfileError(message)` - Error with message

#### `updateProfile(...)`
Updates student profile fields.
```dart
await cubit.updateProfile(
  userId: 'student-001',
  bio: 'Updated bio',
  university: 'Lebanese International University',
  skills: ['Flutter', 'Dart', 'Firebase'],
  // ... other optional fields
);
```

**States:**
- `StudentProfileLoading` - While updating
- `StudentProfileUpdated(profile)` - Update succeeded
- `StudentProfileLoaded(profile)` - Shows updated profile
- `StudentProfileError(message)` - Error

#### `refreshProfile(String userId)`
Reloads the profile (same as loadProfile).

---

### 2. EmployerProfileCubit
Manages employer profile state with these methods:

#### `loadProfile(String userId)`
Loads an employer profile from the repository.
```dart
final cubit = context.read<EmployerProfileCubit>();
await cubit.loadProfile('employer-001');
```

**States:**
- `EmployerProfileLoading` - While fetching
- `EmployerProfileLoaded(profile)` - Success with EmployerModel
- `EmployerProfileError(message)` - Error with message

#### `updateProfile(...)`
Updates employer profile fields.
```dart
await cubit.updateProfile(
  userId: 'employer-001',
  businessName: 'Tech Solutions Inc.',
  industry: 'Information Technology',
  description: 'Leading software company',
  contactInfo: {
    'email': 'hr@techsolutions.com',
    'phone': '+961 1 234567',
  },
  // ... other optional fields
);
```

**States:**
- `EmployerProfileLoading` - While updating
- `EmployerProfileUpdated(profile)` - Update succeeded
- `EmployerProfileLoaded(profile)` - Shows updated profile
- `EmployerProfileError(message)` - Error

#### `refreshProfile(String userId)`
Reloads the profile (same as loadProfile).

---

## Repositories

### MockUserRepository
Currently active for testing without backend.

**Pre-seeded Test Data:**
- **Student ID:** `student-001`
  - Email: student@test.com
  - University: Lebanese International University
  - Skills: Flutter, Dart, Firebase, UI/UX
  
- **Employer ID:** `employer-001`
  - Email: employer@test.com
  - Business: Tech Solutions Inc.
  - Industry: Information Technology

### UserRepositoryImpl
Real API implementation (ready to swap when backend is available).

**API Endpoints:**
- `GET /students/:userId/profile` - Get student profile
- `PATCH /students/:userId/profile` - Update student profile
- `GET /employers/:userId/profile` - Get employer profile
- `PATCH /employers/:userId/profile` - Update employer profile
- `GET /users/:userId` - Get basic user info
- `PATCH /users/:userId` - Update basic user info
- `DELETE /users/:userId` - Soft delete user

---

## Usage Examples

### Example 1: Student Profile Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/cubits/student_profile/student_profile_cubit.dart';
import '../logic/cubits/student_profile/student_profile_state.dart';
import '../core/dependency_injection.dart';

class StudentProfileScreen extends StatelessWidget {
  final String userId;

  const StudentProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StudentProfileCubit>()..loadProfile(userId),
      child: Scaffold(
        appBar: AppBar(title: Text('Student Profile')),
        body: BlocConsumer<StudentProfileCubit, StudentProfileState>(
          listener: (context, state) {
            if (state is StudentProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is StudentProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is StudentProfileLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (state is StudentProfileLoaded) {
              final profile = state.profile;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('University: ${profile.university}'),
                    Text('Major: ${profile.major}'),
                    Text('Bio: ${profile.bio}'),
                    SizedBox(height: 16),
                    Text('Skills:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...profile.skills.map((skill) => Chip(label: Text(skill))),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _showEditDialog(context, profile),
                      child: Text('Edit Profile'),
                    ),
                  ],
                ),
              );
            }
            
            return Center(child: Text('No profile loaded'));
          },
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, StudentModel profile) {
    final bioController = TextEditingController(text: profile.bio);
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Edit Profile'),
        content: TextField(
          controller: bioController,
          decoration: InputDecoration(labelText: 'Bio'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<StudentProfileCubit>().updateProfile(
                userId: profile.userId,
                bio: bioController.text,
              );
              Navigator.pop(dialogContext);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
```

### Example 2: Employer Profile Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/cubits/employer_profile/employer_profile_cubit.dart';
import '../logic/cubits/employer_profile/employer_profile_state.dart';
import '../core/dependency_injection.dart';

class EmployerProfileScreen extends StatelessWidget {
  final String userId;

  const EmployerProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EmployerProfileCubit>()..loadProfile(userId),
      child: Scaffold(
        appBar: AppBar(title: Text('Employer Profile')),
        body: BlocConsumer<EmployerProfileCubit, EmployerProfileState>(
          listener: (context, state) {
            if (state is EmployerProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is EmployerProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is EmployerProfileLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (state is EmployerProfileLoaded) {
              final profile = state.profile;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (profile.logo != null)
                      Image.network(profile.logo!, height: 100),
                    SizedBox(height: 16),
                    Text(
                      profile.businessName,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text('Industry: ${profile.industry}'),
                    Text('Type: ${profile.businessType}'),
                    SizedBox(height: 8),
                    Text(profile.description ?? 'No description'),
                    SizedBox(height: 16),
                    if (profile.isVerified)
                      Chip(
                        label: Text('Verified'),
                        backgroundColor: Colors.green,
                      ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _showEditDialog(context, profile),
                      child: Text('Edit Profile'),
                    ),
                  ],
                ),
              );
            }
            
            return Center(child: Text('No profile loaded'));
          },
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, EmployerModel profile) {
    final descriptionController = TextEditingController(text: profile.description);
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Edit Profile'),
        content: TextField(
          controller: descriptionController,
          decoration: InputDecoration(labelText: 'Description'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<EmployerProfileCubit>().updateProfile(
                userId: profile.userId,
                description: descriptionController.text,
              );
              Navigator.pop(dialogContext);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
```

### Example 3: Using Profile Data Elsewhere

```dart
// In any widget that needs profile data
class JobApplicationWidget extends StatelessWidget {
  final String studentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StudentProfileCubit>()..loadProfile(studentId),
      child: BlocBuilder<StudentProfileCubit, StudentProfileState>(
        builder: (context, state) {
          if (state is StudentProfileLoaded) {
            final profile = state.profile;
            return Card(
              child: ListTile(
                title: Text('Skills: ${profile.skills.join(", ")}'),
                subtitle: Text('University: ${profile.university}'),
              ),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
```

---

## Switching to Real API

When your backend is ready:

1. Open `lib/core/dependency_injection.dart`
2. Comment out MockUserRepository:
```dart
// getIt.registerLazySingleton<UserRepository>(
//   () => MockUserRepository(),
// );
```

3. Uncomment UserRepositoryImpl:
```dart
getIt.registerLazySingleton<UserRepository>(
  () => UserRepositoryImpl(
    baseUrl: 'http://your-backend-url/api',
    getAuthToken: () {
      // Return current auth token
      // You may need to add getToken() method to AuthRepository
      final authRepo = getIt<AuthRepository>();
      return authRepo.getToken();
    },
  ),
);
```

4. Implement `getToken()` in AuthRepository if needed.

---

## Testing Checklist

- [x] UserRepository abstract interface created
- [x] UserRepositoryImpl (HTTP) created with all endpoints
- [x] MockUserRepository created with test data
- [x] StudentProfileCubit implemented (load, update, refresh)
- [x] EmployerProfileCubit implemented (load, update, refresh)
- [x] Repositories registered in dependency injection
- [x] Cubits registered in dependency injection
- [ ] Student profile screen created with BLoC
- [ ] Employer profile screen created with BLoC
- [ ] Test with mock repository (use test IDs: student-001, employer-001)
- [ ] Verify loading states show spinner
- [ ] Verify error states show error messages
- [ ] Verify update success shows success message
- [ ] Switch to real API when backend ready
- [ ] Test with real backend API

---

## Common Issues & Solutions

### Issue 1: "Profile not found"
**Solution:** Make sure you're using the correct user ID. For MockUserRepository, use:
- `student-001` for student profile
- `employer-001` for employer profile

### Issue 2: Cubit not updating UI
**Solution:** Ensure you're using BlocConsumer or BlocBuilder to listen to state changes.

### Issue 3: "No AuthRepository found"
**Solution:** Make sure you call `await setupDependencies()` in `main()` before `runApp()`.

### Issue 4: Profile doesn't persist
**Solution:** Currently using mock data which resets on app restart. When using real API with backend, data will persist.

### Issue 5: Can't access cubit
**Solution:** Either:
1. Wrap screen with BlocProvider to create new cubit instance, OR
2. Use existing cubit from parent widget with `context.read<ProfileCubit>()`

---

## Next Steps

1. ✅ Create student profile screen UI
2. ✅ Create employer profile screen UI
3. ⬜ Add profile editing forms with validation
4. ⬜ Implement image upload for profile pictures
5. ⬜ Add pull-to-refresh on profile screens
6. ⬜ Implement secure token storage
7. ⬜ Connect to real backend API
8. ⬜ Add profile completion progress indicator
9. ⬜ Add translations (AR, FR, EN)

---

## API Documentation Reference

See `lib/data/repositories/user/user_repo_abstract.dart` for complete method signatures and parameters.

For authentication, see `MOCK_REPOSITORY_GUIDE.md` and `BLOC_IMPLEMENTATION_GUIDE.md`.
