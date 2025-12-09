import 'package:flutter/material.dart';
import '../../../data/models/applications_model.dart';
import '../../../mock/mock_data.dart';

class StudentRequestDetailScreen extends StatefulWidget {
  final Application application;

  const StudentRequestDetailScreen({super.key, required this.application});

  @override
  State<StudentRequestDetailScreen> createState() =>
      _StudentRequestDetailScreenState();
}

class _StudentRequestDetailScreenState
    extends State<StudentRequestDetailScreen> {
  final MockData _mockData = MockData();
  late Application _application;

  @override
  void initState() {
    super.initState();
    _application = widget.application;
  }

  Color _getAvatarColor(String colorHex) {
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

  Future<void> _updateStatus(ApplicationStatus newStatus) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2F2F2F),
        title: Text(
          '${newStatus.label} Application',
          style: const TextStyle(
            fontFamily: 'Aclonica',
            color: Colors.white,
          ),
        ),
        content: Text(
          'Are you sure you want to ${newStatus.label.toLowerCase()} ${_application.studentName}\'s application?',
          style: const TextStyle(
            fontFamily: 'Acme',
            color: Color(0xFFBFBFBF),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Acme',
                color: Color(0xFF6C6C6C),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              newStatus.label,
              style: TextStyle(
                fontFamily: 'Acme',
                color: newStatus == ApplicationStatus.accepted
                    ? const Color(0xFFAB93E0)
                    : const Color(0xFFC63F47),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _mockData.updateApplicationStatus(_application.id, newStatus);
      setState(() {
        _application = _application.copyWith(status: newStatus);
      });
    }
  }

  Color _getAccentColor() {
    switch (_application.status) {
      case ApplicationStatus.accepted:
        return const Color(0xFFD2FF1F); // Green
      case ApplicationStatus.rejected:
        return const Color(0xFFC63F47); // Red
      case ApplicationStatus.withdrawn:
        return const Color(0xFF6C6C6C); // Grey
      case ApplicationStatus.pending:
      default:
        return const Color(0xFFAB93E0); // Purple (default)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          'Application Details',
          style: TextStyle(
            fontFamily: 'Aclonica',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          0,
          24,
          _application.status == ApplicationStatus.pending ? 120 : 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2F2F2F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: _getAvatarColor(_application.avatar ?? '#cebcff'),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(_application.studentName),
                        style: const TextStyle(
                          fontFamily: 'Acme',
                          fontSize: 28,
                          color: Color(0xFF1A1A1A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Name and Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _application.studentName,
                          style: const TextStyle(
                            fontFamily: 'Aclonica',
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _application.university ?? '',
                          style: const TextStyle(
                            fontFamily: 'Acme',
                            fontSize: 13,
                            color: Color(0xFFBFBFBF),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _application.major ?? '',
                          style: const TextStyle(
                            fontFamily: 'Acme',
                            fontSize: 13,
                            color: Color(0xFFAB93E0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  _buildStatusBadge(),
                ],
              ),
            ),
            const SizedBox(height: 24),


            // Skills Section
            _buildSectionTitle('Skills', _getAccentColor()),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (_application.skills ?? []).map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D3D3D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                      fontFamily: 'Acme',
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Cover Letter Section
            _buildSectionTitle('Cover Letter', _getAccentColor()),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2F2F2F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                _application.coverLetter,
                style: const TextStyle(
                  fontFamily: 'Acme',
                  fontSize: 15,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Contact Information Section
            _buildSectionTitle('Contact Information', _getAccentColor()),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2F2F2F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _buildContactRow(
                    Icons.email_outlined,
                    'Email',
                    _application.email ?? 'Not Available',
                  ),
                  const SizedBox(height: 16),
                  _buildContactRow(
                    Icons.phone_outlined,
                    'Phone',
                    _application.phone ?? 'Not Available',
                  ),
                  const SizedBox(height: 16),
                _buildContactRow(
  Icons.description_outlined,
  'CV Attached',
  'Download CV',
  isDownload: true,
  downloadUrl: _application.resumeUrl,
)

                ],
              ),
            ),
          ],
        ),
      ),
      // Action Buttons (Fixed at bottom) - Only for pending applications
      bottomSheet: _application.status == ApplicationStatus.pending
          ? Container(
              color: const Color(0xFF1A1A1A),
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          _updateStatus(ApplicationStatus.rejected),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC63F47),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Reject',
                            style: TextStyle(
                              fontFamily: 'Acme',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          _updateStatus(ApplicationStatus.accepted),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAB93E0),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Accept',
                            style: TextStyle(
                              fontFamily: 'Acme',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildSectionTitle(String title, Color accentColor) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Aclonica',
        fontSize: 16,
        color: accentColor,
      ),
    );
  }

  Widget _buildContactRow(
    IconData icon,
    String label,
    String value, {
    bool isDownload = false,
    String? downloadUrl,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFFBFBFBF),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Acme',
                  fontSize: 12,
                  color: Color(0xFF6C6C6C),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Acme',
                  fontSize: 14,
                  color: isDownload
                      ? const Color(0xFFAB93E0)
                      : Colors.white,
                  decoration: isDownload
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor;

    switch (_application.status) {
      case ApplicationStatus.pending:
        backgroundColor = const Color(0xFF6C6C6C);
        textColor = Colors.white;
        break;
      case ApplicationStatus.accepted:
        backgroundColor = const Color(0xFFD2FF1F);
        textColor = Colors.black;
        break;
      case ApplicationStatus.rejected:
        backgroundColor = const Color(0xFFC63F47);
        textColor = Colors.black;
        break;
      case ApplicationStatus.withdrawn:
        backgroundColor = const Color(0xFF6C6C6C);
        textColor = Colors.white;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _application.status.label,
        style: TextStyle(
          fontFamily: 'Acme',
          fontSize: 12,
          color: textColor,
        ),
      ),
    );
  }
}