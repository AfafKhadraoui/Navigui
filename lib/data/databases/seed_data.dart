// lib/data/databases/seed_data.dart
import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseSeeder {
  /// Hash password using SHA256 (matches DatabaseAuthRepository)
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  static Future<void> seedDatabase(Database db) async {
    print('🌱 Starting database seeding...');
    
    // Check if users already seeded
    final userCount = await db.rawQuery('SELECT COUNT(*) FROM users');
    if ((userCount.first.values.first as int) > 0) {
      print('ℹ️ Users already exist, skipping user seeding');
      // Still seed jobs
      await _seedJobs(db);
      return;
    }
    
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
    
    print('✅ Database seeded with 5 test users');
    print('📋 Available accounts:');
    print('   - admin@navigui.com / admin123');
    print('   - employer@navigui.com / employer123');
    print('   - student@navigui.com / student123');

    // Seed jobs (separate check)
    await _seedJobs(db);
  }

  static Future<void> _seedJobs(Database db) async {
    print('💼 Seeding database with sample jobs...');
    
    final now = DateTime.now();
    
    // Sample jobs data
    final jobs = [
      {
        'id': 'job-001',
        'employer_id': 'employer-001',
        'title': 'Graphic Design Task',
        'description': 'Design promotional materials for upcoming event. Quick turnaround needed. We need creative posters, graphics, and digital banners.',
        'brief_description': 'Design promotional materials for upcoming event',
        'category': 'graphic_design', // Changed from 'Design' to match schema
        'job_type': 'task',
        'requirements': 'Experience with Adobe Photoshop, Illustrator, and Figma',
        'pay': 8000.0,
        'payment_type': 'per_task',
        'time_commitment': '10 hours per week',
        'duration': '1 week',
        'start_date': now.add(Duration(days: 3)).toIso8601String(),
        'location': 'Oran, Algeria',
        'contact_preference': 'email',
        'is_recurring': 0,
        'is_urgent': 1,
        'requires_cv': 0,
        'is_draft': 0,
        'number_of_positions': 1,
        'applicants_count': 0,
        'views_count': 0,
        'saves_count': 0,
        'status': 'active',
        'deadline': now.add(Duration(days: 2)).toIso8601String(),
        'created_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      },
      {
        'id': 'job-002',
        'employer_id': 'employer-001',
        'title': 'Content Writer',
        'description': 'We are looking for a talented Content Writer experienced in crafting compelling content for blogs, articles, and web pages.',
        'brief_description': 'Write engaging blog posts and articles',
        'category': 'writing', // Lowercase to match schema
        'job_type': 'task',
        'requirements': 'Strong writing skills, SEO knowledge, research abilities',
        'pay': 5000.0,
        'payment_type': 'per_task',
        'time_commitment': '15 hours per week',
        'duration': '2 weeks',
        'start_date': now.add(Duration(days: 5)).toIso8601String(),
        'location': 'Algiers, Algeria',
        'contact_preference': 'email',
        'is_recurring': 0,
        'is_urgent': 1,
        'requires_cv': 0,
        'is_draft': 0,
        'number_of_positions': 2,
        'applicants_count': 0,
        'views_count': 0,
        'saves_count': 0,
        'status': 'active',
        'deadline': now.add(Duration(days: 3)).toIso8601String(),
        'created_at': now.subtract(Duration(days: 1)).toIso8601String(),
        'updated_at': now.subtract(Duration(days: 1)).toIso8601String(),
      },
      {
        'id': 'job-003',
        'employer_id': 'employer-001', // Changed from employer-002 to match existing employer
        'title': 'Social Media Manager',
        'description': 'Manage social media accounts, create engaging content, and grow our online presence across multiple platforms.',
        'brief_description': 'Manage social media and create content',
        'category': 'marketing', // Lowercase to match schema
        'job_type': 'part_time',
        'requirements': 'Social media marketing experience, content creation, analytics',
        'pay': 40000.0,
        'payment_type': 'monthly',
        'time_commitment': '20 hours per week',
        'duration': '6 months',
        'start_date': now.add(Duration(days: 14)).toIso8601String(),
        'location': 'Algiers, Algeria',
        'contact_preference': 'phone',
        'is_recurring': 0,
        'is_urgent': 0,
        'requires_cv': 1,
        'is_draft': 0,
        'number_of_positions': 1,
        'applicants_count': 0,
        'views_count': 0,
        'saves_count': 0,
        'status': 'active',
        'deadline': now.add(Duration(days: 14)).toIso8601String(),
        'created_at': now.subtract(Duration(days: 5)).toIso8601String(),
        'updated_at': now.subtract(Duration(days: 5)).toIso8601String(),
      },
      {
        'id': 'job-004',
        'employer_id': 'employer-001',
        'title': 'Flutter Developer',
        'description': 'Develop and maintain mobile applications using Flutter. Work with our team to build high-quality apps.',
        'brief_description': 'Build mobile apps with Flutter',
        'category': 'mobile_development',
        'job_type': 'part_time',
        'requirements': 'Flutter, Dart, State Management (Bloc/Provider), Git',
        'pay': 60000.0,
        'payment_type': 'monthly',
        'time_commitment': '25 hours per week',
        'duration': 'Ongoing',
        'start_date': now.add(Duration(days: 7)).toIso8601String(),
        'location': 'Remote',
        'contact_preference': 'email',
        'is_recurring': 0,
        'is_urgent': 1,
        'requires_cv': 1,
        'is_draft': 0,
        'number_of_positions': 2,
        'applicants_count': 0,
        'views_count': 0,
        'saves_count': 0,
        'status': 'active',
        'deadline': now.add(Duration(days: 30)).toIso8601String(),
        'created_at': now.toIso8601String(), // Latest
        'updated_at': now.toIso8601String(),
      },
    ];

    for (final job in jobs) {
      try {
        await db.insert('jobs', job);
        print('  ✓ Inserted job: ${job['title']}');
      } catch (e) {
        print('  ✗ Failed to insert job ${job['title']}: $e');
      }
    }

    print('✅ Database seeded with ${jobs.length} sample jobs');
  }
}
