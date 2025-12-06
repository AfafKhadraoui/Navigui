// lib/data/databases/tables/users_table.dart

import 'package:sqflite/sqflite.dart';
import '../db_helper.dart';

class UsersTable {
  static const String _tableName = 'users';

  /// Get user by email
  static Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await DBHelper.getDatabase();
    final results = await db.query(
      _tableName,
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Validate user credentials (simple password check - NOT SECURE for production)
  static Future<Map<String, dynamic>?> validateUser(
      String email, String password) async {
    final user = await getUserByEmail(email);
    if (user != null && user['password_hash'] == password) {
      return user;
    }
    return null;
  }

  /// Get user by ID
  static Future<Map<String, dynamic>?> getUserById(String userId) async {
    final db = await DBHelper.getDatabase();
    final results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Update last login timestamp
  static Future<void> updateLastLogin(String userId) async {
    final db = await DBHelper.getDatabase();
    await db.update(
      _tableName,
      {
        'last_login_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
