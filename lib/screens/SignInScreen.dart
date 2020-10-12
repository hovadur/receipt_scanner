import 'package:flutter/material.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({@required this.onSignUp});

  final GestureTapCallback onSignUp;
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    if (_formKey.currentState?.validate() == false) {
      return null;
    }
    print("_submit");
  }

  @override
  Widget build(BuildContext context) {
    // https://stackoverflow.com/a/32686261/9449426
    final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).signIn)),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context).email),
                      validator: (String value) {
                        if (value != null && !email.hasMatch(value)) {
                          return AppLocalizations.of(context).invalidEmail;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (String value) => _submit(),
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context).password),
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
                          child: Text(AppLocalizations.of(context).next),
                        ),
                      ),
                    )
                  ],
                )),
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
      ),
    );
  }
}
