import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_chat_app/constants/database_helper.dart';

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  bool _initialized = false;

  AuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (!_initialized) {
        await _googleSignIn.initialize();
        _initialized = true;
      }

      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      
      // Save profile to local DB
      if (result.user != null) {
        await DatabaseHelper().saveUser({
          'uid': result.user!.uid,
          'email': result.user!.email,
          'displayName': result.user!.displayName,
          'photoUrl': result.user!.photoURL,
        });
      }
      
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInAsGuest() async {
    final result = await _auth.signInAnonymously();
    
    // Save guest profile
    await DatabaseHelper().saveUser({
      'uid': result.user!.uid,
      'email': 'Guest',
      'displayName': 'Guest User',
      'photoUrl': null,
    });
    
    return result;
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    await DatabaseHelper().clearUser();
  }
}
