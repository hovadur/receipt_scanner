import 'package:ctr/domain/entity/user.dart';
import 'package:fimber/fimber_base.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import '../../database.dart';

class UserInteractor {
  Future<User> signInWithGoogle() async {
    final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
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
      var _user = User(
          id: authResult.user.uid,
          email: authResult.user.email,
          name: authResult.user.displayName);
      Fimber.d("User Name: ${_user.name}");
      Fimber.d("User Email ${_user.email}");
      await Database().createUser(_user);
      return _user;
    } else return null;
  }
}
