import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Stream<FlutterPodcastUser?> get userStream =>
      _firebaseAuth.authStateChanges().map((event) {
        if (event != null) {
          return FlutterPodcastUser(event);
        } else {
          return null;
        }
      });
  static FlutterPodcastUser? get user => _firebaseAuth.currentUser != null
      ? FlutterPodcastUser(_firebaseAuth.currentUser!)
      : null;

  static Future<bool> get isVerified =>
      Future<bool>.delayed(const Duration(milliseconds: 200), () => true);
  static Future<UserCredential> signIn(
          {required String email, required String password}) =>
      _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

  static Future<UserCredential> signUp(
          {required String email, required String password}) =>
      _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

  static Future<void> signOut() => _firebaseAuth.signOut();
}

class FlutterPodcastUser {
  final User user;

  FlutterPodcastUser(this.user);

  String get userName => user.displayName ?? 'Missing Display Name';
}
