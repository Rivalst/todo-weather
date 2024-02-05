import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'common/bloc_observer.dart';
import 'data/model.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = Observer();
  
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoModelAdapter());
  
  runApp(const App());
}


