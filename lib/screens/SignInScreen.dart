import 'package:ctr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({@required this.onContinue, @required this.onSignUp});

  final GestureTapCallback onContinue;
  final GestureTapCallback onSignUp;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).signIn)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
        child: Column(
          children: [
            SizedBox(height: 40),
            LoginForm(),
            ElevatedButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset("assets/icons/google-icon.svg"),
                label: Text(AppLocalizations.of(context).signInWithGoogle),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xfff7f7f7),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)))),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).dontHaveAccount,
                ),
                InkWell(
                  onTap: () => onSignUp(),
                  child: Text(
                    AppLocalizations.of(context).signUp,
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            )
          ],
        ),
      ));
}

class LoginForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState?.validate() == false) {
      return null;
    }
    print("_submit");
  }

  // https://stackoverflow.com/a/32686261/9449426
  final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  @override
  Widget build(BuildContext context) => Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration:
                InputDecoration(labelText: AppLocalizations.of(context).email),
            validator: (String value) {
              if (value != null && !email.hasMatch(value)) {
                return AppLocalizations.of(context).invalidEmail;
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            obscureText: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (String value) => _submit(),
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).password),
            validator: (String value) {
              if (value != null && value.length < 8) {
                return AppLocalizations.of(context).invalidPassword;
              }
              return null;
            },
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                autofocus: true,
                onPressed: () => _submit(),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
                ),
                child: Text(AppLocalizations.of(context).next),
              ),
            ),
          )
        ],
      ));
}
