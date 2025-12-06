// lib/data/databases/seed_data.dart
import 'db_helper.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseSeeder {
  /// Hash password using SHA256 (matches DatabaseAuthRepository)
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  static Future<void> seedDatabase() async {
    final db = await DBHelper.getDatabase();
    
    // Check if already seeded
    final userCount = await db.rawQuery('SELECT COUNT(*) FROM users');
    if ((userCount.first.values.first as int) > 0) return; // Already seeded
    
    print(' Seeding database with test users...');
    
    // Insert default test accounts with hashed passwords
    await db.insert('users', {
      'id': 'admin-001',
      'email': 'admin@navigui.com',
      'password_hash': _hashPassword('admin123'),
      'account_type': 'admin',
      'name': 'Admin User',
      'phone_number': '+213555000001',
      'location': 'Alger',
      'is_email_verified': 1,
      'is_active': 1,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
    
    await db.insert('users', {
      'id': 'employer-001',
      'email': 'employer@navigui.com',
      'password_hash': _hashPassword('employer123'),
      'account_type': 'employer',
      'name': 'Employer User',
      'phone_number': '+213555000002',
      'location': 'Oran',
      'is_email_verified': 1,
      'is_active': 1,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
    
    await db.insert('users', {
      'id': 'student-001',
      'email': 'student@navigui.com',
      'password_hash': _hashPassword('student123'),
      'account_type': 'student',
      'name': 'Student User',
      'phone_number': '+213555000003',
      'location': 'Alger',
      'is_email_verified': 1,
      'is_active': 1,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
    
    // Legacy test users
    await db.insert('users', {
      'id': 'student-002',
      'email': 'student@test.com',
      'password_hash': _hashPassword('password123'),
      'account_type': 'student',
      'name': 'Test Student',
      'phone_number': '+213555123456',
      'location': 'Alger',
      'is_email_verified': 1,
      'is_active': 1,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
    
    await db.insert('users', {
      'id': 'employer-002',
      'email': 'employer@test.com',
      'password_hash': _hashPassword('password123'),
      'account_type': 'employer',
      'name': 'Test Employer',
      'phone_number': '+213555654321',
      'location': 'Oran',
      'is_email_verified': 1,
      'is_active': 1,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });
    
    print(' Database seeded with 5 test users');
    print(' Available accounts:');
    print('   - admin@navigui.com / admin123');
    print('   - employer@navigui.com / employer123');
    print('   - student@navigui.com / student123');
  }
}
