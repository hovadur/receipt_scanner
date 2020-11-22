import 'package:ctr/presentation/common/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../app_module.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const String routeName = 'SignUpScreen';

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(context.translate().signUp)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const LoginForm(),
            ElevatedButton.icon(
                onPressed: () => context.googleSignIn(),
                icon: WebsafeSvg.asset('assets/icons/google-icon.svg'),
                label: Text(context.translate().signInWithGoogle),
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xfff7f7f7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18))))
          ],
        ),
      ));
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
                labelText: context.translate().email,
                errorText: watch(signUpNotifier).emailError),
            onChanged: (String value) =>
                context.read(signUpNotifier).changeEmail(value, context),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            textInputAction: TextInputAction.next,
            onSubmitted: (String value) =>
                context.read(signUpNotifier).submit(context),
            decoration: InputDecoration(
                labelText: context.translate().password,
                errorText: watch(signUpNotifier).passwordError),
            onChanged: (String value) =>
                context.read(signUpNotifier).changePassword(value, context),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (String value) => submit(context),
            decoration: InputDecoration(
                labelText: context.translate().confirmPassword,
                errorText: watch(signUpNotifier).confirmPasswordError),
            onChanged: (String value) => context
                .read(signUpNotifier)
                .changeConfirmPassword(value, context),
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
                child: Text(context.translate().cont),
              ),
            ),
          )
        ],
      );

  void submit(BuildContext context) {
    context.read(signUpNotifier).submit(context);
  }
}
