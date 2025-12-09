import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../../../data/databases/db_helper.dart';
import '../../../data/models/job_post.dart';
import 'employer_job_state.dart';

class EmployerJobCubit extends Cubit<EmployerJobState> {
  String? _employerId;

  EmployerJobCubit() : super(EmployerJobInitial());

  void setEmployerId(String employerId) {
    _employerId = employerId;
  }

  /// Load all jobs for the current employer with optional status filter
  Future<void> loadMyJobs({String? statusFilter}) async {
    print('DEBUG loadMyJobs: Starting - employerId=$_employerId, statusFilter=$statusFilter');
    
    if (_employerId == null) {
      print('DEBUG loadMyJobs: ERROR - No employer ID set');
      emit(const EmployerJobError('No employer ID set'));
      return;
    }

    try {
      emit(EmployerJobLoading());
      print('DEBUG loadMyJobs: Emitted loading state');
      
      final db = await DBHelper.getDatabase();
      print('DEBUG loadMyJobs: Got database instance');

      String query = 'SELECT * FROM jobs WHERE employer_id = ?';
      List<dynamic> params = [_employerId];

      if (statusFilter != null && statusFilter.isNotEmpty) {
        query += ' AND status = ?';
        params.add(statusFilter);
      }

      query += ' ORDER BY created_at DESC';
      
      print('DEBUG loadMyJobs: Executing query: $query with params: $params');

      final maps = await db.rawQuery(query, params);
      print('DEBUG loadMyJobs: Query returned ${maps.length} jobs');
      
      if (maps.isNotEmpty) {
        for (var i = 0; i < maps.length; i++) {
          print('DEBUG loadMyJobs: Job $i: ${maps[i]}');
        }
      }
      
      final jobs = <JobPost>[];
      
      for (var map in maps) {
        try {
          final job = JobPost.fromMap(map);
          jobs.add(job);
          print('DEBUG loadMyJobs: Loaded job ${job.id}: ${job.title}');
        } catch (e) {
          print('DEBUG loadMyJobs: ERROR parsing job - $e');
          print('DEBUG loadMyJobs: Problem map: $map');
        }
      }

      print('DEBUG loadMyJobs: Successfully loaded ${jobs.length} jobs');
      emit(EmployerJobsLoaded(
        jobs: jobs,
        statusFilter: statusFilter,
      ));
      print('DEBUG loadMyJobs: Emitted loaded state with ${jobs.length} jobs');
    } catch (e) {
      print('DEBUG loadMyJobs: Exception - $e');
      print('DEBUG loadMyJobs: Stack trace: $e');
      emit(EmployerJobError('Failed to load jobs: ${e.toString()}'));
    }
  }

  /// Create a new job posting
  Future<void> createJob({
    required String title,
    required String description,
    String? briefDescription,
    required String category,
    String? location,
    required JobType jobType,
    required double pay,
    PaymentType? paymentType,
    String? timeCommitment,
    String? duration,
    DateTime? startDate,
    DateTime? applicationDeadline,
    String? requirements,
    bool requiresCv = false,
    bool isUrgent = false,
    bool isRecurring = false,
    int numberOfPositions = 1,
    List<String>? languages,
  }) async {
    print('DEBUG createJob: Starting - employerId=$_employerId');
    
    if (_employerId == null) {
      print('DEBUG createJob: ERROR - No employer ID set');
      emit(const EmployerJobError('No employer ID set'));
      return;
    }

    try {
      emit(EmployerJobLoading());
      final db = await DBHelper.getDatabase();

      final jobId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();

      final job = JobPost(
        id: jobId,
        employerId: _employerId!,
        title: title,
        description: description,
        briefDescription: briefDescription,
        category: category,
        jobType: jobType,
        pay: pay,
        paymentType: paymentType,
        timeCommitment: timeCommitment,
        duration: duration,
        startDate: startDate,
        location: location,
        isRecurring: isRecurring,
        isUrgent: isUrgent,
        requiresCv: requiresCv,
        isDraft: false,
        numberOfPositions: numberOfPositions,
        applicantsCount: 0,
        savesCount: 0,
        status: JobStatus.active,
        requirements: requirements,
        applicationDeadline: applicationDeadline,
        createdDate: now,
        updatedAt: now,
        languages: languages ?? const [],
      );

      // Insert job into database
      print('DEBUG createJob: Job data: ${job.toMap()}');
      
      await db.insert('jobs', job.toMap());
      
      print('DEBUG createJob: Job inserted successfully: ${job.id}');

      emit(EmployerJobCreated(job));
      print('DEBUG createJob: Emitted created state');

      // Reload jobs to refresh list
      print('DEBUG createJob: Reloading jobs');
      await loadMyJobs();
    } catch (e) {
      print('DEBUG createJob: Exception - $e');
      print('DEBUG createJob: Stack trace - $e');
      emit(EmployerJobError('Failed to create job: ${e.toString()}'));
    }
  }

