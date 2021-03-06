import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:receipt_scanner/presentation/myreceipts/my_receipts_screen.dart';

import '../../app_module.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/camera/camera_screen.dart';
import '../../presentation/common/context_ext.dart';
import '../../presentation/signup/signup_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static const String routeName = 'SignInScreen';

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('signIn').tr()),
      body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const LoginForm(),
              ElevatedButton.icon(
                  onPressed: () => googleSignIn(context),
                  icon: SvgPicture.asset('assets/icons/google-icon.svg'),
                  label: const Text('signInWithGoogle').tr(),
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xfff7f7f7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('dontHaveAccount').tr(),
                  InkWell(
                    onTap: () {
                      AppNavigator.of(context).push(const MaterialPage<Page>(
                          name: SignUpScreen.routeName, child: SignUpScreen()));
                    },
                    child: Text(
                      'signUp'.tr(),
                      style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              )
            ],
          )));

  void googleSignIn(BuildContext context) {
    context.read(signInNotifier).googleSignIn().then((value) {
      if (value) {
        AppNavigator.of(context).clearAndPush(const MaterialPage<Page>(
            name: MyReceiptsScreen.routeName, child: MyReceiptsScreen()));
      }
    }).catchError((e) {
      context.showError(e.message);
      Fimber.e(e.toString());
    }, test: (e) => e is Exception);
  }
}

class LoginForm extends ConsumerWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: 'email'.tr(),
                errorText: watch(signInNotifier).emailError),
            onChanged: (String value) =>
                context.read(signInNotifier).changeEmail(value),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (String value) => submit(context),
            decoration: InputDecoration(
                labelText: 'password'.tr(),
                errorText: watch(signInNotifier).passwordError),
            onChanged: (String value) =>
                context.read(signInNotifier).changePassword(value),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                autofocus: true,
                onPressed: () => submit(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 4.0),
                ),
                child: const Text('cont').tr(),
              ),
            ),
          )
        ],
      );

  void submit(BuildContext context) {
    context.read(signInNotifier).submit().then((_) {
      AppNavigator.of(context).clearAndPush(const MaterialPage<Page>(
          name: CameraScreen.routeName, child: CameraScreen()));
    }).catchError((e) {
      context.showError(e.message);
      Fimber.e(e.toString());
    }, test: (e) => e is Exception);
  }
}
