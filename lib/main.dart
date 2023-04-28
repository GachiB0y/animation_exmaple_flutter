import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_example/domain/blocs/blocs_observer.dart';
import 'package:mvvm_example/my_app.dart';

void main() {
  Bloc.observer = BlocsObserver();
  const app = MyApp();
  runApp(app);
}
