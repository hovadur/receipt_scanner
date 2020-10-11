import 'package:flutter/material.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        // Add the `localizationsDelegate` and `supportedLocales` lines.
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)),
        darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)),
        home: Navigator(pages: [
          MaterialPage(child: SignInScreen(() {
            debugDumpApp();
          })),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;
          return true;
        }));
  }
}

class SignInScreen extends StatelessWidget {
  SignInScreen(this.onTapped);

  final GestureTapCallback onTapped;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // https://stackoverflow.com/a/32686261/9449426
    final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).signIn)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(hintText: AppLocalizations.of(context).email),
                      validator: (String value) {
                        if (value != null && !email.hasMatch(value)) {
                          return AppLocalizations.of(context).invalidEmail;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: AppLocalizations.of(context).password),
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
                          onPressed: () {
                            if (_formKey.currentState?.validate() == false) {
                              return null;
                            }
                          },
                          child: Text(AppLocalizations.of(context).next),
                        ),
                      ),
                    )
                  ],
                )),
            SignInButton(
                btnText: AppLocalizations.of(context).signInWithGoogle,
                buttonType: ButtonType.google,
                onPressed: () {}),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).dontHaveAccount,
                ),
                InkWell(
                  onTap: () => onTapped(),
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
