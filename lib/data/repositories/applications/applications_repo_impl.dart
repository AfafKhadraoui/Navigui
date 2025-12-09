import 'applications_repo_abstract.dart';
import '../../models/applications_model.dart';
import '../../../data/databases/tables/applications_table.dart';

/// Implementation of ApplicationRepository
/// Handles all application-related database operations
class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationsTable _applicationsTable = ApplicationsTable();

  @override
  Future<List<Application>> getJobApplications({
    required String jobId,
    String? statusFilter,
  }) async {
    try {
      final records = await _applicationsTable.getJobApplications(
        jobId,
        statusFilter: statusFilter,
      );

      return records
          .map((record) => Application.fromMap(record))
          .toList();
    } catch (e) {
      print('Error loading job applications: $e');
      return [];
    }
  }

  @override
  Future<List<Application>> getStudentApplications({
    required String studentId,
    String? statusFilter,
  }) async {
    try {
      final records = await _applicationsTable.getStudentApplications(
        studentId,
        statusFilter: statusFilter,
      );

      return records
          .map((record) => Application.fromMap(record))
          .toList();
    } catch (e) {
      print('Error loading student applications: $e');
      return [];
    }
  }

  @override
  Future<Application?> getApplicationById(String applicationId) async {
    try {
      final record = await _applicationsTable.getApplicationById(applicationId);

      if (record == null) {
        return null;
      }

      return Application.fromMap(record);
    } catch (e) {
      print('Error loading application: $e');
      return null;
    }
  }

  @override
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
  }) async {
    try {
      final now = DateTime.now();
      final application = Application(
        id: _generateId(),
        jobId: jobId,
        studentId: studentId,
        studentName: studentName,
        appliedDate: now,
        status: ApplicationStatus.pending,
        email: email,
        phone: phone,
        experience: experience,
        coverLetter: coverLetter,
        skills: skills,
        avatar: avatar,
        university: university,
        major: major,
        cvUrl: cvUrl,
        cvAttached: cvAttached,
      );

      await _applicationsTable.insertApplication(application.toMap());
      return application;
    } catch (e) {
      print('Error submitting application: $e');
      rethrow;
    }
  }

  @override
  Future<Application> updateApplicationStatus({
    required String applicationId,
    required ApplicationStatus status,
  }) async {
    try {
      await _applicationsTable.updateApplicationStatus(
        applicationId,
        status.dbValue,
      );

      final updated = await getApplicationById(applicationId);
      if (updated == null) {
        throw Exception('Application not found after update');
      }

      return updated;
    } catch (e) {
      print('Error updating application status: $e');
      rethrow;
    }
  }

  @override
  Future<Application> acceptApplication(String applicationId) async {
    return updateApplicationStatus(
      applicationId: applicationId,
      status: ApplicationStatus.accepted,
    );
  }

  @override
  Future<Application> rejectApplication(String applicationId) async {
    return updateApplicationStatus(
      applicationId: applicationId,
      status: ApplicationStatus.rejected,
    );
  }

  @override
  Future<void> withdrawApplication(String applicationId) async {
    try {
      await _applicationsTable.withdrawApplication(applicationId);
    } catch (e) {
      print('Error withdrawing application: $e');
      rethrow;
    }
  }

  @override
  Future<List<Application>> filterByStatus({
    required String jobId,
    required ApplicationStatus status,
  }) async {
    return getJobApplications(
      jobId: jobId,
      statusFilter: status.dbValue,
    );
  }

  @override
  Future<Map<String, dynamic>?> getApplicantProfile(String studentId) async {
    try {
      // This would fetch from student_profiles table
      // For now, returning basic structure
      return {
        'studentId': studentId,
        'profileFetched': true,
      };
    } catch (e) {
      print('Error loading applicant profile: $e');
      return null;
    }
  }

  @override
  Future<void> deleteApplication(String applicationId) async {
    try {
      await _applicationsTable.deleteApplication(applicationId);
    } catch (e) {
      print('Error deleting application: $e');
      rethrow;
    }
  }

  @override
  Future<bool> hasApplied({
    required String jobId,
    required String studentId,
  }) async {
    try {
      return await _applicationsTable.hasApplied(jobId, studentId);
    } catch (e) {
      print('Error checking application: $e');
      return false;
    }
  }

  /// Generate a unique ID for applications
  String _generateId() {
    return 'app_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 10000).toString().padLeft(4, '0')}';
  }
}
