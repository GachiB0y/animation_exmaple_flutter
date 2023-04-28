import 'package:flutter/material.dart';
import 'package:mvvm_example/domain/repository/auth_repository.dart';
import 'package:mvvm_example/ui/navigation/main_navigation.dart';
import 'package:provider/provider.dart';

class _ViewModel {
  final _authRepository = AuthRepository();
  BuildContext context;

  _ViewModel(this.context) {
    init();
  }

  void init() async {
    final isAuth = await _authRepository.checkAuth();
    if (isAuth) {
      _goToAppScreen();
    } else {
      _goToAuthScreen();
    }
  }

  void _goToAuthScreen() {
    MainNavigation.showAuth(context);
  }

  void _goToAppScreen() {
    MainNavigation.showExample(context);
  }
}

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  static Widget create() {
    return Provider(
      create: (context) => _ViewModel(context),
      child: const LoaderWidget(),
      lazy: false,
    );
  }
}
