import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:news_chat_app/main_test_wrapper.dart';
import 'package:news_chat_app/service/auth_service.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Full User Flow Test', () {
    late MockFirebaseAuth mockAuth;
    late MockGoogleSignIn mockGoogleSignIn;
    late AuthService mockAuthService;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      mockGoogleSignIn = MockGoogleSignIn();
      mockAuthService = AuthService(auth: mockAuth, googleSignIn: mockGoogleSignIn);
    });

    testWidgets('Full flow: Login -> Browse -> Bookmark -> Chat', (tester) async {
      // 1. Start the app
      await tester.pumpWidget(TestAppWrapper(
        mockAuth: mockAuth,
        mockAuthService: mockAuthService,
      ));
      await tester.pumpAndSettle();

      // 2. Login as Guest
      final guestButton = find.byKey(const Key('guest_sign_in_button'));
      expect(guestButton, findsOneWidget);
      await tester.tap(guestButton);
      await tester.pumpAndSettle();

      // Verify we are on HeadlineNewsView (Top News Indonesia text should be there)
      expect(find.textContaining('Top News'), findsOneWidget);

      // 3. Browse News & Select first item
      final newsList = find.byKey(const Key('news_list'));
      expect(newsList, findsOneWidget);
      
      final firstNewsItem = find.byKey(const Key('news_item_0'));
      expect(firstNewsItem, findsOneWidget);
      await tester.tap(firstNewsItem);
      await tester.pumpAndSettle();

      // Verify we are on Detail View
      expect(find.byKey(const Key('bookmark_detail_button')), findsOneWidget);

      // 4. Bookmark Article
      final bookmarkButton = find.byKey(const Key('bookmark_detail_button'));
      await tester.tap(bookmarkButton);
      await tester.pumpAndSettle();
      
      // Since it's a toggle, we verify the icon or just that it doesn't crash
      // In a real mock, we'd verify the database called insert.

      // 5. Open Chat
      final chatFab = find.byKey(const Key('chat_fab'));
      expect(chatFab, findsOneWidget);
      await tester.tap(chatFab);
      await tester.pumpAndSettle();

      // 6. Send Message
      final chatInput = find.byKey(const Key('chat_input_field'));
      expect(chatInput, findsOneWidget);
      await tester.enterText(chatInput, 'Hello, I need help with my order');
      await tester.pumpAndSettle();

      final sendButton = find.byKey(const Key('chat_send_button'));
      await tester.tap(sendButton);
      await tester.pumpAndSettle();

      // 7. Verify Message Sent & Bot Typing/Reply
      expect(find.text('Hello, I need help with my order'), findsOneWidget);
      
      // Wait for bot reply (NLP)
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      
      // Verify bot reply from Rule-based NLP
      expect(find.textContaining('Sure, could you please provide your order number?'), findsOneWidget);
    });
  });
}
