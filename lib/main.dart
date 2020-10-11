import 'package:ctr/screens/SignInScreen.dart';
import 'package:ctr/screens/SignUpScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignIn = false;

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Demo',
      // Add the `localizationsDelegate` and `supportedLocales` lines.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.light().copyWith(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
          textTheme: TextTheme(
              subtitle1: TextStyle(fontSize: 20),
              bodyText2: TextStyle(fontSize: 20),
              button: TextStyle(fontSize: 20))),
      darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
          textTheme: TextTheme(
              subtitle1: TextStyle(fontSize: 20),
              bodyText2: TextStyle(fontSize: 20),
              button: TextStyle(fontSize: 20))),
      home: Navigator(
          pages: [
            MaterialPage(
                key: ValueKey("SignInScreen"),
                child: SignInScreen(
                    onSignUp: () => setState(() => isSignIn = true))),
            if (isSignIn)
              MaterialPage(key: ValueKey("SignUpScreen"), child: SignUpScreen())
          ],
          onPopPage: (route, result) {
            print("asdf");
            if (!route.didPop(result)) return false;
            if (isSignIn) setState(() => isSignIn = false);
            return true;
          }));
}
