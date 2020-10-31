import 'package:ctr/domain/entity/user.dart';
import 'package:fimber/fimber_base.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database.dart';

class UserInteractor {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  User getCurrentUser() {
    if (_auth.currentUser == null)
      return User(id: ' ', email: '', name: '');
    else
      return User(
          id: _auth.currentUser.uid,
          email: _auth.currentUser.email,
          name: _auth.currentUser.displayName);
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount account = await _googleSignIn.signIn();
    if (account != null) {
      GoogleSignInAuthentication authentication = await account.authentication;
      auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );
      auth.UserCredential authResult =
          await _auth.signInWithCredential(credential);
      Fimber.d("User Name: ${authResult.user.displayName}");
      Fimber.d("User Email ${authResult.user.email}");
      var _user = getCurrentUser();
      await Database().createUser(_user);
      return _user;
    } else
      return null;
  }

  void signOut() async {
    auth.FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
