import 'package:firebase_auth/firebase_auth.dart';

abstract class MessagedFirebaseAuthException extends FirebaseAuthException {
  final String _customMessage;

  MessagedFirebaseAuthException(String code, this._customMessage)
      : super(code: code, message: _customMessage);

  String get message => _customMessage;

  @override
  String toString() {
    return message;
  }
}

