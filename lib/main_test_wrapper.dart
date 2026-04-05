import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_chat_app/features/auth_wrapper_view.dart';
import 'package:news_chat_app/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:news_chat_app/features/headline_news/presentation/bloc/headline_news_bloc.dart';
import 'package:news_chat_app/service/auth_service.dart';

class TestAppWrapper extends StatelessWidget {
  final FirebaseAuth mockAuth;
  final AuthService mockAuthService;

  const TestAppWrapper({
    super.key,
    required this.mockAuth,
    required this.mockAuthService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HeadlineNewsBloc()),
        BlocProvider(create: (context) => BookmarkBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News Chat App Test',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: AuthWrapper(
          auth: mockAuth,
          authService: mockAuthService,
        ),
      ),
    );
  }
}
