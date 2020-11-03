import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/signup/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:websafe_svg/websafe_svg.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key key}) : super(key: key);
  static const String routeName = 'SignUpScreen';

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).signUp)),
      body: ChangeNotifierProvider(
          create: (_) => SignUpViewModel(),
          builder: (context, _) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const LoginForm(),
                    ElevatedButton.icon(
                        onPressed: () => context.googleSignIn(),
                        icon: WebsafeSvg.asset('assets/icons/google-icon.svg'),
                        label:
                            Text(AppLocalizations.of(context).signInWithGoogle),
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xfff7f7f7),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18))))
                  ],
                ),
              )));
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).email,
                errorText: context
                    .select((SignUpViewModel value) => value.emailError)),
            onChanged: (String value) =>
                context.read<SignUpViewModel>().changeEmail(value, context),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            textInputAction: TextInputAction.next,
            onSubmitted: (String value) =>
                context.read<SignUpViewModel>().submit(context),
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).password,
                errorText: context
                    .select((SignUpViewModel value) => value.passwordError)),
            onChanged: (String value) =>
                context.read<SignUpViewModel>().changePassword(value, context),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (String value) => submit(context),
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).confirmPassword,
                errorText: context.select(
                    (SignUpViewModel value) => value.confirmPasswordError)),
            onChanged: (String value) => context
                .read<SignUpViewModel>()
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
                child: Text(AppLocalizations.of(context).next),
              ),
            ),
          )
        ],
      );

  void submit(BuildContext context) {
    context.read<SignUpViewModel>().submit(context);
  }
}
