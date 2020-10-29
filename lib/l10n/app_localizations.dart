
import 'dart:async';

// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: 0.16.1
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : assert(locale != null), localeName = intl.Intl.canonicalizedLocale(locale.toString());

  // ignore: unused_field
  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  // Checking The Receipt
  String get appTitle;

  // Sign In
  String get signIn;

  // Sign Out
  String get signOut;

  // Email
  String get email;

  // Invalid email
  String get invalidEmail;

  // Password
  String get password;

  // Invalid password
  String get invalidPassword;

  // Continue
  String get next;

  // Sign in with Google
  String get signInWithGoogle;

  // Don’t have an account?
  String get dontHaveAccount;

  // Sign Up
  String get signUp;

  // Confirm password
  String get confirmPassword;

  // Invalid confirm password
  String get invalidConfirmPassword;

  // Scanning
  String get scanning;

  // Initializing Camera...
  String get cameraInit;

  // My Receipt
  String get myReceipts;

  // Not authorized
  String get notAuthorized;

  // Manual input
  String get manual;

  // Add Product
  String get addProduct;

  // Product
  String get product;

  // Total
  String get totalAmount;

  // Invalid total
  String get totalError;

  // Invalid quantity
  String get qtyError;

  // Sum
  String get sum;

  // Apply
  String get apply;

  // Warning
  String get warning;

  // Close
  String get close;

  // Categories
  String get categories;

  // Food
  String get food;

  // Home
  String get home;

  // Transport
  String get transport;

  // Entertainment
  String get entertainment;

  // Clothes
  String get clothes;

  // Connection
  String get connection;

  // Health
  String get health;

  // Cosmetics
  String get cosmetics;

  // Details
  String get details;

  // set a category for everyone
  String get categoryAll;

  // qty
  String get qty;

  // Qty
  String get qtyy;

  // Date
  String get dateTime;

  // Storage
  String get storage;

  // Document
  String get document;

  // Document attribute
  String get documentAttribute;

  // Total
  String get total;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(_lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations _lookupAppLocalizations(Locale locale) {
  
  
  
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  assert(false, 'AppLocalizations.delegate failed to load unsupported locale "$locale"');
  return null;
}
