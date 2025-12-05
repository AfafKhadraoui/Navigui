// lib/data/databases/db_base_table.dart

import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';

/// Base class for all database table operations
/// Provides common CRUD operations that can be reused across tables
abstract class DBBaseTable {
  /// Must be implemented by child classes to specify table name
  String get tableName;

  /// Get database instance
  Future<Database> getDatabase() => DBHelper.getDatabase();

  /// Insert a new record into the table
  /// Returns true if successful, false otherwise
  Future<bool> insertRecord(Map<String, dynamic> data) async {
    try {
      final db = await getDatabase();
      await db.insert(
        tableName,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e, stackTrace) {
      print('Insert Error in $tableName: $e\n$stackTrace');
      return false;
    }
  }

  /// Insert multiple records in a batch transaction
  /// More efficient than calling insertRecord multiple times
  Future<bool> insertBatch(List<Map<String, dynamic>> dataList) async {
    try {
      final db = await getDatabase();
      final batch = db.batch();

      for (var data in dataList) {
        batch.insert(
          tableName,
          data,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      return true;
    } catch (e, stackTrace) {
      print('Batch Insert Error in $tableName: $e\n$stackTrace');
      return false;
    }
  }

  /// Get all records from the table
  Future<List<Map<String, dynamic>>> getAllRecords() async {
    try {
      final db = await getDatabase();
      return await db.query(tableName);
    } catch (e, stackTrace) {
      print('Query Error in $tableName: $e\n$stackTrace');
      return [];
    }
  }

  /// Get a single record by ID
  Future<Map<String, dynamic>?> getRecordById(String id) async {
    try {
      final db = await getDatabase();
      final results = await db.query(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      return results.isNotEmpty ? results.first : null;
    } catch (e, stackTrace) {
      print('Query Error in $tableName: $e\n$stackTrace');
      return null;
    }
  }

  /// Get records with custom where clause
  /// Example: getRecordsWhere('status = ? AND user_id = ?', ['active', '123'])
  Future<List<Map<String, dynamic>>> getRecordsWhere(
    String where,
    List<dynamic> whereArgs, {
    String? orderBy,
    int? limit,
  }) async {
    try {
      final db = await getDatabase();
      return await db.query(
        tableName,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
      );
    } catch (e, stackTrace) {
      print('Query Error in $tableName: $e\n$stackTrace');
      return [];
    }
  }

  /// Update a record by ID
  Future<bool> updateRecord(String id, Map<String, dynamic> data) async {
    try {
      final db = await getDatabase();
      final rowsAffected = await db.update(
        tableName,
        data,
        where: 'id = ?',
        whereArgs: [id],
      );
      return rowsAffected > 0;
    } catch (e, stackTrace) {
      print('Update Error in $tableName: $e\n$stackTrace');
      return false;
    }
  }

  /// Update records with custom where clause
  Future<bool> updateWhere(
    Map<String, dynamic> data,
    String where,
    List<dynamic> whereArgs,
  ) async {
    try {
      final db = await getDatabase();
      final rowsAffected = await db.update(
        tableName,
        data,
        where: where,
        whereArgs: whereArgs,
      );
      return rowsAffected > 0;
    } catch (e, stackTrace) {
      print('Update Error in $tableName: $e\n$stackTrace');
      return false;
    }
  }

  /// Delete a record by ID
  Future<bool> deleteRecord(String id) async {
    try {
      final db = await getDatabase();
      final rowsAffected = await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      return rowsAffected > 0;
    } catch (e, stackTrace) {
      print('Delete Error in $tableName: $e\n$stackTrace');
      return false;
    }
  }

  /// Delete records with custom where clause
  Future<bool> deleteWhere(String where, List<dynamic> whereArgs) async {
    try {
      final db = await getDatabase();
      final rowsAffected = await db.delete(
        tableName,
        where: where,
        whereArgs: whereArgs,
      );
      return rowsAffected > 0;
    } catch (e, stackTrace) {
      print('Delete Error in $tableName: $e\n$stackTrace');
      return false;
    }
  }

  /// Delete all records from the table
  Future<bool> deleteAll() async {
    try {
      final db = await getDatabase();
      await db.delete(tableName);
      return true;
    } catch (e, stackTrace) {
      print(' Delete All Error in $tableName: $e\n$stackTrace');
      return false;
    }
  }

  /// Count records in the table
  Future<int> count() async {
    try {
      final db = await getDatabase();
      final result =
          await db.rawQuery('SELECT COUNT(*) as count FROM $tableName');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e, stackTrace) {
      print('Count Error in $tableName: $e\n$stackTrace');
      return 0;
    }
  }

  /// Count records with custom where clause
  Future<int> countWhere(String where, List<dynamic> whereArgs) async {
    try {
      final db = await getDatabase();
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $tableName WHERE $where',
        whereArgs,
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e, stackTrace) {
      print('Count Error in $tableName: $e\n$stackTrace');
      return 0;
    }
  }

  /// Check if a record exists by ID
  Future<bool> exists(String id) async {
    try {
      final db = await getDatabase();
      final result = await db.query(
        tableName,
        columns: ['id'],
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (e, stackTrace) {
      print('Exists Error in $tableName: $e\n$stackTrace');
      return false;
    }
  }
}
