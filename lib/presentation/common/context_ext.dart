import 'package:ctr/app_module.dart';
import 'package:ctr/domain/entity/user.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/camera/camera_screen.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

extension GoogleSignIn on BuildContext {
  AppLocalizations translate() {
    return AppLocalizations.of(this)!;
  }

  void googleSignIn() {
    read(userInteractor).signInWithGoogle().then((User? user) {
      if (user != null) {
        AppNavigator.of(this).clearAndPush(const MaterialPage<Page>(
            name: CameraScreen.routeName, child: CameraScreen()));
      }
    }).catchError((e) {
      showError(e.message);
      Fimber.e(e.toString());
    }, test: (e) => e is Exception);
  }

  void signIn(String email, String pass) {
    read(userInteractor).signIn(email, pass).then((User? user) {
      if (user != null) {
        AppNavigator.of(this).clearAndPush(const MaterialPage<Page>(
            name: CameraScreen.routeName, child: CameraScreen()));
      }
    }).catchError((e) {
      showError(e.message);
      Fimber.e(e.toString());
    }, test: (e) => e is Exception);
  }

  void signUp(String email, String pass) {
    read(userInteractor).signUp(email, pass).then((User? user) {
      if (user != null) {
        AppNavigator.of(this).clearAndPush(const MaterialPage<Page>(
            name: CameraScreen.routeName, child: CameraScreen()));
      }
    }).catchError((e) {
      showError(e.message);
      Fimber.e(e.toString());
    }, test: (e) => e is Exception);
  }

  void showError(String message) {
    showDialog(
        context: this,
        builder: (dialogContext) => AlertDialog(
              title: Text(AppLocalizations.of(this)?.warning ?? ''),
              content: Text(message),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text(AppLocalizations.of(this)?.close ?? ''))
              ],
            ));
  }

  Map<IconData, String> category() {
    return {
      Icons.local_dining: translate().food,
      Icons.house: translate().home,
      Icons.commute: translate().transport,
      Icons.sports_esports: translate().entertainment,
      Icons.shopping_bag: translate().clothes,
      Icons.local_phone: translate().connection,
      Icons.medical_services: translate().health,
      Icons.beach_access: translate().cosmetics,
    };
  }
}
