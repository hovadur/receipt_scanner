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
      builder: (BuildContext context, Widget child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
              textScaleFactor:
                  data.textScaleFactor < 1.1 ? 1.1 : data.textScaleFactor),
          child: child,
        );
      },
      title: 'Flutter Demo',
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
