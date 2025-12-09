// lib/data/repositories/saved_jobs/saved_jobs_repo_impl.dart

import '../../databases/tables/saved_jobs_table.dart';
import '../../models/job_model.dart';
import '../../models/result.dart';
import 'saved_jobs_repo_abstract.dart';

/// Implementation of Saved Jobs Repository
class SavedJobsRepositoryImpl extends SavedJobsRepositoryBase {
  final SavedJobsTable _savedJobsTable = SavedJobsTable();

  @override
  Future<RepositoryResult<List<JobModel>>> getSavedJobs(String studentId) async {
    try {
      final records = await _savedJobsTable.getSavedJobsWithDetails(studentId);
      final jobs = records.map((record) => _mapToJobModel(record)).toList();
      return RepositoryResult.success(jobs);
    } catch (e) {
      return RepositoryResult.failure('Failed to load saved jobs: $e');
    }
  }

  @override
  Future<RepositoryResult<void>> saveJob(String studentId, String jobId) async {
    try {
      final success = await _savedJobsTable.saveJob(studentId, jobId);
      if (success) {
        return RepositoryResult.success(null, message: 'Job saved successfully');
      } else {
        return RepositoryResult.failure('Failed to save job');
      }
    } catch (e) {
      return RepositoryResult.failure('Failed to save job: $e');
    }
  }

  @override
  Future<RepositoryResult<void>> removeSavedJob(String studentId, String jobId) async {
    try {
      final success = await _savedJobsTable.removeSavedJob(studentId, jobId);
      if (success) {
        return RepositoryResult.success(null, message: 'Job removed successfully');
      } else {
        return RepositoryResult.failure('Failed to remove saved job');
      }
    } catch (e) {
      return RepositoryResult.failure('Failed to remove saved job: $e');
    }
  }

  @override
  Future<RepositoryResult<bool>> isJobSaved(String studentId, String jobId) async {
    try {
      final isSaved = await _savedJobsTable.isJobSaved(studentId, jobId);
      return RepositoryResult.success(isSaved);
    } catch (e) {
      return RepositoryResult.failure('Failed to check if job is saved: $e');
    }
  }

  /// Map database record to JobModel
  JobModel _mapToJobModel(Map<String, dynamic> record) {
    return JobModel(
      id: record['job_id'] as String? ?? record['id'] as String,
      employerId: record['employer_id'] as String,
      title: record['title'] as String,
      description: record['description'] as String,
      briefDescription: record['brief_description'] as String?,
      category: record['category'] as String,
      jobType: record['job_type'] as String,
      requirements: record['requirements'] as String?,
      pay: (record['pay'] as num).toDouble(),
      paymentType: record['payment_type'] as String? ?? 'per_task',
      timeCommitment: record['time_commitment'] as String?,
      duration: record['duration'] as String?,
      startDate: record['start_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(record['start_date'] as int)
          : null,
      isRecurring: (record['is_recurring'] as int? ?? 0) == 1,
      numberOfPositions: record['number_of_positions'] as int? ?? 1,
      location: record['location'] as String?,
      photos: null,
      tags: null,
      contactPreference: record['contact_preference'] as String?,
      deadline: record['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(record['deadline'] as int)
          : null,
      isUrgent: (record['is_urgent'] as int? ?? 0) == 1,
      requiresCV: (record['requires_cv'] as int? ?? 0) == 1,
      isDraft: (record['is_draft'] as int? ?? 0) == 1,
      languagesRequired: null,
      status: record['status'] as String? ?? 'active',
      createdAt: DateTime.fromMillisecondsSinceEpoch(record['created_at'] as int),
      updatedAt: record['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(record['updated_at'] as int)
          : null,
      applicantsCount: record['applicants_count'] as int? ?? 0,
    );
  }
}

