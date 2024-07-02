import 'package:beautiful_login_ui/bloc/auth_bloc.dart';
import 'package:beautiful_login_ui/home_screen.dart';
import 'package:beautiful_login_ui/login_field.dart';
import 'package:beautiful_login_ui/widgets/gradient_button.dart';
import 'package:beautiful_login_ui/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        // BlocConsumer is the combination of BlocBuilder and BlocListener.
        // BlocListener doesn't render UI and BlocBuilder does the task of rendering UI
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Password cannot be less than 6 characters."),
              ),
            );
          }

          if (state is AuthSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Image.asset("assets/images/signin_balls.png"),
                  const Text(
                    "Sign in.",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const SocialButton(
                    iconPath: "assets/svgs/g_logo.svg",
                    label: "Continue with Google",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SocialButton(
                    iconPath: "assets/svgs/f_logo.svg",
                    label: "Continue with Facebook",
                    horizontalPadding: 90,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "or",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LoginField(
                    controller: emailController,
                    hintText: "Email",
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  LoginField(
                    controller: passwordController,
                    hintText: "Password",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GradientButton(
                    buttonTitle: "Sign In",
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            AuthLoginRequested(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            ),
                          );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
