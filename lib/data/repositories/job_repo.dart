import '../models/job_post.dart';

/// Job data repository
/// Handles job-related data operations
class JobRepository {
  Future<List<JobPost>> getJobs({
    String? searchQuery,
    String? category,
    String? sortBy,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      List<JobPost> jobs = _getMockJobs();

      if (searchQuery != null && searchQuery.isNotEmpty) {
        jobs = jobs.where((job) {
          return job.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              job.description.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      }

      if (category != null && category.isNotEmpty && category != 'All') {
        jobs = jobs
            .where((job) => job.category.toString().contains(category))
            .toList();
      }

      if (sortBy == 'salary_high') {
        jobs.sort((a, b) => b.pay.compareTo(a.pay));
      } else if (sortBy == 'salary_low') {
        jobs.sort((a, b) => a.pay.compareTo(b.pay));
      } else if (sortBy == 'recent') {
        jobs.sort((a, b) => b.createdDate.compareTo(a.createdDate));
      }

      return jobs;
    } catch (e) {
      throw Exception('Failed to load jobs: ${e.toString()}');
    }
  }

  Future<JobPost> getJobById(int jobId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final jobs = _getMockJobs();
      return jobs.firstWhere((job) => job.id == jobId.toString());
    } catch (e) {
      throw Exception('Job not found');
    }
  }

  Future<List<JobPost>> getEmployerJobs({String? statusFilter}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      List<JobPost> jobs = _getMockJobs();
      if (statusFilter != null && statusFilter.isNotEmpty) {
        jobs = jobs.where((job) => job.status == statusFilter).toList();
      }
      return jobs;
    } catch (e) {
      throw Exception('Failed to load employer jobs: ${e.toString()}');
    }
  }

  Future<JobPost> createJob({
    required String title,
    required String description,
    required String category,
    required String location,
    required String employmentType,
    required double salary,
    required String salaryType,
    List<String>? requirements,
    List<String>? benefits,
    DateTime? deadline,
    int? positionsAvailable,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return JobPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      employerId: '1',
      title: title,
      location: location,
      description: description,
      category: 'Other',
      pay: salary,
      jobType:
          employmentType == 'Part-time' ? JobType.partTime : JobType.quickTask,
      status: JobStatus.active,
      createdDate: DateTime.now(),
      applicationDeadline: deadline,
      numberOfPositions: positionsAvailable ?? 1,
      applicantsCount: 0,
      viewsCount: 0,
      savesCount: 0,
    );
  }

  Future<JobPost> updateJob({
    required int jobId,
    String? title,
    String? description,
    String? category,
    String? location,
    String? employmentType,
    double? salary,
    String? salaryType,
    String? status,
    List<String>? requirements,
    List<String>? benefits,
    DateTime? deadline,
    int? positionsAvailable,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return await getJobById(jobId);
  }

  Future<void> deleteJob(int jobId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<List<JobPost>> searchJobs({
    required String query,
    required Map<String, dynamic> filters,
  }) async {
    return getJobs(
      searchQuery: query,
      category: filters['category'],
      sortBy: filters['sortBy'],
    );
  }

  Future<List<JobPost>> getSavedJobs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockJobs().take(3).toList();
  }

  Future<void> saveJob(int jobId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> unsaveJob(int jobId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  List<JobPost> _getMockJobs() {
    return [
      JobPost(
        id: '1',
        employerId: '1',
        title: 'Content Writer',
        location: 'Algiers',
        description: 'Looking for a creative content writer.',
        briefDescription: 'Write engaging content for our tech blog',
        category: 'Content Writing',
        pay: 15000.0,
        paymentType: PaymentType.monthly,
        jobType: JobType.partTime,
        status: JobStatus.active,
        createdDate: DateTime.now().subtract(const Duration(days: 2)),
        applicantsCount: 5,
        viewsCount: 120,
        savesCount: 8,
      ),
      JobPost(
        id: '2',
        employerId: '2',
        title: 'Graphic Designer',
        location: 'Oran',
        description: 'Design creative graphics.',
        briefDescription: 'Create stunning visuals for social media',
        category: 'Graphic Design',
        pay: 20000.0,
        paymentType: PaymentType.monthly,
        jobType: JobType.partTime,
        status: JobStatus.active,
        createdDate: DateTime.now().subtract(const Duration(days: 1)),
        applicantsCount: 12,
        viewsCount: 85,
        savesCount: 15,
      ),
    ];
  }
}
