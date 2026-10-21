import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_theme.dart';
import 'core/services/app_firebase.dart';
import 'features/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  await AppFirebase.init();
  runApp(const MovieMindApp());
}

class MovieMindApp extends StatelessWidget {
  const MovieMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieMind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const SplashScreen(),
    );
  }
}

