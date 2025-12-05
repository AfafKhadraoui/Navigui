// // lib/data/databases/seed_data.dart
// import 'db_helper.dart';

// class DatabaseSeeder {
//   static Future<void> seedDatabase() async {
//     final db = await DBHelper.getDatabase();
    
//     // Check if already seeded
//     final userCount = await db.rawQuery('SELECT COUNT(*) FROM users');
//     if (userCount.first.values.first > 0) return; // Already seeded
    
//     // Insert mock users
//     await db.insert('users', {
//       'id': '1',
//       'email': 'student@test.com',
//       'password_hash': 'hashed_password',
//       'account_type': 'student',
//       'name': 'Test Student',
//       'created_at': DateTime.now().toIso8601String(),
//     });
    
//     await db.insert('users', {
//       'id': '2',
//       'email': 'employer@test.com',
//       'password_hash': 'hashed_password',
//       'account_type': 'employer',
//       'name': 'Test Employer',
//       'created_at': DateTime.now().toIso8601String(),
//     });
    
//     // Insert mock jobs
//     await db.insert('jobs', {
//       'id': '1',
//       'employer_id': '2',
//       'title': 'Photography Assistant',
//       'description': 'Help with photoshoot',
//       'category': 'photography',
//       'pay': 2000,
//       'location': 'Algiers',
//       'status': 'active',
//       'created_at': DateTime.now().toIso8601String(),
//     });
    
//     // ... add more mock data
//     print('✅ Database seeded with mock data');
//   }
// }