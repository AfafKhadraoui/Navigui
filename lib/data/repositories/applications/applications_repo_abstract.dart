import '../../models/applications_model.dart';

/// Abstract repository for application operations
/// Defines contract for managing job applications
abstract class ApplicationRepository {
  /// Load all applications for a specific job
  Future<List<Application>> getJobApplications({
    required String jobId,
    String? statusFilter,
  });

  /// Load all applications for a specific student
  Future<List<Application>> getStudentApplications({
    required String studentId,
    String? statusFilter,
  });

  /// Get a single application by ID
  Future<Application?> getApplicationById(String applicationId);

  /// Submit a new application
  Future<Application> submitApplication({
    required String jobId,
    required String studentId,
    required String studentName,
    required String email,
    required String phone,
    required String experience,
    required String coverLetter,
    required List<String> skills,
    required String avatar,
    required String university,
    required String major,
    String? cvUrl,
    bool cvAttached = false,
  });

  /// Update application status
  Future<Application> updateApplicationStatus({
    required String applicationId,
    required ApplicationStatus status,
  });

  /// Accept an application
  Future<Application> acceptApplication(String applicationId);

  /// Reject an application
  Future<Application> rejectApplication(String applicationId);

  /// Withdraw an application
  Future<void> withdrawApplication(String applicationId);

  /// Filter applications by status
  Future<List<Application>> filterByStatus({
    required String jobId,
    required ApplicationStatus status,
  });

  /// Get applicant profile details
  Future<Map<String, dynamic>?> getApplicantProfile(String studentId);

  /// Delete an application
  Future<void> deleteApplication(String applicationId);

  /// Check if student has already applied for a job
  Future<bool> hasApplied({
    required String jobId,
    required String studentId,
  });
}
