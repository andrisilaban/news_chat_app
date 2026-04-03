import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_chat_app/firebase_options.dart';
import 'package:news_chat_app/features/auth_wrapper_view.dart';
import 'package:news_chat_app/features/headline_news/presentation/home_view.dart';
import 'package:news_chat_app/features/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Chat App',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: AuthWrapper(),
    );
  }
}
