import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:navigui/routes/app_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Welcome TO\nNavigui',
      imagePath: 'assets/images/onboarding/welcome1.png',
      backgroundColor: AppColors.purple2, // #DCC1FF
    ),
    OnboardingPageData(
      title: 'Find Work That Fits\nYour Schedule',
      imagePath: 'assets/images/onboarding/welcome2.png',
      backgroundColor: AppColors.yellow1, // #F7CE45
    ),
    OnboardingPageData(
      title: 'Access ambitious\nStudents',
      imagePath: 'assets/images/onboarding/welcome3.png',
      backgroundColor: AppColors.purple1, // #AB93E0
    ),
    OnboardingPageData(
      title: 'Ready To Start\nEarning And Hiring?',
      imagePath: 'assets/images/onboarding/welcome4.png',
      backgroundColor: AppColors.purple2, // #DCC1FF
      isLastPage: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToSignIn() {
    context.go(AppRouter.login);
  }

  void _goToSignUp() {
    context.go(AppRouter.accountType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView with onboarding pages
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),

          // Page indicators (dots)
          Positioned(
            bottom: _pages[_currentPage].isLastPage ? 170 : 120,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => _buildPageIndicator(index),
              ),
            ),
          ),

          // Buttons (Next or Sign in/Sign up)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: _pages[_currentPage].isLastPage
                  ? _buildAuthButtons()
                  : _buildNextButton(),
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual onboarding page 
  Widget _buildPage(OnboardingPageData page) {
    return Container(
      color: page.backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // Title at TOP - consistent 140 spacing for all pages
            const SizedBox(height: 140),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16), // Reduced padding for more width
              child: SizedBox(
                width: double.infinity, // Force full width
                child: Text(
                  page.title,
                  textAlign: TextAlign.center,
                  maxLines: 3, // Allow up to 3 lines
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: page.isLastPage
                        ? 30
                        : 34, // Smaller for last page to fit "Earning And Hiring?" on one line
                    fontFamily: 'Aclonica',
                    fontWeight: FontWeight.w400,
                    height: 1.15, // Tight line spacing
                    letterSpacing: -0.5, // Slightly tighter letters
                  ),
                ),
              ),
            ),

            const Spacer(), // Push image to center

            // Illustration
            Image.asset(
              page.imagePath,
              height: page.isLastPage ? 338 : 382,
              width: page.isLastPage ? 347 : 393,
              fit: BoxFit.contain,
            ),

            const Spacer(), // Push buttons to bottom

            SizedBox(height: page.isLastPage ? 190 : 140), // Space for buttons
          ],
        ),
      ),
    );
  }

  /// Build page indicator dot
  Widget _buildPageIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 12 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? AppColors.black
            : AppColors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  /// Build Next button (for pages 1-3)
  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _nextPage,
      child: Container(
        width: 162,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.black, width: 2),
          borderRadius: BorderRadius.circular(99),
        ),
        child: const Center(
          child: Text(
            'Next',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 16,
              fontFamily: 'Aclonica',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  /// Build Sign in / Sign up buttons (for last page)
  Widget _buildAuthButtons() {
    return Column(
      children: [
        // Sign in button (yellow #F5F378)
        GestureDetector(
          onTap: _goToSignIn,
          child: Container(
            width: 255,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F378), // Yellow from your design
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Center(
              child: Text(
                'Sign in',
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 16,
                  fontFamily: 'Aclonica',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 7), // Small gap between buttons

        // Sign up button (white)
        GestureDetector(
          onTap: _goToSignUp,
          child: Container(
            width: 255,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.white, // White background
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Center(
              child: Text(
                'Sign up',
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 16,
                  fontFamily: 'Aclonica',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingPageData {
  final String title;
  final String imagePath;
  final Color backgroundColor;
  final bool isLastPage;

  OnboardingPageData({
    required this.title,
    required this.imagePath,
    required this.backgroundColor,
    this.isLastPage = false,
  });
}
