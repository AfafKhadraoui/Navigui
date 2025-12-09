import 'jobs_repo_abstract.dart';
import '../../models/result.dart';
import '../../models/job_post.dart';
import '../../databases/tables/jobs_table.dart';
import '../../databases/tables/saved_jobs_table.dart';
import '../../../logic/services/secure_storage_service.dart';

class JobRepositoryImpl extends JobRepositoryBase {
  final _jobsTable = DBJobsTable();
  final _savedJobsTable = SavedJobsTable();
  final _secureStorage = SecureStorageService();

  @override
  Future<RepositoryResult<List<JobPost>>> getActiveJobs() async {
    try {
      print('🔍 JobRepository: Fetching active jobs...');
      final records = await _jobsTable.getActiveJobs();
      print('📊 JobRepository: Found ${records.length} job records');
      final jobs = records
          .map((record) => JobPost.fromMap(record))
          .toList();
      print('✅ JobRepository: Successfully parsed ${jobs.length} jobs');
      return RepositoryResult.success(jobs);
    } catch (e, stackTrace) {
      print('❌ JobRepository Error: $e');
      print('Stack trace: $stackTrace');
      return RepositoryResult.failure('Failed to load active jobs: $e');
    }
  }

  @override
  Future<RepositoryResult<List<JobPost>>> getUrgentJobs() async {
    try {
      final records = await _jobsTable.getUrgentJobs();
      final jobs = records
          .map((record) => JobPost.fromMap(record))
          .toList();
      return RepositoryResult.success(jobs);
    } catch (e) {
      return RepositoryResult.failure('Failed to load urgent jobs: $e');
    }
  }

  @override
  Future<RepositoryResult<List<JobPost>>> getJobsByCategory(
      String category) async {
    try {
      final records = await _jobsTable.getJobsByCategory(category);
      final jobs = records
          .map((record) => JobPost.fromMap(record))
          .toList();
      return RepositoryResult.success(jobs);
    } catch (e) {
      return RepositoryResult.failure(
          'Failed to load jobs by category: $e');
    }
  }

  @override
  Future<RepositoryResult<List<JobPost>>> getJobsByLocation(
      String location) async {
    try {
      final records = await _jobsTable.getJobsByLocation(location);
      final jobs = records
          .map((record) => JobPost.fromMap(record))
          .toList();
      return RepositoryResult.success(jobs);
    } catch (e) {
      return RepositoryResult.failure('Failed to load jobs by location: $e');
    }
  }

  @override
  Future<RepositoryResult<List<JobPost>>> getEmployerJobs(
      String employerId) async {
    try {
      final records = await _jobsTable.getEmployerJobs(employerId);
      final jobs = records
          .map((record) => JobPost.fromMap(record))
          .toList();
      return RepositoryResult.success(jobs);
    } catch (e) {
      return RepositoryResult.failure('Failed to load employer jobs: $e');
    }
  }

  @override
  Future<RepositoryResult<JobPost>> getJobById(String jobId) async {
    try {
      final record = await _jobsTable.getRecordById(jobId);
      if (record == null) {
        return RepositoryResult.failure('Job not found');
      }
      // Increment view count
      await _jobsTable.incrementViewCount(jobId);

      return RepositoryResult.success(JobPost.fromMap(record));
    } catch (e) {
      return RepositoryResult.failure('Failed to load job: $e');
    }
  }

  @override
  Future<RepositoryResult<void>> createJob(JobPost job) async {
    try {
      await _jobsTable.insertRecord(job.toMap());
      return RepositoryResult.success(null,
          message: 'Job created successfully');
    } catch (e) {
      return RepositoryResult.failure('Failed to create job: $e');
    }
  }

  @override
  Future<RepositoryResult<void>> updateJob(JobPost job) async {
    try {
      await _jobsTable.updateRecord(job.id, job.toMap());
      return RepositoryResult.success(null,
          message: 'Job updated successfully');
    } catch (e) {
      return RepositoryResult.failure('Failed to update job: $e');
    }
  }

  @override
  Future<RepositoryResult<void>> deleteJob(String jobId) async {
    try {
      await _jobsTable.deleteRecord(jobId);
      return RepositoryResult.success(null,
          message: 'Job deleted successfully');
    } catch (e) {
      return RepositoryResult.failure('Failed to delete job: $e');
    }
  }

  @override
  Future<RepositoryResult<void>> saveJob(String jobId) async {
    try {
      final userId = await _secureStorage.getUserId();
      if (userId == null) {
        return RepositoryResult.failure('User not authenticated');
      }
      await _savedJobsTable.saveJob(userId, jobId);
      return RepositoryResult.success(null, message: 'Job saved successfully');
    } catch (e) {
      return RepositoryResult.failure('Failed to save job: $e');
    }
  }

  @override
  Future<RepositoryResult<void>> unsaveJob(String jobId) async {
    try {
      final userId = await _secureStorage.getUserId();
      if (userId == null) {
        return RepositoryResult.failure('User not authenticated');
      }
      await _savedJobsTable.unsaveJob(userId, jobId);
      return RepositoryResult.success(null, message: 'Job removed from saved');
    } catch (e) {
      return RepositoryResult.failure('Failed to unsave job: $e');
    }
  }

  @override
  Future<bool> isJobSaved(String jobId) async {
    try {
      final userId = await _secureStorage.getUserId();
      if (userId == null) return false;
      return await _savedJobsTable.isJobSaved(userId, jobId);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<RepositoryResult<List<JobPost>>> getSavedJobs(
      String studentId) async {
    try {
      final records = await _savedJobsTable.getSavedJobs(studentId);
      final jobs = records
          .map((record) => JobPost.fromMap(record))
          .toList();
      return RepositoryResult.success(jobs);
    } catch (e) {
      return RepositoryResult.failure('Failed to load saved jobs: $e');
    }
  }
}