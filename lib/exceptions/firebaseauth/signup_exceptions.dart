import 'package:do_an_ck_uddddnt/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';

class FirebaseSignUpAuthException extends MessagedFirebaseAuthException {
  FirebaseSignUpAuthException({
    String message = "Instance of FirebaseSignUpAuthException",
    String code = 'firebase-sign-up-error',
  }) : super(code, message);
}


class FirebaseSignUpAuthEmailAlreadyInUseException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthEmailAlreadyInUseException(
      {String message = "Email already in use"})
      : super(message: message);
}

class FirebaseSignUpAuthInvalidEmailException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthInvalidEmailException(
      {String message = "Email is not valid"})
      : super(message: message);
}

class FirebaseSignUpAuthOperationNotAllowedException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthOperationNotAllowedException(
      {String message = "Sign up is restricted for this user"})
      : super(message: message);
}

class FirebaseSignUpAuthWeakPasswordException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthWeakPasswordException(
      {String message = "Weak password, try something better"})
      : super(message: message);
}

class FirebaseSignUpAuthUnknownReasonFailureException
    extends FirebaseSignUpAuthException {
  FirebaseSignUpAuthUnknownReasonFailureException(
      {String message = "Can't register due to unknown reason"})
      : super(message: message);
}
