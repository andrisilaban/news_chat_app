import 'package:flutter/material.dart';
import 'package:news_chat_app/features/login_view.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> navigateToLoginAndRemoveAll() async {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginView()),
      (route) => false,
    );
  }

  // Tambahan opsional kalau kamu mau navigasi lain nanti
  static Future<void> push(Widget page) async {
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => page));
  }

  static Future<void> pushReplacement(Widget page) async {
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static void pop() {
    navigatorKey.currentState?.pop();
  }
}
