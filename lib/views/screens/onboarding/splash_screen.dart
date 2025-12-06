import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:navigui/routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLanguageAndNavigate();
  }

  Future<void> _checkLanguageAndNavigate() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    // Always go to onboarding (language selection is now the first page)
    context.go(AppRouter.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.electricLime,
      body: Stack(
        children: [
          // Decorative brutalist shapes
          _buildDecorativeShapes(),

          // Main content - centered logo
          Center(
            child: Text(
              'Navigui',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 36,
                fontFamily: 'Aclonica',
                fontWeight: FontWeight.w400,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeShapes() {
    return Stack(
      children: [
        // Top-left brutalist shape
        Positioned(
          left: -137,
          top: -79,
          child: CustomPaint(
            size: const Size(310, 310),
            painter: BrutalistShapePainter(
              color: AppColors.electricLime2,
            ),
          ),
        ),

        // Bottom-right brutalist shape
        Positioned(
          left: 173,
          top: 629,
          child: CustomPaint(
            size: const Size(310, 310),
            painter: BrutalistShapePainter(
              color: AppColors.electricLime2,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for brutalist organic shapes
/// This uses the exact SVG path from your Figma design
class BrutalistShapePainter extends CustomPainter {
  final Color color;

  BrutalistShapePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // SVG Path from Figma: "M274.952 105.3C296.235 60.4963..."
    // Converted to Flutter Path commands

    path.moveTo(274.952, 105.3);

    path.cubicTo(
      296.235,
      60.4963,
      249.504,
      13.6878,
      204.7,
      35.0485,
    );

    path.cubicTo(
      188.044,
      -11.6828,
      121.956,
      -11.6828,
      105.3,
      35.0485,
    );

    path.cubicTo(
      60.4963,
      13.7649,
      13.6878,
      60.4963,
      35.0485,
      105.3,
    );

    path.cubicTo(
      -11.6828,
      121.956,
      -11.6828,
      188.044,
      35.0485,
      204.7,
    );

    path.cubicTo(
      13.7649,
      249.504,
      60.4963,
      296.312,
      105.3,
      274.952,
    );

    path.cubicTo(
      121.956,
      321.683,
      188.044,
      321.683,
      204.7,
      274.952,
    );

    path.cubicTo(
      249.504,
      296.235,
      296.312,
      249.504,
      274.952,
      204.7,
    );

    path.cubicTo(
      321.683,
      188.044,
      321.683,
      121.879,
      274.952,
      105.3,
    );

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BrutalistShapePainter oldDelegate) => false;
}
