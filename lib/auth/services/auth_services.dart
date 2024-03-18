// import 'package:firebase_core/firebase_core.dart';
import 'package:chat_app/auth/services/database_service.dart';
import 'package:chat_app/auth/services/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      UserCredential userCredential =
          (await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ));

      if (userCredential.user != null) {
        await DatabaseService(uid: userCredential.user?.uid)
            .savingUserData(fullName, email);
      }

      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  Future loginUsingEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          (await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ));

      if (userCredential.user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await Preferences.saveUserEmailToSf("");
      await Preferences.saveUserLoggedinStatusToSf(false);
      await Preferences.saveUserNameToSf("");
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  Future sendResetPasswordLink(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }
}
