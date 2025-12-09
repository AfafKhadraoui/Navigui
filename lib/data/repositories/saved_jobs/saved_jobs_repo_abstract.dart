// lib/data/repositories/saved_jobs/saved_jobs_repo_abstract.dart

import '../../models/result.dart';
import '../../models/job_model.dart';

/// Abstract base class for Saved Jobs Repository
abstract class SavedJobsRepositoryBase {
  /// Get all saved jobs for a student (returns JobModel list)
  Future<RepositoryResult<List<JobModel>>> getSavedJobs(String studentId);

  /// Save a job for a student
  Future<RepositoryResult<void>> saveJob(String studentId, String jobId);

  /// Remove a saved job
  Future<RepositoryResult<void>> removeSavedJob(String studentId, String jobId);

  /// Check if a job is saved by a student
  Future<RepositoryResult<bool>> isJobSaved(String studentId, String jobId);
}