  /// Update existing job posting
  Future<void> updateJob({
    required String jobId,
    String? title,
    String? description,
    String? category,
    String? location,
    JobType? jobType,
    double? pay,
    PaymentType? paymentType,
    String? timeCommitment,
    bool? requiresCv,
    bool? isUrgent,
    bool? isRecurring,
    int? numberOfPositions,
    List<String>? languages,
  }) async {
    if (_employerId == null) {
      emit(const EmployerJobError('No employer ID set'));
      return;
    }

    try {
      emit(EmployerJobLoading());
      final db = await DBHelper.getDatabase();

      final updateMap = <String, dynamic>{
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (category != null) 'category': category,
        if (location != null) 'location': location,
        if (jobType != null) 'job_type': jobType.dbValue,
        if (pay != null) 'pay': pay,
        if (paymentType != null) 'payment_type': paymentType.dbValue,
        if (timeCommitment != null) 'time_commitment': timeCommitment,
        if (requiresCv != null) 'requires_cv': requiresCv ? 1 : 0,
        if (isUrgent != null) 'is_urgent': isUrgent ? 1 : 0,
        if (isRecurring != null) 'is_recurring': isRecurring ? 1 : 0,
        if (numberOfPositions != null) 'number_of_positions': numberOfPositions,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await db.update(
        'jobs',
        updateMap,
        where: 'id = ? AND employer_id = ?',
        whereArgs: [jobId, _employerId],
      );

      emit(EmployerJobUpdated(jobId: jobId));

      // Reload jobs
      await loadMyJobs();
    } catch (e) {
      emit(EmployerJobError('Failed to update job: ${e.toString()}'));
    }
  }

  /// Delete a job posting
  Future<void> deleteJob(String jobId) async {
    if (_employerId == null) {
      emit(const EmployerJobError('No employer ID set'));
      return;
    }

    try {
      emit(EmployerJobLoading());
      final db = await DBHelper.getDatabase();

      await db.delete(
        'jobs',
        where: 'id = ? AND employer_id = ?',
        whereArgs: [jobId, _employerId],
      );

      emit(EmployerJobDeleted(jobId));

      // Reload jobs
      await loadMyJobs();
    } catch (e) {
      emit(EmployerJobError('Failed to delete job: ${e.toString()}'));
    }
  }

  /// Close a job posting
  Future<void> closeJob(String jobId) async {
    await updateJob(jobId: jobId);
  }

  /// Filter jobs by status
  Future<void> filterByStatus(String status) async {
    await loadMyJobs(statusFilter: status);
  }

  /// Refresh jobs list
  Future<void> refreshJobs() async {
    final currentState = state;
    if (currentState is EmployerJobsLoaded) {
      await loadMyJobs(statusFilter: currentState.statusFilter);
    } else {
      await loadMyJobs();
    }
  }
}