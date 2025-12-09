import '../data/models/job_post.dart';
import '../data/models/application.dart';

/// Mock data storage and CRUD operations
class MockData {
  // Singleton pattern
  static final MockData _instance = MockData._internal();
  factory MockData() => _instance;
  MockData._internal();

  // In-memory storage
  final List<JobPost> _jobs = [];
  final List<Application> _applications = [];

  // Initialize with sample data
  void initializeSampleData() {
    if (_jobs.isEmpty) {
      _jobs.addAll(_getSampleJobs());
    }
    if (_applications.isEmpty) {
      _applications.addAll(_getSampleApplications());
    }
  }

  // ==================== JOB POST CRUD ====================

  /// Get all jobs
  List<JobPost> getAllJobs() {
    return List.unmodifiable(_jobs);
  }

  /// Get jobs by employer ID (for future use when auth is implemented)
  List<JobPost> getJobsByEmployerId(String employerId) {
    // For now, return all jobs
    // In production: return _jobs.where((j) => j.employerId == employerId).toList();
    return List.unmodifiable(_jobs);
  }

  /// Get job by ID
  JobPost? getJobById(String id) {
    try {
      return _jobs.firstWhere((job) => job.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add new job
  void addJob(JobPost job) {
    _jobs.add(job);
  }

  /// Update existing job
  void updateJob(JobPost updatedJob) {
    final index = _jobs.indexWhere((job) => job.id == updatedJob.id);
    if (index != -1) {
      _jobs[index] = updatedJob;
    }
  }

  /// Delete job
  void deleteJob(String id) {
    _jobs.removeWhere((job) => job.id == id);
    // Also delete related applications
    _applications.removeWhere((app) => app.jobId == id);
  }

  /// Get application count for a job
  int getApplicationCount(String jobId) {
    return _applications.where((app) => app.jobId == jobId).length;
  }

  // ==================== APPLICATION CRUD ====================

  List<Application> getApplicationsForJob(String jobPostId) {
    return _applications.where((app) => app.jobId == jobPostId).toList();
  }

  /// Get all applications
  List<Application> getAllApplications() {
    return List.unmodifiable(_applications);
  }

  /// Get applications by employer ID (for all their jobs)
  List<Application> getApplicationsByEmployerId(String employerId) {
    // For now, return all applications
    // In production: filter by jobs owned by employer
    return List.unmodifiable(_applications);
  }

  /// Get applications for a specific job
  List<Application> getApplicationsByJobId(String jobId) {
    return _applications.where((app) => app.jobId == jobId).toList();
  }

  /// Get application by ID
  Application? getApplicationById(String id) {
    try {
      return _applications.firstWhere((app) => app.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Update application status
  void updateApplicationStatus(String appId, ApplicationStatus newStatus) {
    final index = _applications.indexWhere((app) => app.id == appId);
    if (index != -1) {
      _applications[index] = _applications[index].copyWith(status: newStatus);
    }
  }

  /// Add new application
  void addApplication(Application application) {
    _applications.add(application);
  }

  // ==================== SAMPLE DATA ====================

  List<JobPost> _getSampleJobs() {
    return [
      JobPost(
        id: '1',
        employerId: '1',
        title: 'UX Designer',
        location: 'California, USA',
        description:
            'We are looking for a talented UX Designer experienced in crafting intuitive user interfaces.',
        pay: 40000.0,
        paymentType: PaymentType.monthly,
        applicantsCount: 12,
        savesCount: 34,
        jobType: JobType.partTime,
        category: 'Graphic Design',
        requirements: 'Languages: English, French. CV required.',
        timeCommitment: '20 hours per week (Monday, Wednesday, Friday)',
        isUrgent: false,
        isRecurring: false,
        numberOfPositions: 1,
        status: JobStatus.active,
        createdDate: DateTime(2025, 10, 28),
        languages: ['English', 'French'],
        requiresCv: true,
      ),
      JobPost(
        id: '2',
        employerId: '2',
        title: 'Translation Project',
        location: 'Algiers, Algeria',
        description:
            'Looking for an Arabic-French translator for ongoing documentation projects.',
        pay: 15000.0,
        paymentType: PaymentType.perTask,
        applicantsCount: 8,
        savesCount: 23,
        jobType: JobType.quickTask,
        category: 'Translation',
        requirements: 'Languages: Arabic, French. CV not required.',
        startDate: DateTime(2025, 11, 10),
        isUrgent: true,
        isRecurring: true,
        numberOfPositions: 2,
        status: JobStatus.active,
        createdDate: DateTime(2025, 10, 27),
        languages: ['Arabic', 'French'],
        requiresCv: false,
      ),
      JobPost(
        id: '3',
        employerId: '3',
        title: 'Event Photography',
        location: 'Oran, Algeria',
        description:
            'Need experienced photographer for a corporate event on November 15th.',
        pay: 50000.0,
        paymentType: PaymentType.fixed,
        applicantsCount: 23,
        savesCount: 5,
        jobType: JobType.quickTask,
        category: 'Photography',
        requirements: 'Languages: Arabic, French. CV not required.',
        startDate: DateTime(2025, 11, 15),
        timeCommitment: '6:00 PM',
        isUrgent: false,
        isRecurring: false,
        numberOfPositions: 1,
        status: JobStatus.active,
        createdDate: DateTime(2025, 10, 25),
        languages: ['Arabic', 'French'],
        requiresCv: false,
      ),
    ];
  }

  List<Application> _getSampleApplications() {
    return [
      Application(
        id: '1',
        jobId: '1',
        studentName: 'Sarah Johnson',
        jobTitle: 'UX Designer',
        appliedDate: DateTime(2025, 10, 28),
        status: ApplicationStatus.pending,
        email: 'sarah.j@email.com',
        phone: '+213 555 1234',
        experience: '3 years',
        coverLetter:
            'I am passionate about creating user-centered designs that solve real problems. My experience includes working on mobile and web applications for startups and established companies.',
        skills: ['Figma', 'Adobe XD', 'User Research', 'Prototyping'],
        avatar: '#cebcff',
        university: "Bouzareah University",
        major: "Computer Science",
      ),
      Application(
        id: '2',
        jobId: '1',
        studentName: 'Ahmed Benali',
        jobTitle: 'UX Designer',
        appliedDate: DateTime(2025, 10, 27),
        status: ApplicationStatus.accepted,
        email: 'ahmed.b@email.com',
        phone: '+213 555 5678',
        experience: '5 years',
        coverLetter:
            'With over 5 years of experience in UX design, I have led multiple successful projects from conception to launch. I specialize in creating intuitive interfaces that delight users.',
        skills: ['Sketch', 'Figma', 'UI Design', 'Design Systems'],
        avatar: '#ffe078',
        university: "ENSIA",
        major: "Computer Science",
      ),
      Application(
        id: '3',
        jobId: '3',
        studentName: 'Leila Meziane',
        jobTitle: 'Event Photography',
        appliedDate: DateTime(2025, 10, 26),
        status: ApplicationStatus.pending,
        email: 'leila.m@email.com',
        phone: '+213 555 9012',
        experience: '2 years',
        coverLetter:
            'I have a strong background in event photography. I am detail-oriented and committed to capturing perfect moments.',
        skills: ['Photography', 'Photo Editing', 'Lightroom', 'Event Coverage'],
        avatar: '#ab93e0',
        university: "Ecole Superieure Polytechnique",
        major: "Physics",
      ),
      Application(
        id: '4',
        jobId: '2',
        studentName: 'Karim Boudiaf',
        jobTitle: 'Translation Project',
        appliedDate: DateTime(2025, 10, 25),
        status: ApplicationStatus.rejected,
        email: 'karim.b@email.com',
        phone: '+213 555 3456',
        experience: '1 year',
        coverLetter:
            'As a recent graduate with a passion for languages, I am eager to learn and grow in a professional environment.',
        skills: ['Arabic', 'French', 'Translation'],
        avatar: '#ff825c',
        university: "Badji Mokhtar University",
        major: "Translation",
      ),
      Application(
        id: '5',
        jobId: '1',
        studentName: 'Amina Cherif',
        jobTitle: 'UX Designer',
        appliedDate: DateTime(2025, 10, 24),
        status: ApplicationStatus.accepted,
        email: 'amina.c@email.com',
        phone: '+213 555 7890',
        experience: '4 years',
        coverLetter:
            'I bring extensive experience in UX design. I am committed to ensuring the highest quality standards in every project I work on.',
        skills: ['Figma', 'User Research', 'Wireframing', 'Prototyping'],
        avatar: '#d2ff1f',
        university: "ESI",
        major: "Computer Science",
      ),
    ];
  }
}
