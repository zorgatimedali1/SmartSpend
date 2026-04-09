// lib/features/auth/widgets/google_sign_in_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/extensions.dart';
import '../providers/auth_provider.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authProvider).isLoading;
    return OutlinedButton(
      onPressed: isLoading ? null : () async {
        await ref.read(authProvider.notifier).signInWithGoogle();
        if (context.mounted) {
          final error = ref.read(authProvider).error;
          if (error != null) context.showSnackBar(error, isError: true);
        }
      },
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        side: BorderSide(color: Theme.of(context).dividerColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: const Center(child: Text('G',
                style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF4285F4), fontSize: 14))),
          ),
          const SizedBox(width: 12),
          const Text('Continuer avec Google'),
        ],
      ),
    );
  }
}
