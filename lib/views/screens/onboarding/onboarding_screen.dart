import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navigui/commons/themes/style_simple/colors.dart';
import 'package:navigui/routes/app_router.dart';
import 'package:navigui/views/screens/onboarding/language_selection_splash.dart';
import 'package:navigui/generated/s.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Total pages = 1 language page + 4 onboarding pages
  int get _totalPages => 5;

  List<OnboardingPageData> _getPages(BuildContext context) {
    final s = S.of(context)!;
    return [
      OnboardingPageData(
        title: s.onboardingWelcomeTitle,
        imagePath: 'assets/images/onboarding/welcome1.png',
        backgroundColor: AppColors.purple2, // #DCC1FF
      ),
      OnboardingPageData(
        title: s.onboardingFindWorkTitle,
        imagePath: 'assets/images/onboarding/welcome2.png',
        backgroundColor: AppColors.yellow1, // #F7CE45
      ),
      OnboardingPageData(
        title: s.onboardingAccessStudentsTitle,
        imagePath: 'assets/images/onboarding/welcome3.png',
        backgroundColor: AppColors.purple1, // #AB93E0
      ),
      OnboardingPageData(
        title: s.onboardingReadyTitle,
        imagePath: 'assets/images/onboarding/welcome4.png',
        backgroundColor: AppColors.purple2, // #DCC1FF
        isLastPage: true,
      ),
    ];
  }

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
    if (_currentPage < _getPages(context).length) {
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

  /// Get text style with appropriate font for current locale
  TextStyle _getTextStyle(bool isLastPage) {
    final locale = Localizations.localeOf(context).languageCode;
    final fontSize = isLastPage ? 30.0 : 32.0;

    // Use Cairo for Arabic - clean, modern font that matches Aclonica's bold style
    if (locale == 'ar') {
      return GoogleFonts.cairo(
        color: AppColors.black,
        fontSize: fontSize,
        fontWeight: FontWeight.w700, // Bold for Arabic readability
        height: 1.3,
        letterSpacing: 0,
      );
    }

    // Default Aclonica for English and French
    return TextStyle(
      color: AppColors.black,
      fontSize: fontSize,
      fontFamily: 'Aclonica',
      fontWeight: FontWeight.w400,
      height: 1.2,
      letterSpacing: -0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView with language selection + onboarding pages
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _totalPages,
            itemBuilder: (context, index) {
              // First page is language selection
              if (index == 0) {
                return _buildLanguageSelectionPage();
              }
              // Rest are onboarding pages
              final pages = _getPages(context);
              return _buildPage(pages[index - 1]);
            },
          ),

          // Page indicators (dots) - hidden on language selection page
          if (_currentPage > 0)
            Positioned(
              bottom:
                  _getPages(context)[_currentPage - 1].isLastPage ? 170 : 120,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _totalPages,
                  (index) => _buildPageIndicator(index),
                ),
              ),
            ),

          // Buttons (Next or Sign in/Sign up) - not shown on language page
          if (_currentPage > 0)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Center(
                child: _getPages(context)[_currentPage - 1].isLastPage
                    ? _buildAuthButtons()
                    : _buildNextButton(),
              ),
            ),
        ],
      ),
    );
  }

  /// Build language selection page (first page)
  Widget _buildLanguageSelectionPage() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: LanguageSelectionPage(
        onLanguageSelected: (languageCode) {
          // Move to next page (first onboarding page) after selection
          if (mounted) {
            _pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
      ),
    );
  }

  /// Build individual onboarding page
  Widget _buildPage(OnboardingPageData page) {
    return Container(
      color: page.backgroundColor,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Title at TOP
                      const SizedBox(height: 80),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          page.title,
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: _getTextStyle(page.isLastPage),
                        ),
                      ),

                      const Spacer(),

                      // Illustration
                      Image.asset(
                        page.imagePath,
                        height: page.isLastPage ? 300 : 320,
                        width: page.isLastPage ? 310 : 330,
                        fit: BoxFit.contain,
                      ),

                      const Spacer(),

                      SizedBox(
                          height: page.isLastPage
                              ? 200
                              : 150), // Space for buttons and dots
                    ],
                  ),
                ),
              ),
            );
          },
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
        child: Center(
          child: Text(
            S.of(context)!.commonNext,
            style: const TextStyle(
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
            child: Center(
              child: Text(
                S.of(context)!.onboardingSignIn,
                style: const TextStyle(
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
            child: Center(
              child: Text(
                S.of(context)!.onboardingSignUp,
                style: const TextStyle(
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
