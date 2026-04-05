import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:news_chat_app/constants/database_helper.dart';
import 'package:news_chat_app/service/auth_service.dart';

class LogOutView extends HookWidget {
  const LogOutView({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = useState<Map<String, dynamic>?>(null);

    useEffect(() {
      DatabaseHelper().getUser().then((user) {
        userProfile.value = user;
      });
      return null;
    }, []);

    final authService = AuthService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Image Placeholder
              CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFF8B5CF6).withOpacity(0.1),
                backgroundImage: userProfile.value?['photoUrl'] != null
                    ? NetworkImage(userProfile.value!['photoUrl'])
                    : null,
                child: userProfile.value?['photoUrl'] == null
                    ? const Icon(Icons.person, size: 60, color: Color(0xFF8B5CF6))
                    : null,
              ),
              const SizedBox(height: 24),
              
              // Name and Email
              Text(
                userProfile.value?['displayName'] ?? 'Guest User',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                userProfile.value?['email'] ?? 'Not signed in',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 48),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await authService.logout();
                    if (context.mounted) {
                      Navigator.pop(context); // Go back to Home
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
