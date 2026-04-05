import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_chat_app/constants/database_helper.dart';

import 'login_view.dart';
import 'headline_news/presentation/headline_news_view.dart';
import 'package:news_chat_app/service/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  final FirebaseAuth auth;
  final AuthService? authService;

  AuthWrapper({super.key, FirebaseAuth? auth, this.authService})
      : auth = auth ?? FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;
          DatabaseHelper().saveUser({
            'uid': user.uid,
            'email': user.email,
            'displayName': user.displayName,
            'photoUrl': user.photoURL,
          });
          return const HeadlineNewsView();
        }

        return LoginView(authService: authService);
      },
    );
  }
}
