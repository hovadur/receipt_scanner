import 'package:ctr/screens/signin/signin_screen.dart';
import 'package:ctr/screens/signin/signin_viewmodel.dart';
import 'package:ctr/screens/signup/signup_screen.dart';
import 'package:ctr/screens/signup/signup_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';

void main() {
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
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SignInViewModel()),
            ChangeNotifierProvider(create: (_) => SignUpViewModel()),
          ],
          child: MaterialApp(
              builder: (BuildContext context, Widget child) {
                final MediaQueryData data = MediaQuery.of(context);
                return MediaQuery(
                  data: data.copyWith(
                      textScaleFactor: data.textScaleFactor < 1.1
                          ? 1.1
                          : data.textScaleFactor),
                  child: child,
                );
              },
              title: "Checking The Receipt",
              // Add the `localizationsDelegate` and `supportedLocales` lines.
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData.light().copyWith(
                  colorScheme:
                      ColorScheme.fromSwatch(primarySwatch: Colors.orange)),
              darkTheme: ThemeData.dark().copyWith(
                  colorScheme:
                      ColorScheme.fromSwatch(primarySwatch: Colors.orange)),
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
                              onContinue: () =>
                                  setState(() => isContinue = true)))
                  ],
                  onPopPage: (route, result) {
                    print("asdf");
                    if (!route.didPop(result)) return false;
                    if (isSignUp) setState(() => isSignUp = false);
                    return true;
                  })));
}
