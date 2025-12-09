import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../data/models/job_post.dart';
import '../../../data/models/applications_model.dart';
import '../../../logic/cubits/employer_application/employer_application_cubit.dart';
import '../../../logic/cubits/employer_application/employer_application_state.dart';
import 'applicant_profile_screen.dart';

class JobApplicationsScreen extends StatefulWidget {
  final JobPost jobPost;

  const JobApplicationsScreen({
    super.key,
    required this.jobPost,
  });

  @override
  State<JobApplicationsScreen> createState() => _JobApplicationsScreenState();
}

class _JobApplicationsScreenState extends State<JobApplicationsScreen> {
  String? selectedStatusFilter;

  @override
  void initState() {
    super.initState();
    // Load applications for this job
    context.read<EmployerApplicationCubit>().loadJobApplications(
      jobId: widget.jobPost.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Applications',
              style: GoogleFonts.aclonica(
                fontSize: 22,
                color: AppColors.white,
              ),
            ),
            Text(
              widget.jobPost.title,
              style: GoogleFonts.acme(
                fontSize: 14,
                color: AppColors.grey6,
              ),
            ),
          ],
        ),
      ),
      body: BlocListener<EmployerApplicationCubit, EmployerApplicationState>(
        listener: (context, state) {
          if (state is EmployerApplicationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is EmployerApplicationUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Application status updated'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: BlocBuilder<EmployerApplicationCubit, EmployerApplicationState>(
          builder: (context, state) {
            if (state is EmployerApplicationLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.electricLime,
                ),
              );
            } else if (state is EmployerApplicationsLoaded) {
              return Column(
                children: [
                  // Filter chips
                  _buildFilterSection(context, state),

                  // Applications list
                  Expanded(
                    child: state.applications.isEmpty
                        ? _buildEmptyState()
                        : _buildApplicationsList(context, state),
                  ),
                ],
              );
            } else if (state is EmployerApplicationError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppColors.electricLime,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading applications',
                      style: GoogleFonts.aclonica(
                        fontSize: 18,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: GoogleFonts.acme(
                        fontSize: 14,
                        color: AppColors.grey6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return _buildEmptyState();
          },
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    EmployerApplicationsLoaded state,
  ) {
    final statusCounts = state.getStatusCounts();
    final statuses = ['pending', 'accepted', 'rejected'];

    return Container(
      color: AppColors.grey3,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Filter by Status',
              style: GoogleFonts.aclonica(
                fontSize: 14,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                FilterChip(
                  label: Text('All (${state.applications.length})'),
                  selected: selectedStatusFilter == null,
                  onSelected: (_) {
                    setState(() => selectedStatusFilter = null);
                    context.read<EmployerApplicationCubit>().loadJobApplications(
                      jobId: widget.jobPost.id,
                    );
                  },
                  backgroundColor: AppColors.grey4,
                  selectedColor: AppColors.electricLime,
                  labelStyle: GoogleFonts.acme(
                    fontSize: 12,
                    color: selectedStatusFilter == null
                        ? AppColors.black
                        : AppColors.white,
                  ),
                ),
                const SizedBox(width: 8),
                ...statuses.map((status) {
                  final count = statusCounts[status] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text('${status.toUpperCase()} ($count)'),
                      selected: selectedStatusFilter == status,
                      onSelected: (_) {
                        setState(() => selectedStatusFilter = status);
                        context
                            .read<EmployerApplicationCubit>()
                            .filterByStatus(
                              jobId: widget.jobPost.id,
                              status: status,
                            );
                      },
                      backgroundColor: AppColors.grey4,
                      selectedColor: AppColors.electricLime,
                      labelStyle: GoogleFonts.acme(
                        fontSize: 12,
                        color: selectedStatusFilter == status
                            ? AppColors.black
                            : AppColors.white,
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsList(
    BuildContext context,
    EmployerApplicationsLoaded state,
  ) {
    final applicationsToShow = selectedStatusFilter == null
        ? state.applications
        : state.getFilteredByStatus(selectedStatusFilter!);

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: applicationsToShow.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final application = applicationsToShow[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ApplicantProfileScreen(
                  application: application,
                  onAccept: () {
                    context
                        .read<EmployerApplicationCubit>()
                        .acceptApplication(application.id);
                  },
                  onReject: () {
                    context
                        .read<EmployerApplicationCubit>()
                        .rejectApplication(application.id);
                  },
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.grey3,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getStatusColor(application.status),
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with name and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            application.studentName,
                            style: GoogleFonts.aclonica(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${application.university} • ${application.major}',
                            style: GoogleFonts.acme(
                              fontSize: 12,
                              color: AppColors.grey6,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(application.status)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        application.status.label,
                        style: GoogleFonts.acme(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(application.status),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Contact info
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 14,
                      color: AppColors.grey6,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        application.email,
                        style: GoogleFonts.acme(
                          fontSize: 11,
                          color: AppColors.grey6,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.phone_outlined,
                      size: 14,
                      color: AppColors.grey6,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      application.phone,
                      style: GoogleFonts.acme(
                        fontSize: 11,
                        color: AppColors.grey6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Applied date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.grey6,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Applied: ${DateFormat('MMM d, yyyy').format(application.appliedDate)}',
                      style: GoogleFonts.acme(
                        fontSize: 11,
                        color: AppColors.grey6,
                      ),
                    ),
                  ],
                ),

                if (application.cvAttached) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.attach_file,
                        size: 14,
                        color: AppColors.electricLime,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'CV Attached',
                        style: GoogleFonts.acme(
                          fontSize: 11,
                          color: AppColors.electricLime,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_ind_outlined,
            size: 64,
            color: AppColors.electricLime,
          ),
          const SizedBox(height: 16),
          Text(
            'No Applications Yet',
            style: GoogleFonts.aclonica(
              fontSize: 20,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Students haven\'t applied to this job yet',
            style: GoogleFonts.acme(
              fontSize: 14,
              color: AppColors.grey6,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return const Color(0xFFFFA500);
      case ApplicationStatus.accepted:
        return const Color(0xFF4CAF50);
      case ApplicationStatus.rejected:
        return const Color(0xFFE53935);
    }
  }
}
