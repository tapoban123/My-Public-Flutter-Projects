import 'package:beautiful_login_ui/bloc/auth_bloc.dart';
import 'package:beautiful_login_ui/login_screen.dart';
import 'package:beautiful_login_ui/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final authState = context.watch<AuthBloc>().state as AuthSuccess;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text((state as AuthSuccess).uid),
                Text(state is AuthSuccess ? state.uid : ""),
                const SizedBox(
                  height: 30,
                ),
                GradientButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogOutRequested());
                  },
                  buttonTitle: "Sign Out",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
