// import 'package:sqflite/sqflite.dart';
// import 'db_helper.dart';

// abstract class DBBaseTable {
//   String get tableName;

//   Future<Database> getDatabase() => DBHelper.getDatabase();

//   Future<bool> insertRecord(Map<String, dynamic> data) async {
//     try {
//       final db = await getDatabase();
//       await db.insert(
//         tableName,
//         data,
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//       return true;
//     } catch (e, stackTrace) {
//       print('Insert Error in $tableName: $e\n$stackTrace');
//       return false;
//     }
//   }

//   Future<List<Map<String, dynamic>>> getAllRecords() async {
//     try {
//       final db = await getDatabase();
//       return await db.query(tableName);
//     } catch (e, stackTrace) {
//       print('Query Error in $tableName: $e\n$stackTrace');
//       return [];
//     }
//   }

//   Future<Map<String, dynamic>?> getRecordById(String id) async {
//     try {
//       final db = await getDatabase();
//       final results = await db.query(
//         tableName,
//         where: 'id = ?',
//         whereArgs: [id],
//       );
//       return results.isNotEmpty ? results.first : null;
//     } catch (e, stackTrace) {
//       print('Query Error in $tableName: $e\n$stackTrace');
//       return null;
//     }
//   }

//   Future<bool> updateRecord(String id, Map<String, dynamic> data) async {
//     try {
//       final db = await getDatabase();
//       await db.update(
//         tableName,
//         data,
//         where: 'id = ?',
//         whereArgs: [id],
//       );
//       return true;
//     } catch (e, stackTrace) {
//       print('Update Error in $tableName: $e\n$stackTrace');
//       return false;
//     }
//   }

//   Future<bool> deleteRecord(String id) async {
//     try {
//       final db = await getDatabase();
//       await db.delete(
//         tableName,
//         where: 'id = ?',
//         whereArgs: [id],
//       );
//       return true;
//     } catch (e, stackTrace) {
//       print('Delete Error in $tableName: $e\n$stackTrace');
//       return false;
//     }
//   }
// }
