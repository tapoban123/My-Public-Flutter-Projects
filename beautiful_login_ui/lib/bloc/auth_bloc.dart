import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogOutRequested>(_onAuthLogOutRequested);
  }

  // tells us about the change that occurred
  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    debugPrint("Auth Bloc Change - $change");
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    debugPrint("Auth Bloc Error - $error");
  }

  // the following method is only present in Bloc and not in Cubit
  // It tells us the event due to which the change occured
  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.onTransition(transition);
    debugPrint("Auth Bloc Transition - $transition");
  }

  void _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final email = event.email;
      final password = event.password;

      // can validate email using Regex
      if (password.length < 6) {
        return emit(AuthFailure("Password cannot be less than 6 characters."));
      }

      await Future.delayed(
        const Duration(seconds: 1),
        () {
          return emit(AuthSuccess(uid: "$email - $password"));
        },
      );
    } catch (e) {
      return emit(AuthFailure(e.toString()));
    }
  }

  void _onAuthLogOutRequested(
    AuthLogOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await Future.delayed(
        const Duration(seconds: 1),
        () {
          return emit(AuthInitial());
        },
      );
    } catch (e) {
      return emit(AuthFailure(e.toString()));
    }
  }
}
