# 📋 Signup Flow & Data Management

## 🔄 What Happens After Step 4?

### Student Signup Flow (5 Steps Total):
```
Step 1 → Step 2 → Step 3 → Step 4 → Step 5 → Success Dialog → Home
 (Auth)   (Info)  (Education) (Skills)  (Extra)
```

### Employer Signup Flow (4 Steps Total):
```
Step 1 → Step 2 → Step 3 → Step 4 → Success Dialog → Home
 (Auth)   (Info)  (Business) (Industry)
```

---

## 💾 Data Storage Strategy

Since you don't have a backend yet, we're using **SharedPreferences** for temporary storage during signup.

### How It Works:

1. **SignupDataService** - New service created to handle temporary data storage
   - Location: `lib/logic/services/signup_data_service.dart`
   - Uses `SharedPreferences` to store data locally
   - Clears data after successful signup

2. **Data Flow**:
```
Step 1: Collect email, password
  ↓ (save to SharedPreferences)
Step 2: Collect name, phone, location
  ↓ (save to SharedPreferences)
Step 3: Collect education/business info
  ↓ (save to SharedPreferences)
Step 4: Collect skills/industry
  ↓ (retrieve ALL data from SharedPreferences)
  ↓ (call AuthService.signup() with complete data)
  ↓ (clear temporary storage)
Success Dialog
  ↓
Home Screen
```

---

## 🎯 Current State vs. What Was Updated

### BEFORE (Problems):
- ❌ Each step had hardcoded data (`email: 'student@temp.com'`)
- ❌ Real user input was ignored
- ❌ No data persistence between steps
- ❌ Step 4 always created same test user

### AFTER (Fixed):
- ✅ Step 1: Saves email, password, accountType
- ✅ Step 4 Student: Saves skills, languages, retrieves ALL data, creates real account
- ✅ Step 4 Employer: Saves industry, address, retrieves ALL data, creates real account
- ✅ Data cleared after successful signup
- ✅ Success dialog shows actual username

---

## 📊 Data Storage Structure

### SignupDataService Methods:

```dart
// Save single value
await signupService.saveData('email', 'user@example.com');

// Save multiple values at once
await signupService.saveMultipleData({
  'email': 'user@example.com',
  'password': 'secure123',
  'name': 'John Doe',
});

// Get specific value
String? email = await signupService.getData('email');

// Get all stored data
Map<String, dynamic> allData = await signupService.getAllData();

// Get formatted student data
Map<String, dynamic> studentData = await signupService.getStudentSignupData();

// Get formatted employer data
Map<String, dynamic> employerData = await signupService.getEmployerSignupData();

// Clear everything after signup
await signupService.clearAllData();
```

### Student Data Keys:
- `email`, `password`, `name`, `phoneNumber`, `location`
- `university`, `faculty`, `major`, `yearOfStudy`
- `skills`, `languages`, `availability`, `portfolio`, `bio`

### Employer Data Keys:
- `email`, `password`, `name`, `phoneNumber`, `location`
- `businessName`, `businessType`, `industry`, `address`, `description`, `logo`

---

## 🔧 What Still Needs To Be Done

### To Complete the Signup Flow:

1. **Update Step 2 Student** - Collect name, phone, location
   ```dart
   await signupService.saveMultipleData({
     SignupDataService.keyName: _nameController.text.trim(),
     SignupDataService.keyPhoneNumber: _phoneController.text.trim(),
     SignupDataService.keyLocation: _locationController.text.trim(),
   });
   ```

2. **Update Step 3 Student** - Collect university, faculty, major, year
   ```dart
   await signupService.saveMultipleData({
     SignupDataService.keyUniversity: _universityController.text.trim(),
     SignupDataService.keyFaculty: _facultyController.text.trim(),
     SignupDataService.keyMajor: _majorController.text.trim(),
     SignupDataService.keyYearOfStudy: _yearController.text,
   });
   ```

3. **Update Step 5 Student** - Collect availability, portfolio, bio
   ```dart
   await signupService.saveMultipleData({
     SignupDataService.keyAvailability: _availabilityController.text.trim(),
     SignupDataService.keyPortfolio: [_portfolioController.text.trim()],
     SignupDataService.keyBio: _bioController.text.trim(),
   });
   ```

4. **Update Step 1 Employer** - Save email, password
   ```dart
   await signupService.saveMultipleData({
     SignupDataService.keyEmail: _emailController.text.trim(),
     SignupDataService.keyPassword: _passwordController.text,
     SignupDataService.keyAccountType: 'employer',
   });
   ```

5. **Update Step 2 Employer** - Save name, phone, location
   
6. **Update Step 3 Employer** - Save businessName, businessType, description, logo

---

## 🚀 When Backend is Ready

Once you have a backend API, you can:

1. **Replace AuthService** with real API calls
2. **Keep SignupDataService** for multi-step data collection
3. **Send all data at once** in Step 4/5 to your backend
4. **Receive JWT token** and store in SecureStorage (already implemented!)

### Backend Integration Example:
```dart
// In Step 4 (final step)
final signupData = await signupService.getStudentSignupData();

// Call real API
final response = await http.post(
  Uri.parse('https://your-api.com/signup'),
  body: json.encode(signupData),
  headers: {'Content-Type': 'application/json'},
);

if (response.statusCode == 201) {
  final userData = json.decode(response.body);
  final token = userData['token'];
  
  // Store token securely (already implemented!)
  await secureStorage.saveAuthToken(token);
  await secureStorage.saveUserId(userData['id']);
  await secureStorage.saveUserType('student');
  
  // Clear temporary signup data
  await signupService.clearAllData();
  
  // Show success dialog
  showDialog(...);
}
```

---

## 🎯 Key Benefits of This Approach

1. ✅ **No backend needed** for development/testing
2. ✅ **Real user data** collected and used
3. ✅ **Data persists** across app restarts during signup
4. ✅ **Easy to migrate** to backend later
5. ✅ **Clean separation** between temporary (signup) and permanent (user) storage
6. ✅ **Type-safe** with predefined keys
7. ✅ **Automatic cleanup** after successful signup

---

## 📝 Next Steps

1. ✅ Step1Student - DONE (saves email, password)
2. ⏳ Update Step2Student to save personal info
3. ⏳ Update Step3Student to save education info
4. ✅ Step4Student - DONE (saves skills, completes signup)
5. ⏳ Update Step5Student to save extra info
6. ⏳ Update Step1Employer to save email, password
7. ⏳ Update Step2Employer to save personal info
8. ⏳ Update Step3Employer to save business info
9. ✅ Step4Employer - DONE (saves industry, completes signup)

Want me to update the remaining steps (2, 3, 5) to complete the data collection flow?
