import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_profile_isar/model/onboarding_model.dart';
import 'package:user_profile_isar/providers/provider.dart';
import 'package:user_profile_isar/screen/home_screen.dart';
import 'package:user_profile_isar/widgets/user_avatar.dart';


/// A multi-step onboarding flow that collects user profile information.
/// Manages form state, validation, and navigation between steps.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late PageController _pageController; // Controls page navigation
  late List<TextEditingController> _textControllers; // Manages form inputs

  @override
  void initState() {
    super.initState();
    // Initialize page controller with default animation settings
    _pageController = PageController();
    
    // Initialize text controllers with current state values
    final state = ref.read(onboardingProvider);
    _textControllers = [
      TextEditingController(text: state.name),    // Name field
      TextEditingController(text: state.email),  // Email field
      TextEditingController(text: state.bio),    // Bio field
    ];
  }

  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks
    _pageController.dispose();
    for (final controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(onboardingProvider.notifier);
    final state = ref.watch(onboardingProvider);

    // Define onboarding pages with their content and validation rules
    final pages = [
      // Page 1: Name Input
      OnboardingModel(
        widget: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.supervised_user_circle_rounded,
              color: Colors.white,
              size: 100,
            ),
            const SizedBox(height: 40),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: TextField(
                controller: _textControllers[0],
                onChanged: notifier.updateName,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        title: 'Enter Your Name',
        subTitle: 'Please provide your full name',
      ),
      
      // Page 2: Avatar Upload
      OnboardingModel(
        widget: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: UserAvatar(
            profileImage: state.profileImage,
            onAvatarChanged: (newImageUrl) {
              notifier.updateProfileImage(newImageUrl);
            },
          ),
        ),
        title: 'Upload Your Avatar',
        subTitle: 'Add a profile picture',
      ),

      // Page 3: Email Input
      OnboardingModel(
        widget: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: TextField(
            controller: _textControllers[1],
            onChanged: notifier.updateEmail,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        title: 'Enter Your Email',
        subTitle: 'We\'ll use this for important notifications',
      ),
      
      // Page 4: Bio Input
      OnboardingModel(
        widget: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: TextField(
            controller: _textControllers[2],
            onChanged: notifier.updateBio,
            decoration: const InputDecoration(
              labelText: 'Bio',
              border: OutlineInputBorder(),
            ),
            maxLines: 4, // Allow multiple lines for bio
          ),
        ),
        title: 'Tell Us About Yourself',
        subTitle: 'Share something interesting with the community',
      ),
    ];

    /// Validates the current page's input fields
    bool isCurrentPageValid(int index) {
      switch (index) {
        case 0:  // Name must not be empty
          return _textControllers[0].text.trim().isNotEmpty;
        case 1:  // Avatar page is always valid (optional)
          return true;
        case 2:  // Email must match standard pattern
          return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(_textControllers[1].text.trim());
        case 3:  // Bio must not be empty
          return _textControllers[2].text.trim().isNotEmpty;
        default:
          return false;
      }
    }

    /// Handles navigation to next page or profile submission
    Future<void> handleNext() async {
      if (state.currentPage < pages.length - 1) {
        // Navigate to next page with smooth animation
        notifier.nextPage();
        await _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        try {
          // Save profile and show brief loading state
          await notifier.saveProfile();
          await Future.delayed(const Duration(milliseconds: 100));
          
          if (!context.mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save profile: $e')));
        }
      }
    }

    /// Handles navigation to previous page
    void handleBack() {
      if (state.currentPage > 0) {
        notifier.updateCurrentPage(state.currentPage - 1);
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Back button (visible on all pages except first)
            if (state.currentPage > 0)
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: handleBack,
                ),
              ),
            
            // Page view content area
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                onPageChanged: notifier.updateCurrentPage,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Page title
                        Text(
                          page.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        
                        // Page subtitle
                        Text(
                          page.subTitle,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Page-specific content
                        page.widget,
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Next/Finish button (disabled if current page invalid)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: isCurrentPageValid(state.currentPage)
                    ? handleNext
                    : null,
                child: Text(
                  state.currentPage == pages.length - 1 ? 'Finish' : 'Next',
                ),
              ),
            ),
            
            // Page indicator dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (index) {
                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: state.currentPage == index
                        ? Colors.blue // Active page
                        : Colors.grey, // Inactive page
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}