import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_example/domain/data_providers/auth_api_provider.dart';
import 'package:mvvm_example/domain/repository/auth_repository.dart';
import 'package:mvvm_example/ui/navigation/main_navigation.dart';

enum ViewModelAuthButtonState { canSubmit, authProcces, disable }

class AuthState {
  String authErrorTitle;
  String login;
  String password;
  bool isAuthInProcess;
  ViewModelAuthButtonState get authButtonState {
    if (isAuthInProcess) {
      return ViewModelAuthButtonState.authProcces;
    } else if (login.isNotEmpty && password.isNotEmpty) {
      return ViewModelAuthButtonState.canSubmit;
    } else {
      return ViewModelAuthButtonState.disable;
    }
  }

  AuthState({
    required this.authErrorTitle,
    required this.login,
    required this.password,
    required this.isAuthInProcess,
  });

  AuthState copyWith({
    String? authErrorTitle,
    String? login,
    String? password,
    bool? isAuthInProcess,
  }) {
    return AuthState(
      authErrorTitle: authErrorTitle ?? this.authErrorTitle,
      login: login ?? this.login,
      password: password ?? this.password,
      isAuthInProcess: isAuthInProcess ?? this.isAuthInProcess,
    );
  }

  @override
  String toString() {
    return 'AuthState(authErrorTitle: $authErrorTitle, login: $login, password: $password, isAuthInProcess: $isAuthInProcess)';
  }

  @override
  bool operator ==(covariant AuthState other) {
    if (identical(this, other)) return true;

    return other.authErrorTitle == authErrorTitle &&
        other.login == login &&
        other.password == password &&
        other.isAuthInProcess == isAuthInProcess;
  }

  @override
  int get hashCode {
    return authErrorTitle.hashCode ^
        login.hashCode ^
        password.hashCode ^
        isAuthInProcess.hashCode;
  }
}

abstract class AuthEvent {}

class AuthChangeLoginEvent implements AuthEvent {
  const AuthChangeLoginEvent(this.username);
  final String username;
}

class AuthChangePasswordEvent implements AuthEvent {
  const AuthChangePasswordEvent(this.password);
  final String password;
}

class AuthButtonPressedEvent implements AuthEvent {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authRepository = AuthRepository();

  AuthBloc(BuildContext context)
      : super(AuthState(
            authErrorTitle: '',
            login: '',
            password: '',
            isAuthInProcess: false)) {
    on<AuthChangeLoginEvent>(_changeLogin);
    on<AuthChangePasswordEvent>(_changePassword);
    on<AuthButtonPressedEvent>(
        (event, emit) => (_onAuthButtonPressed(context, emit)));
  }

  void _changeLogin(
    AuthChangeLoginEvent event,
    Emitter<AuthState> emit,
  ) {
    if (state.login == event.username) return;
    emit(state.copyWith(login: event.username));
    print(state.login);
  }

  void _changePassword(
    AuthChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) {
    if (state.password == event.password) return;
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onAuthButtonPressed(
    BuildContext context,
    Emitter<AuthState> emit,
  ) async {
    final login = state.login;
    final password = state.password;

    if (login.isEmpty || password.isEmpty) return;

    emit(state.copyWith(authErrorTitle: '', isAuthInProcess: true));

    try {
      await _authRepository.login(login, password).then((value) {
        emit(state.copyWith(isAuthInProcess: false));
        MainNavigation.showExample(context);
      });
    } on AuthProviderIncorectLoginDataError {
      emit(state.copyWith(
          authErrorTitle: 'Неправильный логин или пароль!',
          isAuthInProcess: false));
    } catch (e) {
      emit(state.copyWith(
          authErrorTitle: 'Неизвестная ошибка, попробуйте позже',
          isAuthInProcess: false));
    }
  }
}
