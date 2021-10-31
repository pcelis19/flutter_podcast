import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FlutterPodcastErrorWidget extends StatelessWidget {
  final Object error;
  const FlutterPodcastErrorWidget({Key? key, required this.error})
      : super(key: key);

  String get _headerText {
    String toReturn = 'Error';
    final obj = error;
    if (obj is FirebaseAuthException) {
      toReturn += ' (${obj.code})';
    }
    return toReturn;
  }

  String get _errorMessage {
    final obj = error;
    if (obj is FirebaseAuthException) {
      return obj.message ?? obj.toString();
    }
    return obj.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_headerText),
      content: SingleChildScrollView(
        child: Text(_errorMessage),
      ),
    );
  }
}
