import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_chat_app/service/auth_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          user!.isAnonymous
              ? "Logged in as Guest"
              : "Logged in as ${user.email}",
        ),
      ),
    );
  }
}
