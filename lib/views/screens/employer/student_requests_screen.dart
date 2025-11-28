import 'package:flutter/material.dart';
import '../../../models/application.dart';
import '../../../mock/mock_data.dart';
import 'student_request_detail_screen.dart';

class StudentRequestsScreen extends StatefulWidget {
  const StudentRequestsScreen({super.key});

  @override
  State<StudentRequestsScreen> createState() => _StudentRequestsScreenState();
}

class _StudentRequestsScreenState extends State<StudentRequestsScreen> {
  final MockData _mockData = MockData();
  List<Application> _applications = [];
  ApplicationStatus? _filterStatus;
  String _searchTerm = '';
  bool _sortByDate = true; // true = date, false = name

  @override
  void initState() {
    super.initState();
    _mockData.initializeSampleData();
    _loadApplications();
  }

  void _loadApplications() {
    setState(() {
      _applications = _mockData.getAllApplications();
    });
  }

  List<Application> get _filteredApplications {
    var filtered = _applications.where((app) {
      // Filter by status
      if (_filterStatus != null && app.status != _filterStatus) {
        return false;
      }
      
      // Filter by search term
      if (_searchTerm.isNotEmpty) {
        final searchLower = _searchTerm.toLowerCase();
        return app.studentName.toLowerCase().contains(searchLower) ||
               app.jobTitle.toLowerCase().contains(searchLower);
      }
      
      return true;
    }).toList();

    // Sort
    if (_sortByDate) {
      filtered.sort((a, b) => b.appliedDate.compareTo(a.appliedDate));
    } else {
      filtered.sort((a, b) => a.studentName.compareTo(b.studentName));
    }

    return filtered;
  }

  Map<ApplicationStatus, int> get _statusCounts {
    return {
      ApplicationStatus.pending: 
          _applications.where((a) => a.status == ApplicationStatus.pending).length,
      ApplicationStatus.accepted: 
          _applications.where((a) => a.status == ApplicationStatus.accepted).length,
      ApplicationStatus.rejected: 
          _applications.where((a) => a.status == ApplicationStatus.rejected).length,
    };
  }

