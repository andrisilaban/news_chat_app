import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_chat_app/constants/custom_http.dart';
import 'package:news_chat_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:news_chat_app/features/headline_news/presentation/bloc/headline_news_bloc.dart';
import 'package:news_chat_app/firebase_options.dart';
import 'package:news_chat_app/features/auth_wrapper_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Load environment variables with error handling
  try {
    await dotenv.load(fileName: "assets/.env");
    debugPrint('✅ .env file loaded successfully');
  } catch (e) {
    // Continue without .env file if it doesn't exist
    debugPrint('Warning: Could not load .env file: $e');
  }

  // Initialize CustomHttp after dotenv is loaded (or failed to load)
  try {
    await CustomHttp().initialize();
    debugPrint('✅ CustomHttp initialized successfully');
  } catch (e) {
    debugPrint('Error initializing CustomHttp: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HeadlineNewsBloc()),
        BlocProvider(create: (context) => BookmarkBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News Chat App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: AuthWrapper(),
      ),
    );
  }
}
