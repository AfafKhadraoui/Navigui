import '../../models/result.dart';
import '../../models/job_post.dart';

abstract class JobRepositoryBase {
  Future<RepositoryResult<List<JobPost>>> getActiveJobs();
  Future<RepositoryResult<List<JobPost>>> getUrgentJobs();
  Future<RepositoryResult<List<JobPost>>> getJobsByCategory(String category);
  Future<RepositoryResult<List<JobPost>>> getJobsByLocation(String location);
  Future<RepositoryResult<List<JobPost>>> getEmployerJobs(String employerId);
  Future<RepositoryResult<JobPost>> getJobById(String jobId);
  Future<RepositoryResult<void>> createJob(JobPost job);
  Future<RepositoryResult<void>> updateJob(JobPost job);
  Future<RepositoryResult<void>> deleteJob(String jobId);
  Future<RepositoryResult<List<JobPost>>> getSavedJobs(String studentId);
  Future<bool> isJobSaved(String jobId);
  Future<RepositoryResult<void>> saveJob(String jobId);
  Future<RepositoryResult<void>> unsaveJob(String jobId);
}