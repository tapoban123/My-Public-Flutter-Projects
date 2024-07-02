import "package:beautiful_login_ui/app_bloc_observer.dart";
import "package:beautiful_login_ui/bloc/auth_bloc.dart";
import "package:beautiful_login_ui/login_screen.dart";
import "package:beautiful_login_ui/palette.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const BeautifulLoginUIApp());
}

class BeautifulLoginUIApp extends StatelessWidget {
  const BeautifulLoginUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        title: "Beautiful Login UI",
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Pallete.backgroundColor,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
