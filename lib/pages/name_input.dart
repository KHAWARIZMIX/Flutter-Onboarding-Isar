// Name input page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_profile_isar/providers/provider.dart';

// Name input page
class NameInputPage extends ConsumerWidget {
  final VoidCallback onNext;

  const NameInputPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final controller = TextEditingController(text: state.name);
    final isValid = state.name.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Enter Your Name',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            onChanged: (value) => notifier.updateName(value),
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: (isValid && controller.text.trim().isNotEmpty)
                ? onNext
                : null,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
