import 'package:flutter/material.dart';

class MainNavigation {
  static void showLoader(BuildContext context) =>
      Navigator.of(context).pushNamedAndRemoveUntil('loader', (_) => false);
  static void showExample(BuildContext context) =>
      Navigator.of(context).pushNamedAndRemoveUntil('example', (_) => false);
  static void showAuth(BuildContext context) =>
      Navigator.of(context).pushNamedAndRemoveUntil('auth', (_) => false);
}
