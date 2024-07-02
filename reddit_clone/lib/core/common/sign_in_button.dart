import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_new/constants/constants.dart';
import 'package:reddit_clone_new/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_new/theme/colors.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButton({
    super.key,
    this.isFromLogin = true,
  });

  void signInWithGoogle(WidgetRef ref, BuildContext context) {
    ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle(context, isFromLogin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(ref, context),
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Pallete.greyColor),
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        label: const Text(
          "Continue with Google",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
