import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthServices {
  static final auth = FirebaseAuth.instance;
  static final firestoreRef = FirebaseFirestore.instance;
  static final postRef = firestoreRef.collection("post");
  static final postDB = FirebaseDatabase.instance.ref('post');

  static Future<String?> signIn({String? email, String? password}) async {
    // allowing the user to sign in
    String? result;
    try {
      await auth
          .signInWithEmailAndPassword(email: email!, password: password!)
          .then((value) async {
        if (value != null) {
        } else {
          result = "Something went wrong";
        }
        result = "Success";
      });
    } on FirebaseAuthException catch (e) {
      result = getMessageFromErrorCode(e.code);
    }
    return result;
  }

  static Future<String> resetPassword({String? email}) async {
    String result;
    try {
      await auth.sendPasswordResetEmail(email: email!);
      result = "Success";
    } on FirebaseAuthException catch (e) {
      result = e.message!;
    }
    return result;
  }

  //SignUp Method
  static Future<String?> signUp({
    String? email,
    String? password,
    String? phoneNum,
  }) async {
    String? result;
    try {
      // signing up and registering the new user
      await auth
          .createUserWithEmailAndPassword(email: email!, password: password!)
          .then((value) async {
        if (value != null) {
          // We need to check this out user.User.fromJson(await getUserDetails(value.user.uid));
        } else {
          result = "Something went wrong";
        }
        result = "Success";
      });
    } on FirebaseAuthException catch (e) {
      result = getMessageFromErrorCode(e.code);
    }
    return result;
  }

  static Future<void> logout() async {
    await auth.signOut();
  }

  static String getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";

      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";

      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";

      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";

      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";

      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";

      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";

      default:
        return "Login failed. Please try again.";
    }
  }
}
