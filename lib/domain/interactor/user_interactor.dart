import 'package:ctr/database.dart';
import 'package:ctr/domain/entity/user.dart';
import 'package:fimber/fimber_base.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInteractor {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  User getCurrentUser() {
    if (_auth.currentUser == null) {
      return User(id: ' ', email: '', name: '');
    } else {
      return User(
          id: _auth.currentUser.uid,
          email: _auth.currentUser.email,
          name: _auth.currentUser.displayName ?? '');
    }
  }

  Future<User> _makeAuthResult(auth.UserCredential authResult) async {
    Fimber.d('User Name: ${authResult.user.displayName}');
    Fimber.d('User Email ${authResult.user.email}');
    final _user = getCurrentUser();
    await Database().createUser(_user);
    return _user;
  }

  Future<User> signUp(String email, String pass) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: pass);
    return await _makeAuthResult(authResult);
  }

  Future<User> signIn(String email, String pass) async {
    final authResult =
        await _auth.signInWithEmailAndPassword(email: email, password: pass);
    return await _makeAuthResult(authResult);
  }

  Future<User> signInWithGoogle() async {
    final _googleSignIn = GoogleSignIn();
    final account = await _googleSignIn.signIn();
    if (account != null) {
      final authentication = await account.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );
      final authResult = await _auth.signInWithCredential(credential);
      return await _makeAuthResult(authResult);
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    await auth.FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
