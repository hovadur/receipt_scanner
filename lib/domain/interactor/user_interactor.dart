import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimber/fimber_base.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../data/user.dart';

class UserInteractor {
  User getCurrentUser() => User(auth.FirebaseAuth.instance.currentUser.email,
      auth.FirebaseAuth.instance.currentUser.displayName);

  Future<auth.User> signInWithGoogle() async {
    final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    auth.UserCredential authResult =
        await _auth.signInWithCredential(credential);
    var _user = authResult.user;
    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);
    auth.User currentUser = _auth.currentUser;
    assert(_user.uid == currentUser.uid);
    Fimber.d("User Name: ${_user.displayName}");
    Fimber.d("User Email ${_user.email}");

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var userStore = await users.doc(_user.uid).get();
    if (!userStore.exists) {
      users.doc(_user.uid).set({'id': _user.uid});
    }
    return _user;
  }
}
