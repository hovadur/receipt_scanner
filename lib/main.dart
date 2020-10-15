import 'package:ctr/screens/signin/signin_screen.dart';
import 'package:ctr/screens/signup/signup_screen.dart';
import 'package:fimber/fimber_base.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

void main() async {
  Fimber.plantTree(DebugTree());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignUp = false;
  bool isContinue = false;

  @override
  Widget build(BuildContext context) => MaterialApp(
      builder: (BuildContext context, Widget child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
              textScaleFactor:
                  data.textScaleFactor < 1.1 ? 1.1 : data.textScaleFactor),
          child: child,
        );
      },
      title: "Checking The Receipt",
      // Add the `localizationsDelegate` and `supportedLocales` lines.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.light().copyWith(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)),
      darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)),
      home: Navigator(
          pages: [
            MaterialPage(
                key: ValueKey("SignInScreen"),
                child: SignInScreen(
                    onContinue: () => setState(() => isContinue = true),
                    onSignUp: () => setState(() => isSignUp = true))),
            if (isSignUp)
              MaterialPage(
                  key: ValueKey("SignUpScreen"),
                  child: SignUpScreen(
                      onContinue: () => setState(() => isContinue = true)))
          ],
          onPopPage: (route, result) {
            Fimber.d("asdf");
            if (!route.didPop(result)) return false;
            if (isSignUp) setState(() => isSignUp = false);
            return true;
          }));
}
