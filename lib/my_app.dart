import 'package:flutter/material.dart';
import 'package:mvvm_example/ui/widget/auth_widget.dart';
import 'package:mvvm_example/ui/widget/example_widget.dart';
import 'package:mvvm_example/ui/widget/loader_widget.dart';
import 'package:mvvm_example/ui/widget/stagger_driven_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == 'auth') {
          return PageRouteBuilder<dynamic>(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AuthWidget.create(),
            transitionDuration: Duration.zero,
          );
        } else if (settings.name == 'example') {
          return PageRouteBuilder<dynamic>(
            pageBuilder: (context, animation, secondaryAnimation) =>
                StaggerExampleWidget.create(),
            transitionDuration: const Duration(seconds: 4),
          );
        } else if (settings.name == 'loader') {
          return PageRouteBuilder<dynamic>(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoaderWidget.create(),
            transitionDuration: Duration.zero,
          );
        }
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoaderWidget.create(),
    );
  }
}