  Future<void> _navigateToDetail(Application application) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentRequestDetailScreen(application: application),
      ),
    );

    if (result == true) {
      _loadApplications();
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Applications',
                style: TextStyle(
                  fontFamily: 'Aclonica',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select a status to filter the applications list',
                style: TextStyle(
                  fontFamily: 'Acme',
                  fontSize: 14,
                  color: Color(0xFF6C6C6C),
                ),
              ),
              const SizedBox(height: 24),
              _buildFilterOption(null, 'All', _statusCounts.values.reduce((a, b) => a + b)),
              _buildFilterOption(ApplicationStatus.pending, 'Pending', _statusCounts[ApplicationStatus.pending]!),
              _buildFilterOption(ApplicationStatus.accepted, 'Accepted', _statusCounts[ApplicationStatus.accepted]!),
              _buildFilterOption(ApplicationStatus.rejected, 'Rejected', _statusCounts[ApplicationStatus.rejected]!),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(ApplicationStatus? status, String label, int count) {
    final isSelected = _filterStatus == status;
    Color backgroundColor;
    Color textColor;
    Color countBgColor;
    Color countTextColor;

    if (isSelected) {
      backgroundColor = const Color(0xFFD2FF1F);
      textColor = const Color(0xFF1A1A1A);
    } else {
      backgroundColor = const Color(0xFF2F2F2F);
      textColor = Colors.white;
    }

    // Status badge colors
    if (status == ApplicationStatus.pending) {
      countBgColor = const Color(0xFFFFE078);
      countTextColor = const Color(0xFF1A1A1A);
    } else if (status == ApplicationStatus.accepted) {
      countBgColor = const Color(0xFFD2FF1F);
      countTextColor = const Color(0xFF1A1A1A);
    } else if (status == ApplicationStatus.rejected) {
      countBgColor = const Color(0xFFC63F47);
      countTextColor = Colors.black;
    } else {
      countBgColor = const Color(0xFF3D3D3D);
      countTextColor = Colors.white;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _filterStatus = status;
        });
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Acme',
                fontSize: 16,
                color: textColor,
              ),
            ),
            if (status != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: countBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontFamily: 'Acme',
                    fontSize: 12,
                    color: countTextColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredApps = _filteredApplications;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Student Applications',
                  style: TextStyle(
                    fontFamily: 'Aclonica',
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Stats Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      '${_statusCounts[ApplicationStatus.pending]}',
                      'Pending',
                      const Color(0xFFFFE078),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      '${_statusCounts[ApplicationStatus.accepted]}',
                      'Accepted',
                      const Color(0xFFD2FF1F),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      '${_statusCounts[ApplicationStatus.rejected]}',
                      'Rejected',
                      const Color(0xFFC63F47),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                onChanged: (value) => setState(() => _searchTerm = value),
                style: const TextStyle(
                  fontFamily: 'Acme',
                  fontSize: 16,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Search by name or job title...',
                  hintStyle: TextStyle(
                    fontFamily: 'Acme',
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF6C6C6C),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2F2F2F),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Filters Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  // Sort Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _sortByDate = !_sortByDate;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F2F2F),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.sort,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _sortByDate ? 'Date' : 'Name',
                            style: const TextStyle(
                              fontFamily: 'Acme',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Desktop Filter Buttons (shown on larger screens)
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Show filter chips on wider screens
                        if (constraints.maxWidth > 400) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildFilterChip(null, 'All'),
                                _buildFilterChip(ApplicationStatus.pending, 'Pending'),
                                _buildFilterChip(ApplicationStatus.accepted, 'Accepted'),
                                _buildFilterChip(ApplicationStatus.rejected, 'Rejected'),
                              ],
                            ),
                          );
                        } else {
                          // Show burger menu on smaller screens
                          return Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: _showFilterSheet,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2F2F2F),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.filter_list,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'Filter',
                                      style: TextStyle(
                                        fontFamily: 'Acme',
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (_filterStatus != null) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFD2FF1F),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '1',
                                            style: TextStyle(
                                              fontFamily: 'Acme',
                                              fontSize: 10,
                                              color: Color(0xFF1A1A1A),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Applications List
            Expanded(
              child: filteredApps.isEmpty
                  ? Center(
                      child: Text(
                        'No applications found',
                        style: TextStyle(
                          fontFamily: 'Acme',
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                      itemCount: filteredApps.length,
                      itemBuilder: (context, index) {
                        final app = filteredApps[index];
                        return _ApplicationCard(
                          application: app,
                          onTap: () => _navigateToDetail(app),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Acme',
              fontSize: 24,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Acme',
              fontSize: 12,
              color: Color(0xFF6C6C6C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(ApplicationStatus? status, String label) {
    final isSelected = _filterStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _filterStatus = status;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected 
                ? const Color(0xFFD2FF1F) 
                : const Color(0xFF2F2F2F),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Acme',
              fontSize: 14,
              color: isSelected 
                  ? const Color(0xFF1A1A1A) 
                  : Colors.white,
            ),
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

  Color _getAvatarColor(String colorHex) {
    // Parse hex color string to Color
    final hex = colorHex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    Color statusBgColor;
    Color statusTextColor;

    switch (application.status) {
      case ApplicationStatus.pending:
        statusBgColor = const Color(0xFFFFE078);
        statusTextColor = const Color(0xFF1A1A1A);
        break;
      case ApplicationStatus.accepted:
        statusBgColor = const Color(0xFFD2FF1F);
        statusTextColor = const Color(0xFF1A1A1A);
        break;
      case ApplicationStatus.rejected:
        statusBgColor = const Color(0xFFC63F47);
        statusTextColor = Colors.white;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2F2F),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getAvatarColor(application.avatar),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(application.studentName),
                      style: const TextStyle(
                        fontFamily: 'Acme',
                        fontSize: 18,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name and Job
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.studentName,
                        style: const TextStyle(
                          fontFamily: 'Acme',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        application.jobTitle,
                        style: const TextStyle(
                          fontFamily: 'Acme',
                          fontSize: 14,
                          color: Color(0xFF6C6C6C),
                        ),
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    application.status.label,
                    style: TextStyle(
                      fontFamily: 'Acme',
                      fontSize: 12,
                      color: statusTextColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Applied date and experience
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Applied: ${application.appliedDate.day}/${application.appliedDate.month}/${application.appliedDate.year}',
                  style: const TextStyle(
                    fontFamily: 'Acme',
                    fontSize: 12,
                    color: Color(0xFF6C6C6C),
                  ),
                ),
                Text(
                  '${application.university}, ${application.major}',
                  style: const TextStyle(
                    fontFamily: 'Acme',
                    fontSize: 12,
                    color: Color(0xFF6C6C6C),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
