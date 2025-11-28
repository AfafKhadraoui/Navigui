import 'package:flutter/material.dart';
import '../../../../logic/models/application.dart';

class RequestDetailScreen extends StatefulWidget {
  final Application application;

  const RequestDetailScreen({super.key, required this.application});

  @override
  State<RequestDetailScreen> createState() =>
      _RequestDetailScreenState();
}

class _RequestDetailScreenState
    extends State<RequestDetailScreen> {
  late Application _application;
  bool _isProcessing = false;

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
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: Text(
          'Are you sure you want to ${newStatus.label.toLowerCase()} ${_application.studentName}\'s application?',
          style: const TextStyle(
        
            color: Color(0xFFBFBFBF),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
           
                color: Color(0xFF6C6C6C),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              newStatus.label,
              style: TextStyle(
       
                color: newStatus == ApplicationStatus.accepted
                    ? const Color(0xFFD2FF1F)
                    : const Color(0xFFC63F47),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Update application status in backend
      setState(() {
        _application = _application.copyWith(status: newStatus);
      });
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
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _getAvatarColor(_application.avatar),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(_application.studentName),
                        style: const TextStyle(
                    
                          fontSize: 32,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _application.studentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _application.jobTitle,
                    style: const TextStyle(
                    
                      fontSize: 16,
                      color: Color(0xFF6C6C6C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStatusBadge(),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Contact Information
            _buildSectionTitle('Contact Information'),
            const SizedBox(height: 12),
            _buildInfoCard(
              Icons.email_outlined,
              'Email',
              _application.email,
              const Color(0xFFAB93E0),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              Icons.phone_outlined,
              'Phone',
              _application.phone,
              const Color(0xFFAB93E0),
            ),
            const SizedBox(height: 24),

            // Experience
            _buildSectionTitle('Experience'),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2F2F2F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                _application.experience,
                style: const TextStyle(
              
                  fontSize: 16,
                  color: Color(0xFFAB93E0),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Skills
            _buildSectionTitle('Skills'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _application.skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAB93E0).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFAB93E0),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                
                      fontSize: 13,
                      color: Color(0xFFAB93E0),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Cover Letter
            _buildSectionTitle('Cover Letter'),
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
               
                  fontSize: 15,
                  color: Color(0xFFBFBFBF),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Application Date
            _buildSectionTitle('Application Date'),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2F2F2F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    color: Color(0xFF6C6C6C),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_application.appliedDate.day}/${_application.appliedDate.month}/${_application.appliedDate.year}',
                    style: const TextStyle(
                  
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Action Buttons (Fixed at bottom)
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
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Reject',
                            style: TextStyle(
                          
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
                        backgroundColor: const Color(0xFFD2FF1F),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, color: Color(0xFF1A1A1A)),
                          SizedBox(width: 8),
                          Text(
                            'Accept',
                            style: TextStyle(
                            
                              fontSize: 16,
                              color: Color(0xFF1A1A1A),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildInfoCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                   
                    fontSize: 12,
                    color: Color(0xFF6C6C6C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                  
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (_application.status) {
      case ApplicationStatus.pending:
        backgroundColor = const Color(0xFFFFE078);
        textColor = const Color(0xFF1A1A1A);
        icon = Icons.schedule;
        break;
      case ApplicationStatus.accepted:
        backgroundColor = const Color(0xFFD2FF1F);
        textColor = const Color(0xFF1A1A1A);
        icon = Icons.check_circle;
        break;
      case ApplicationStatus.rejected:
        backgroundColor = const Color(0xFFC63F47);
        textColor = Colors.white;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 16),
          const SizedBox(width: 6),
          Text(
            _application.status.label,
            style: TextStyle(
        
              fontSize: 14,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
