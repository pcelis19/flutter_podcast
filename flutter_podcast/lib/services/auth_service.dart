import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static AuthService? _instance;
  FlutterPodcastUser? _currentUser;
  AuthService._();
  static AuthService get instance {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = AuthService._();
      _firebaseAuth.authStateChanges().listen(_instance!._eventHandler);
      return _instance!;
    }
  }

  FlutterPodcastUser? get currentUser => _currentUser;

  void _eventHandler(User? event) {
    if (event == null) {
      _instance!._sinkUserEvent(null);
    } else {
      _instance!._sinkUserEvent(FlutterPodcastUser(event, _firebaseAuth));
    }
  }

  void _sinkUserEvent(FlutterPodcastUser? nextEvent) {
    _currentUser = nextEvent;
    notifyListeners();
  }

  static Future<UserCredential> signIn(
          {required String email, required String password}) =>
      _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

  static Future<UserCredential> signUp(
          {required String email, required String password}) =>
      _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

  /// throw if there is no current user
  Future<void> syncUserInformation() async => _currentUser!.user.reload();
}

class FlutterPodcastUser {
  final User user;
  final FirebaseAuth _firebaseAuth;

  FlutterPodcastUser(this.user, FirebaseAuth firebaseAuth)
      : _firebaseAuth = firebaseAuth;

  String get userName => user.displayName ?? 'Missing Display Name';
  bool get isVerified =>
      user.displayName != null && user.displayName!.isNotEmpty;
  void signOut() => _firebaseAuth.signOut();
}
