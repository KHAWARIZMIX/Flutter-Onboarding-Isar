// Bio input page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_profile_isar/providers/provider.dart';
import 'package:user_profile_isar/screen/onboarding/profile_setup_screen.dart';

// Bio input page
class BioInputPage extends ConsumerWidget {
  final VoidCallback onFinish;
  final VoidCallback? onBack;

  const BioInputPage({super.key, required this.onFinish, this.onBack});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final controller = TextEditingController(text: state.bio);
    final isValid = state.bio.trim().isNotEmpty;

    void onFinish(BuildContext context) {
      if (isValid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Tell Us About Yourself',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            onChanged: (value) => notifier.updateBio(value),
            decoration: const InputDecoration(
              labelText: 'Bio',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: (isValid && controller.text.trim().isNotEmpty)
                ? () =>
                      onFinish(
                        context,
                      ) // Now it's a function, not a direct call
                : null,
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }
}
