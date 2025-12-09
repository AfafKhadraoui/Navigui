import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../commons/themes/style_simple/colors.dart';
import '../../../data/models/job_post.dart';
import '../../../data/models/applications_model.dart';
import '../../../mock/mock_data.dart';
import '../../../routes/app_router.dart';

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
  final MockData _mockData = MockData();
  List<Application> _applications = [];
  List<Application> _filteredApplications = [];
  String _searchQuery = '';
  ApplicationStatus? _selectedStatus;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mockData.initializeSampleData();
    _loadApplications();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadApplications() {
    setState(() {
      _applications = _mockData.getApplicationsForJob(widget.jobPost.id);
      _filterApplications();
    });
  }

  void _filterApplications() {
    setState(() {
      _filteredApplications = _applications.where((app) {
        // Status filter
        if (_selectedStatus != null && app.status != _selectedStatus) {
          return false;
        }

        // Search filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          return app.studentName.toLowerCase().contains(query) ||
                 app.university.toLowerCase().contains(query) ||
                 app.major.toLowerCase().contains(query);
        }

        return true;
      }).toList();
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _filterApplications();
    });
  }

  void _onStatusFilterChanged(ApplicationStatus? status) {
    setState(() {
      _selectedStatus = status;
      _filterApplications();
    });
  }

  int _getStatusCount(ApplicationStatus status) {
    return _applications.where((app) => app.status == status).length;
  }

  Future<void> _navigateToApplicationDetail(Application application) async {
    await context.push(
      '${AppRouter.studentRequestDetail}/${application.id}',
      extra: application,
    );
    _loadApplications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_applications.length} Applications',
                          style: const TextStyle(
                            fontFamily: 'Aclonica',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.jobPost.title,
                          style: const TextStyle(
                            fontFamily: 'Acme',
                            fontSize: 14,
                            color: Color(0xFF6C6C6C),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Search action
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Status Filter Tabs
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _FilterChip(
                          label: 'All (${_applications.length})',
                          isSelected: _selectedStatus == null,
                          onTap: () => _onStatusFilterChanged(null),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Pending (${_getStatusCount(ApplicationStatus.pending)})',
                          isSelected: _selectedStatus == ApplicationStatus.pending,
                          onTap: () => _onStatusFilterChanged(ApplicationStatus.pending),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Accepted (${_getStatusCount(ApplicationStatus.accepted)})',
                          isSelected: _selectedStatus == ApplicationStatus.accepted,
                          onTap: () => _onStatusFilterChanged(ApplicationStatus.accepted),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Rejected (${_getStatusCount(ApplicationStatus.rejected)})',
                          isSelected: _selectedStatus == ApplicationStatus.rejected,
                          onTap: () => _onStatusFilterChanged(ApplicationStatus.rejected),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      // Sort/Filter action
                    },
                    icon: const Icon(
                      Icons.tune,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Applications List
            Expanded(
              child: _filteredApplications.isEmpty
                  ? Center(
                      child: Text(
                        _searchQuery.isNotEmpty
                            ? 'No applications found matching "$_searchQuery"'
                            : _selectedStatus != null
                                ? 'No ${_selectedStatus!.label.toLowerCase()} applications'
                                : 'No applications yet',
                        style: const TextStyle(
                          fontFamily: 'Acme',
                          fontSize: 16,
                          color: AppColors.textDisabled,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: _filteredApplications.length,
                      itemBuilder: (context, index) {
                        final application = _filteredApplications[index];
                        return _ApplicationCard(
                          application: application,
                          onTap: () => _navigateToApplicationDetail(application),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFABD600) : const Color(0xFF2F2F2F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFABD600) : const Color(0xFF3D3D3D),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Acme',
            fontSize: 14,
            color: isSelected ? const Color(0xFF1A1A1A) : Colors.white,
          ),
        ),
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final Application application;
  final VoidCallback onTap;

  const _ApplicationCard({
    required this.application,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2F2F),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xFF3D3D3D),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: const Color(0xFFABD600),
              child: application.avatar == null
                  ? Text(
                      application.studentName[0].toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Aclonica',
                        fontSize: 24,
                        color: Color(0xFF1A1A1A),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          application.studentName,
                          style: const TextStyle(
                            fontFamily: 'Aclonica',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _StatusBadge(status: application.status),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // University and Major
                  Text(
                    '${application.university} - ${application.major}',
                    style: const TextStyle(
                      fontFamily: 'Acme',
                      fontSize: 13,
                      color: Color(0xFFBFBFBF),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Skills
                  if (application.skills.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: application.skills.take(3).map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3D3D3D),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(
                              fontFamily: 'Acme',
                              fontSize: 11,
                              color: Color(0xFFABD600),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 8),

                  // Application info
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF6C6C6C),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Applied ${_formatDate(application.appliedDate)}',
                        style: const TextStyle(
                          fontFamily: 'Acme',
                          fontSize: 12,
                          color: Color(0xFF6C6C6C),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (application.cvAttached)
                        const Row(
                          children: [
                            Icon(
                              Icons.description,
                              color: Color(0xFF6C6C6C),
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'CV Attached',
                              style: TextStyle(
                                fontFamily: 'Acme',
                                fontSize: 12,
                                color: Color(0xFF6C6C6C),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final ApplicationStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case ApplicationStatus.pending:
        backgroundColor = const Color(0xFFABD600).withValues(alpha: 0.2);
        textColor = const Color(0xFFABD600);
        break;
      case ApplicationStatus.accepted:
        backgroundColor = const Color(0xFF4CAF50).withValues(alpha:0.2);
        textColor = const Color(0xFF4CAF50);
        break;
      case ApplicationStatus.rejected:
        backgroundColor = const Color(0xFFC63F47).withValues(alpha:0.2);
        textColor = const Color(0xFFC63F47);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontFamily: 'Acme',
          fontSize: 11,
          color: textColor,
        ),
      ),
    );
  }
}