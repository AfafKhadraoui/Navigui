import '../models/application_model.dart';

/// Application data repository
/// Handles job application-related data operations
class ApplicationRepository {
  Future<List<ApplicationModel>> getMyApplications(
      {String? statusFilter}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    List<ApplicationModel> applications = _getMockApplications();
    if (statusFilter != null && statusFilter.isNotEmpty) {
      applications =
          applications.where((app) => app.status == statusFilter).toList();
    }
    return applications;
  }

  Future<ApplicationModel> submitApplication({
    required int jobId,
    required String coverLetter,
    String? resumeUrl,
    Map<String, dynamic>? additionalInfo,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ApplicationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      jobId: jobId.toString(),
      studentId: '1',
      coverMessage: coverLetter,
      cvUrl: resumeUrl,
      status: 'pending',
      appliedAt: DateTime.now(),
    );
  }

  Future<void> withdrawApplication(int applicationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<List<ApplicationModel>> getJobApplications({
    int? jobId,
    String? statusFilter,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    List<ApplicationModel> applications = _getMockApplications();
    if (jobId != null) {
      applications = applications.where((app) => app.jobId == jobId).toList();
    }
    if (statusFilter != null && statusFilter.isNotEmpty) {
      applications =
          applications.where((app) => app.status == statusFilter).toList();
    }
    return applications;
  }

  Future<ApplicationModel> updateApplicationStatus({
    required int applicationId,
    required String status,
    String? employerNotes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final applications = _getMockApplications();
    return applications.firstWhere((app) => app.id == applicationId.toString());
  }

  List<ApplicationModel> _getMockApplications() {
    return [
      ApplicationModel(
        id: '1',
        jobId: '1',
        studentId: '1',
        coverMessage: 'I am interested in this position.',
        status: 'pending',
        appliedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ApplicationModel(
        id: '2',
        jobId: '2',
        studentId: '1',
        coverMessage: 'I have experience in this field.',
        status: 'accepted',
        appliedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }
}
