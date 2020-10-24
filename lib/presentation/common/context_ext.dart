import 'package:ctr/domain/entity/user.dart';
import 'package:ctr/domain/interactor/user_interactor.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/presentation/camera/camera_screen.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

extension GoogleSignIn on BuildContext {
  void googleSignIn() {
    this.read<UserInteractor>().signInWithGoogle().then((User user) {
      if (user != null) {
        AppNavigator.of(this).clearAndPush(
            MaterialPage(name: CameraScreen.routeName, child: CameraScreen()));
      }
    }).catchError((e) {
      showDialog(
          context: this,
          builder: (dialogContext) => AlertDialog(
                title: Text("Warning"),
                content: Text(e.message),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text("Close"))
                ],
              ));
      Fimber.e(e.toString());
    }, test: (e) => e is PlatformException);
  }
}
