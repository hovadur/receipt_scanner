import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Listener, Provider;
import 'package:shared_preferences/shared_preferences.dart';

import 'app_module.dart';
import 'domain/data/repo/settings_repo.dart';
import 'domain/navigation/app_navigator.dart';
import 'presentation/myreceipts/my_receipts_screen.dart';

Future<void> main() async {
  Fimber.plantTree(DebugTree());
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings();
  final prefs = await SharedPreferences.getInstance();
  runApp(EasyLocalization(
      supportedLocales: [const Locale('en', 'US'), const Locale('ru', 'RU')],
      path: 'assets/translations',
      // <-- change the path of the translation files
      fallbackLocale: const Locale('en', 'US'),
      child: ProviderScope(
          overrides: [settingsRepo.overrideWithValue(SettingsRepo(prefs))],
          child: MyApp())));
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
    const Page _defaultHome = MaterialPage<Page>(
        name: MyReceiptsScreen.routeName, child: MyReceiptsScreen());

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
            title: 'Receipt Scanner',
            onGenerateTitle: (context) => 'appTitle'.tr(),
            // Add the `localizationsDelegate` and `supportedLocales` lines.
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
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
