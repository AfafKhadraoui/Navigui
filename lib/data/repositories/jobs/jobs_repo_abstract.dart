
// import '../result_model.dart';
// import '../../models/job_model.dart';

// abstract class JobRepositoryBase {
//   Future<RepositoryResult<List<JobModel>>> getActiveJobs();
//   Future<RepositoryResult<List<JobModel>>> getUrgentJobs();
//   Future<RepositoryResult<List<JobModel>>> getJobsByCategory(String category);
//   Future<RepositoryResult<List<JobModel>>> getJobsByLocation(String location);
//   Future<RepositoryResult<List<JobModel>>> getEmployerJobs(String employerId);
//   Future<RepositoryResult<JobModel>> getJobById(String jobId);
//   Future<RepositoryResult<void>> createJob(JobModel job);
//   Future<RepositoryResult<void>> updateJob(JobModel job);
//   Future<RepositoryResult<void>> deleteJob(String jobId);
//   Future<RepositoryResult<void>> saveJob(String jobId, String studentId);
//   Future<RepositoryResult<List<JobModel>>> getSavedJobs(String studentId);

//   static JobRepositoryBase? _instance;

//   static JobRepositoryBase getInstance() {
//     _instance ??= JobRepositoryImpl();
//     return _instance!;
//   }
// }