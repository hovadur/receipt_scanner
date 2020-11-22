import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/camera/camera_screen.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:fimber/fimber_base.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart' hide Listener, Provider;

Future<void> main() async {
  Fimber.plantTree(DebugTree());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
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
    const Page _defaultHome =
        MaterialPage<Page>(name: CameraScreen.routeName, child: CameraScreen());

    return Listener(
        onPointerDown: (_) {
          WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
        },
        child: MaterialApp(
            builder: (BuildContext context, Widget? child) {
              final data = MediaQuery.of(context);
              return MediaQuery(
                data: data.copyWith(
                    textScaleFactor: data.textScaleFactor < 1.1
                        ? 1.1
                        : data.textScaleFactor),
                child: AppNavigator(
                  navigatorKey: _navigatorKey,
                  initialPages: [_defaultHome],
                ),
              );
            },
            title: 'Checking The Receipt',
            onGenerateTitle: (context) => context.translate().appTitle,
            // Add the `localizationsDelegate` and `supportedLocales` lines.
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData.light().copyWith(
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.orange)),
            darkTheme: ThemeData.dark().copyWith(
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.orange)),
            navigatorKey: _navigatorKey,
            onGenerateRoute: (_) => null));
  }
}
