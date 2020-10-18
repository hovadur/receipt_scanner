import 'package:ctr/screens/camera/camera_screen.dart';
import 'package:ctr/screens/signin/signin_screen.dart';
import 'package:fimber/fimber_base.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'domain/navigation/app_navigator.dart';
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
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    Page _defaultHome =
        MaterialPage(name: SignInScreen.routeName, child: SignInScreen());
    if (auth.FirebaseAuth.instance.currentUser != null) {
      _defaultHome =
          MaterialPage(name: CameraScreen.routeName, child: CameraScreen());
    }

    return MaterialApp(
        builder: (BuildContext context, Widget child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(
                textScaleFactor:
                    data.textScaleFactor < 1.1 ? 1.1 : data.textScaleFactor),
            child: AppNavigator(
              navigatorKey: _navigatorKey,
              initialPages: [_defaultHome],
            ),
          );
        },
        title: "Checking The Receipt",
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        // Add the `localizationsDelegate` and `supportedLocales` lines.
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)),
        darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)),
        navigatorKey: _navigatorKey,
        onGenerateRoute: (_) => null);
  }
}
