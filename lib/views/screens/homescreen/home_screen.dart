import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:navigui/views/widgets/home/part_time_jobs_section.dart';
import 'package:navigui/views/widgets/home/quick_tasks_section.dart';
import 'package:navigui/views/widgets/home/educational_content_section.dart';
import 'package:navigui/routes/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with profile
            _buildHeader(context),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Category tags
                    _buildCategoryTags(),

                    const SizedBox(height: 20),

                    // Part Time Jobs
                    const PartTimeJobsSection(),

                    const SizedBox(height: 20),

                    // Quick Tasks
                    const QuickTasksSection(),

                    const SizedBox(height: 20),

                    // Learn & Grow
                    const EducationalContentSection(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Row(
        children: [
          // Profile Avatar with Figma character
          Stack(
            children: [
              // Avatar with character face
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile/avatar.jpg', // Add your profile image here
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to custom paint if image not found
                      return CustomPaint(
                        size: Size(50, 50),
                        painter: ProfileCharacterPainter(),
                      );
                    },
                  ),
                ),
              ),

              // Online status indicator (green dot)
              Positioned(
                left: 40,
                top: 34,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.electricLime, // #D2FF1F
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.background, // #1A1A1A
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 15),

          // Hello text
          Expanded(
            child: Text(
              'Hello, Afaf',
              style: TextStyle(
                color: AppColors.purple1, // #AB93E0
                fontSize: 16,
                fontFamily: 'Aclonica',
                letterSpacing: -0.5,
              ),
            ),
          ),

          // Notification bell
          GestureDetector(
            onTap: () {
              context.push(AppRouter.notifications);
            },
            child: Stack(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: AppColors.grey2, // #6C6C6C
                  size: 24,
                ),

                // Notification indicator (green dot)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.electricLime, // #D2FF1F
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.background, // #1A1A1A
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTags() {
    final categories = [
      'UX/UI',
      'Python',
      'Marketing',
      'Game dev',
      'Coding',
      'Java'
    ];

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 24), // Match header padding
      child: Wrap(
        alignment: WrapAlignment.start, // Align to the left
        spacing: 10, // Horizontal spacing between items
        runSpacing: 10, // Vertical spacing between rows
        children: List.generate(categories.length, (index) {
          final isFirst = index == 0;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            decoration: BoxDecoration(
              color: isFirst ? AppColors.electricLime : Colors.transparent,
              border: Border.all(color: AppColors.grey2, width: 2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              categories[index],
              style: TextStyle(
                color: isFirst
                    ? Color(0xFF414141)
                    : Colors.white.withOpacity(0.47),
                fontSize: 14,
                fontWeight: isFirst ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: -0.5,
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Custom painter for the profile character face (from Figma)
class ProfileCharacterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Scale factor to fit 50x50 container
    final scale = size.width / 50;

    // Draw upper face outline (Ellipse 12)
    final upperFacePath = Path();
    upperFacePath.addOval(Rect.fromCenter(
      center: Offset(25 * scale, 18 * scale),
      width: 20 * scale,
      height: 14 * scale,
    ));
    canvas.drawPath(upperFacePath, paint);

    // Draw lower face outline (Ellipse 13)
    final lowerFacePath = Path();
    lowerFacePath.addOval(Rect.fromCenter(
      center: Offset(25 * scale, 38 * scale),
      width: 28 * scale,
      height: 18 * scale,
    ));
    canvas.drawPath(lowerFacePath, paint);

    // Draw left eye (Ellipse 14)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(17.66 * scale, 30.4 * scale),
        width: 9.13 * scale,
        height: 12.3 * scale,
      ),
      fillPaint,
    );

    // Draw right eye (Ellipse 15)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(32.14 * scale, 30.4 * scale),
        width: 9.52 * scale,
        height: 12.3 * scale,
      ),
      fillPaint,
    );

    // Draw hair lines on left side
    // Line 5 (center)
    canvas.drawLine(
      Offset(17.56 * scale, 14.03 * scale),
      Offset(17.56 * scale, 17.4 * scale),
      paint,
    );

    // Line 6 (right of center)
    canvas.drawLine(
      Offset(20.23 * scale, 14.1 * scale),
      Offset(19.32 * scale, 17.51 * scale),
      paint,
    );

    // Line 7 (left of center - angled)
    canvas.drawLine(
      Offset(15.59 * scale, 13.49 * scale),
      Offset(14.5 * scale, 16.9 * scale),
      paint,
    );

    // Draw hair lines on right side
    // Line 8 (center)
    canvas.drawLine(
      Offset(32.25 * scale, 14.03 * scale),
      Offset(32.25 * scale, 17.4 * scale),
      paint,
    );

    // Line 9 (left of center)
    canvas.drawLine(
      Offset(34.66 * scale, 14.1 * scale),
      Offset(33.75 * scale, 17.51 * scale),
      paint,
    );

    // Line 10 (right of center - angled)
    canvas.drawLine(
      Offset(30.02 * scale, 13.49 * scale),
      Offset(31.11 * scale, 16.9 * scale),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
