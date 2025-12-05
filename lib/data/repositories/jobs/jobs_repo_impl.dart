// // lib/data/repositories/implementations/job_repo_impl.dart

// import '../abstractions/job_repo_abstract.dart';
// import '../result_model.dart';
// import '../../models/job_model.dart';
// import '../../databases/tables/db_jobs_table.dart';

// class JobRepositoryImpl extends JobRepositoryBase {
//   final _jobsTable = DBJobsTable();

//   @override
//   Future<RepositoryResult<List<JobModel>>> getActiveJobs() async {
//     try {
//       final records = await _jobsTable.getActiveJobs();
//       final jobs = records
//           .map((record) => JobModel.fromMap(record))
//           .toList();
//       return RepositoryResult.success(jobs);
//     } catch (e) {
//       return RepositoryResult.failure('Failed to load active jobs: $e');
//     }
//   }

//   @override
//   Future<RepositoryResult<List<JobModel>>> getUrgentJobs() async {
//     try {
//       final records = await _jobsTable.getUrgentJobs();
//       final jobs = records
//           .map((record) => JobModel.fromMap(record))
//           .toList();
//       return RepositoryResult.success(jobs);
//     } catch (e) {
//       return RepositoryResult.failure('Failed to load urgent jobs: $e');
//     }
//   }

//   @override
//   Future<RepositoryResult<List<JobModel>>> getJobsByCategory(
//       String category) async {
//     try {
//       final records = await _jobsTable.getJobsByCategory(category);
//       final jobs = records
//           .map((record) => JobModel.fromMap(record))
//           .toList();
//       return RepositoryResult.success(jobs);
//     } catch (e) {
//       return RepositoryResult.failure(
//           'Failed to load jobs by category: $e');
//     }
//   }

//   @override
//   Future<RepositoryResult<List<JobModel>>> getJobsByLocation(
//       String location) async {
//     try {
//       final records = await _jobsTable.getJobsByLocation(location);
//       final jobs = records
//           .map((record) => JobModel.fromMap(record))
//           .toList();
//       return RepositoryResult.success(jobs);
//     } catch (e) {
//       return RepositoryResult.failure('Failed to load jobs by location: $e');
//     }
//   }

//   @override
//   Future<RepositoryResult<List<JobModel>>> getEmployerJobs(
//       String employerId) async {
//     try {
//       final records = await _jobsTable.getEmployerJobs(employerId);
//       final jobs = records
//           .map((record) => JobModel.fromMap(record))
//           .toList();
//       return RepositoryResult.success(jobs);
//     } catch (e) {
//       return RepositoryResult.failure('Failed to load employer jobs: $e');
//     }
//   }

//   @override
//   Future<RepositoryResult<JobModel>> getJobById(String jobId) async {
//     try {
//       final record = await _jobsTable.getRecordById(jobId);
//       if (record == null) {
//         return RepositoryResult.failure('Job not found');
//       }
//       // Increment view count
//       await _jobsTable.incrementViewCount(jobId);

//       return RepositoryResult.success(JobModel.fromMap(record));
//     } catch (e) {
//       return RepositoryResult.failure('Failed to load job: $e');
//     }
//   }

//   @override
//   Future<RepositoryResult<void>> createJob(JobModel job) async {
//     try {
//       await _jobsTable.insertRecord(job.toMap());
//       return RepositoryResult.success(null,
//           message: 'Job created successfully');
//     } catch (e) {
//       return RepositoryResult.failure('Failed to create job: $e');
//     }
//   }

//   @override
//   Future<RepositoryResult<void>> updateJob(JobModel job) async {
//     try {
//       await _jobsTable.updateRecord(job.id, job.toMap());
//       return RepositoryResult.success(null,
//           message: 'Job updated successfully');
//     } catch (e) {
//       return RepositoryResult.failure('Failed to update job: $e');
//     }
//   }

//   @override
//   Future<RepositoryResult<void>> deleteJob(String jobId) async {
//     try {
//       await _jobsTable.deleteRecord(jobId);
//       return RepositoryResult.success(null,
//           message: 'Job deleted successfully');
//     } catch (e) {
//       return RepositoryResult.failure('Failed to delete job: $e');
//     }
//   }

//   @override
//   Future<RepositoryResult<void>> saveJob(
//       String jobId, String studentId) async {
//     try {
//       // TODO: Implement saved jobs logic
//       return RepositoryResult.success(null,
//           message: 'Job saved successfully');
//     } catch (e) {
//       return RepositoryResult.failure('Failed to save job: $e');
//     }
//   }

//   @override
//   Future<RepositoryResult<List<JobModel>>> getSavedJobs(
//       String studentId) async {
//     try {
//       // TODO: Implement get saved jobs logic
//       return RepositoryResult.success([]);
//     } catch (e) {
//       return RepositoryResult.failure('Failed to load saved jobs: $e');
//     }
//   }
// }