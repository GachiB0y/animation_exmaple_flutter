import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_example/domain/data_providers/user_data_provider.dart';
import 'package:mvvm_example/domain/entity/user.dart';
import 'package:mvvm_example/domain/repository/auth_repository.dart';
import 'package:mvvm_example/ui/navigation/main_navigation.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

class UsersState {
  final User currentUser;

  UsersState({
    required this.currentUser,
  });

  UsersState copyWith({
    User? currentUser,
  }) {
    return UsersState(
      currentUser: currentUser ?? this.currentUser,
    );
  }

  @override
  String toString() => 'UsersState(currentUser: $currentUser)';

  @override
  bool operator ==(covariant UsersState other) {
    if (identical(this, other)) return true;

    return other.currentUser == currentUser;
  }

  @override
  int get hashCode => currentUser.hashCode;
}

abstract class UsersEvents {}

class UsersIncrementAgeEvent implements UsersEvents {}

class UsersDecrementAgeEvent implements UsersEvents {}

class UsersInitializeEvent implements UsersEvents {}

class UsersLogoutEvent implements UsersEvents {}

class UsersBloc extends Bloc<UsersEvents, UsersState> {
  final _authRepository = AuthRepository();
  final _userDataProvider = UserDataProvider();

  UsersBloc(BuildContext context) : super(UsersState(currentUser: User(0))) {
    on<UsersEvents>(
      (event, emit) async {
        if (event is UsersInitializeEvent) {
          final user = await _userDataProvider.loadValue();
          emit(UsersState(currentUser: user));
        } else if (event is UsersIncrementAgeEvent) {
          var user = state.currentUser;
          user = user.copyWith(age: user.age + 1);
          await _userDataProvider.saveValue(user);
          emit(UsersState(currentUser: user));
        } else if (event is UsersDecrementAgeEvent) {
          var user = state.currentUser;
          user = user.copyWith(age: max(user.age - 1, 0));
          await _userDataProvider.saveValue(user);
          emit(UsersState(currentUser: user));
        } else if (event is UsersLogoutEvent) {
          await _authRepository
              .logout()
              .then((value) => MainNavigation.showLoader(context));
        }
      },
      transformer: sequential(),
    );
  }
}
