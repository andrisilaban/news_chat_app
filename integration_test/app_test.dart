import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:news_chat_app/constants/database_helper.dart';
import 'package:news_chat_app/features/headline_news/models/headline_news_response_model.dart';
import 'package:news_chat_app/main_test_wrapper.dart';
import 'package:news_chat_app/service/auth_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Full User Flow Test', () {
    late MockFirebaseAuth mockAuth;
    late MockGoogleSignIn mockGoogleSignIn;
    late AuthService mockAuthService;

    setUp(() async {
      mockAuth = MockFirebaseAuth();
      mockGoogleSignIn = MockGoogleSignIn();
      mockAuthService = AuthService(auth: mockAuth, googleSignIn: mockGoogleSignIn);

      // Seed mock data to SQLite to ensure "Latest" category has content for the test
      final dbHelper = DatabaseHelper();
      await dbHelper.cacheNews('Latest', [
        Article(
          title: 'Test Article Title',
          description: 'Test Description',
          url: 'https://test.com',
          publishedAt: DateTime.now().toIso8601String(),
          source: Source(name: 'Test Source'),
        ),
      ]);
    });

    testWidgets('Full flow: Login -> Browse -> Bookmark -> Chat', (tester) async {
      // 1. Start the app
      await tester.pumpWidget(TestAppWrapper(
        mockAuth: mockAuth,
        mockAuthService: mockAuthService,
      ));
      
      // Use pump() instead of pumpAndSettle() because of CircularProgressIndicator in AuthWrapper
      await tester.pump(const Duration(seconds: 1));

      // 2. Login as Guest
      final guestButton = find.byKey(const Key('guest_sign_in_button'));
      expect(guestButton, findsOneWidget);
      await tester.tap(guestButton);
      
      // Wait for auth transition and news loading indicator to appear/disappear
      // pumpAndSettle() will hang if a CircularProgressIndicator is spinning
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 1));
      }

      // Verify we are on HeadlineNewsView (Top News Indonesia text should be there)
      expect(find.textContaining('Top News'), findsOneWidget);

      // 3. Browse News & Select first item
      final newsList = find.byKey(const Key('news_list'));
      expect(newsList, findsOneWidget);
      
      // Find the specific article we seeded
      final firstNewsItem = find.text('Test Article Title');
      expect(firstNewsItem, findsOneWidget);
      
      // Additional wait to be absolutely sure layout and animations are settled
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(firstNewsItem);
      
      // Wait for navigation transition to Detail View
      await tester.pumpAndSettle(const Duration(seconds: 2)); 

      // Verify we are on Detail View
      expect(find.byKey(const Key('bookmark_detail_button')), findsOneWidget);

      // 4. Bookmark Article
      final bookmarkButton = find.byKey(const Key('bookmark_detail_button'));
      await tester.tap(bookmarkButton);
      await tester.pumpAndSettle();
      
      // 5. Open Chat
      final chatFab = find.byKey(const Key('chat_fab'));
      expect(chatFab, findsOneWidget);
      await tester.tap(chatFab);
      await tester.pumpAndSettle();

      // 6. Send Message
      final chatInput = find.byKey(const Key('chat_input_field'));
      expect(chatInput, findsOneWidget);
      await tester.enterText(chatInput, 'Hello, I need help with my order');
      await tester.pump(const Duration(milliseconds: 500));

      final sendButton = find.byKey(const Key('chat_send_button'));
      await tester.tap(sendButton);
      await tester.pumpAndSettle();

      // 7. Verify Message Sent & Bot Typing/Reply
      expect(find.text('Hello, I need help with my order'), findsOneWidget);
      
      // Wait for bot reply (NLP has a simulated delay)
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      
      // Verify bot reply from Rule-based NLP
      expect(find.textContaining('Sure, could you please provide your order number?'), findsOneWidget);
    });
  });
}
