import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_chat_app/constants/database_helper.dart';

import 'login_view.dart';
import 'headline_news/presentation/headline_news_view.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
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

        return LoginView();
      },
    );
  }
}
