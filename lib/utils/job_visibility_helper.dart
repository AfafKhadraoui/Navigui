import 'package:flutter/material.dart';
import '../data/models/job_post.dart';

/// Helper class for determining job post visibility based on student status and job properties
class JobVisibilityHelper {
  /// Determines if a job post is visible to students
  /// 
  /// Visibility Rules:
  /// 1. Draft posts are NEVER visible to students (isDraft == true)
  /// 2. Active posts are ALWAYS visible to students
  /// 3. Closed posts are visible ONLY if the student:
  ///    - Has already applied to that job, OR
  ///    - Has already saved that job
  /// 
  /// Parameters:
  /// - [jobPost]: The job posting to check visibility for
  /// - [hasApplied]: Whether the student has applied to this job
  /// - [hasSaved]: Whether the student has saved this job
  /// 
  /// Returns: true if the job should be visible to the student, false otherwise
  static bool isVisibleToStudent({
    required JobPost jobPost,
    bool hasApplied = false,
    bool hasSaved = false,
  }) {
    // Rule 1: Draft posts are never visible
    if (jobPost.isDraft) {
      return false;
    }

    // Rule 2: Active posts are always visible
    if (jobPost.status == JobStatus.active) {
      return true;
    }

    // Rule 3: Closed posts are visible only if student has applied or saved
    if (jobPost.status == JobStatus.closed) {
      return hasApplied || hasSaved;
    }

    // Default: not visible
    return false;
  }

  /// Returns a user-friendly visibility status message
  static String getVisibilityStatus({
    required JobPost jobPost,
    bool hasApplied = false,
    bool hasSaved = false,
  }) {
    if (jobPost.isDraft) {
      return 'Draft - Not visible to students';
    }

    if (jobPost.status == JobStatus.active) {
      return 'Active - Visible to students';
    }

    if (jobPost.status == JobStatus.closed) {
      if (hasApplied || hasSaved) {
        return 'Closed - Visible because you applied or saved';
      } else {
        return 'Closed - Hidden from students';
      }
    }

    return 'Unknown status';
  }

  /// Filters a list of jobs based on student visibility rules
  static List<JobPost> filterVisibleJobs({
    required List<JobPost> jobs,
    Map<String, bool> appliedJobs = const {},
    Map<String, bool> savedJobs = const {},
  }) {
    return jobs.where((job) {
      final hasApplied = appliedJobs[job.id] ?? false;
      final hasSaved = savedJobs[job.id] ?? false;
      
      return isVisibleToStudent(
        jobPost: job,
        hasApplied: hasApplied,
        hasSaved: hasSaved,
      );
    }).toList();
  }

  /// Returns the badge color and label for a job's visibility status
  static ({Color color, String label}) getVisibilityBadge({
    required JobPost jobPost,
    bool hasApplied = false,
    bool hasSaved = false,
  }) {
    if (jobPost.isDraft) {
      return (
        color: const Color(0xFF6C6C6C),
        label: 'Draft',
      );
    }

    if (jobPost.status == JobStatus.active) {
      return (
        color: const Color(0xFFABD600),
        label: 'Active',
      );
    }

    if (jobPost.status == JobStatus.closed) {
      if (hasApplied || hasSaved) {
        return (
          color: const Color(0xFF9B7FD8),
          label: 'Closed',
        );
      } else {
        return (
          color: const Color(0xFFC63F47),
          label: 'Closed',
        );
      }
    }

    return (
      color: const Color(0xFF6C6C6C),
      label: 'Unknown',
    );
  }
}
