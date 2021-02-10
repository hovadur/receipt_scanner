import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_module.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/common/context_ext.dart';

class SignInFnsScreen extends StatelessWidget {
  const SignInFnsScreen({required this.onPressed, Key? key}) : super(key: key);
  static const String routeName = 'SignInFnsScreen';

  final Function onPressed;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(context.translate().fnsAccount)),
      body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(context.translate().ftsWarning),
              LoginForm(onPressed: onPressed),
            ],
          )));
}

class LoginForm extends ConsumerWidget {
  const LoginForm({required this.onPressed, Key? key}) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context, ScopedReader watch) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            keyboardType: const TextInputType.numberWithOptions(),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: context.translate().inn,
                errorText: watch(signInFnsNotifier).innError),
            onChanged: (String value) =>
                context.read(signInFnsNotifier).changeEmail(value, context),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (String value) => submit(context),
            decoration: InputDecoration(
                labelText: context.translate().password,
                errorText: watch(signInFnsNotifier).passwordError),
            onChanged: (String value) =>
                context.read(signInFnsNotifier).changePassword(value, context),
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
    context.read(signInFnsNotifier).submit(context).then((value) {
      if (value) {
        onPressed();
        AppNavigator.of(context).pop();
      } else {
        context.showError(context.translate().invalidCredentials);
      }
    });
  }
}
