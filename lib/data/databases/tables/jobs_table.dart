// // lib/data/databases/tables/db_jobs_table.dart

// import '../db_base_table.dart';
// // import 'package:sqflite/sqflite.dart';

// class DBJobsTable extends DBBaseTable {
//   @override
//   String get tableName => 'jobs';

//   Future<List<Map<String, dynamic>>> getActiveJobs() async {
//     try {
//       final db = await getDatabase();
//       return await db.query(
//         tableName,
//         where: 'status = ? AND is_draft = ?',
//         whereArgs: ['active', 0],
//         orderBy: 'created_at DESC',
//       );
//     } catch (e, stackTrace) {
//       // print('Error fetching active jobs: $e\n$stackTrace');
//       return [];
//     }
//   }

//   Future<List<Map<String, dynamic>>> getUrgentJobs() async {
//     try {
//       final db = await getDatabase();
//       return await db.query(
//         tableName,
//         where: 'is_urgent = ? AND status = ?',
//         whereArgs: [1, 'active'],
//         orderBy: 'deadline ASC',
//         limit: 3,
//       );
//     } catch (e, stackTrace) {
//       // print('Error fetching urgent jobs: $e\n$stackTrace');
//       return [];
//     }
//   }

//   Future<List<Map<String, dynamic>>> getJobsByCategory(String category) async {
//     try {
//       final db = await getDatabase();
//       return await db.query(
//         tableName,
//         where: 'category = ? AND status = ?',
//         whereArgs: [category, 'active'],
//         orderBy: 'created_at DESC',
//       );
//     } catch (e, stackTrace) {
//       // print('Error fetching jobs by category: $e\n$stackTrace');
//       return [];
//     }
//   }

//   Future<List<Map<String, dynamic>>> getJobsByLocation(String location) async {
//     try {
//       final db = await getDatabase();
//       return await db.query(
//         tableName,
//         where: 'location = ? AND status = ?',
//         whereArgs: [location, 'active'],
//         orderBy: 'created_at DESC',
//       );
//     } catch (e, stackTrace) {
//       // print('Error fetching jobs by location: $e\n$stackTrace');
//       return [];
//     }
//   }

//   Future<List<Map<String, dynamic>>> getEmployerJobs(String employerId) async {
//     try {
//       final db = await getDatabase();
//       return await db.query(
//         tableName,
//         where: 'employer_id = ?',
//         whereArgs: [employerId],
//         orderBy: 'created_at DESC',
//       );
//     } catch (e, stackTrace) {
//       // print('Error fetching employer jobs: $e\n$stackTrace');
//       return [];
//     }
//   }

//   Future<bool> incrementViewCount(String jobId) async {
//     try {
//       final db = await getDatabase();
//       await db.rawUpdate(
//         'UPDATE $tableName SET views_count = views_count + 1 WHERE id = ?',
//         [jobId],
//       );
//       return true;
//     } catch (e, stackTrace) {
//       // print('Error incrementing view count: $e\n$stackTrace');
//       return false;
//     }
//   }
// }