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
}

class FlutterPodcastUser {
  final User user;

  FlutterPodcastUser(this.user);

  String get userName => user.displayName ?? 'Missing Display Name';
}
