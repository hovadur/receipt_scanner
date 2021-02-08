
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
///   intl: any # Use the pinned version from flutter_localizations
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  // ignore: unused_field
  final String localeName;

  static AppLocalizations? of(BuildContext context) {
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

  /// Checking The Receipt
  ///
  /// In en, this message translates to:
  /// **'Checking The Receipt'**
  String get appTitle;

  /// Sign In
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Sign Out
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Invalid email
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// Invalid INN
  ///
  /// In en, this message translates to:
  /// **'Invalid INN'**
  String get invalidInn;

  /// Invalid credentials
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredentials;

  /// Password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Invalid password
  ///
  /// In en, this message translates to:
  /// **'Must be > 7 characters'**
  String get invalidPassword;

  /// Continue
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get cont;

  /// Sign in with Google
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// Don’t have an account?
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? '**
  String get dontHaveAccount;

  /// Sign Up
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// To get the contents of the check, log in to your 
  ///
  /// In en, this message translates to:
  /// **'To get the contents of the check, log in to your '**
  String get dontHaveFnsAccount;

  /// nalog.ru account
  ///
  /// In en, this message translates to:
  /// **'nalog.ru account'**
  String get nalogruAccount;

  /// Confirm password
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// Invalid confirm password
  ///
  /// In en, this message translates to:
  /// **'Invalid confirm password'**
  String get invalidConfirmPassword;

  /// Scanning
  ///
  /// In en, this message translates to:
  /// **'Scanning'**
  String get scanning;

  /// Initializing Camera...
  ///
  /// In en, this message translates to:
  /// **'Initializing Camera...'**
  String get cameraInit;

  /// My Receipt
  ///
  /// In en, this message translates to:
  /// **'My Receipts'**
  String get myReceipts;

  /// Not authorized
  ///
  /// In en, this message translates to:
  /// **'Not authorized'**
  String get notAuthorized;

  /// Manual input
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// From file
  ///
  /// In en, this message translates to:
  /// **'From file'**
  String get fromFile;

  /// Add Product
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// Product
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// Total
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalAmount;

  /// Invalid total
  ///
  /// In en, this message translates to:
  /// **'Invalid total'**
  String get totalError;

  /// Invalid quantity
  ///
  /// In en, this message translates to:
  /// **'Invalid quantity'**
  String get qtyError;

  /// Sum
  ///
  /// In en, this message translates to:
  /// **'Sum'**
  String get sum;

  /// Invalid sum
  ///
  /// In en, this message translates to:
  /// **'Invalid sum'**
  String get sumError;

  /// Apply
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Warning
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Categories
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Food
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Transport
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// Entertainment
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// Clothes
  ///
  /// In en, this message translates to:
  /// **'Clothes'**
  String get clothes;

  /// Connection
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection;

  /// Health
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// Cosmetics
  ///
  /// In en, this message translates to:
  /// **'Cosmetics'**
  String get cosmetics;

  /// Details
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// set a category for everyone
  ///
  /// In en, this message translates to:
  /// **'set a category for everyone'**
  String get categoryAll;

  /// qty
  ///
  /// In en, this message translates to:
  /// **'qty'**
  String get qty;

  /// Qty
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qtyy;

  /// Purchase date
  ///
  /// In en, this message translates to:
  /// **'Purchase date'**
  String get dateTime;

  /// Storage
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// Document
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// Document attribute
  ///
  /// In en, this message translates to:
  /// **'Document attribute'**
  String get documentAttribute;

  /// Total
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// FNS Account
  ///
  /// In en, this message translates to:
  /// **'FNS Account'**
  String get fnsAccount;

  /// INN
  ///
  /// In en, this message translates to:
  /// **'INN'**
  String get inn;

  /// Check receipt in FNS
  ///
  /// In en, this message translates to:
  /// **'Check receipt in FNS'**
  String get checkReceiptInFNS;

  /// Data received from the FNS
  ///
  /// In en, this message translates to:
  /// **'Data received from the FNS'**
  String get dataReceivedFromFNS;

  /// TIN and password are not saved. Only the session is stored. Sometimes you may need to log into your FTS account again to update the session
  ///
  /// In en, this message translates to:
  /// **'TIN and password are not saved. Only the session is stored. Sometimes you may need to log into your FTS account again to update the session'**
  String get ftsWarning;

  /// Search...
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// Delete...
  ///
  /// In en, this message translates to:
  /// **'Delete...'**
  String get deleteEllipsis;

  /// Delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete Confirmation
  ///
  /// In en, this message translates to:
  /// **'Delete Confirmation'**
  String get deleteConfirmation;

  /// Are you sure you want to delete this item?
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get sureDelete;

  /// Something went wrong
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get wentWrong;

  /// Budgets
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// Personal
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// Cannot be deleted
  ///
  /// In en, this message translates to:
  /// **'Cannot be deleted'**
  String get cantBeDeleted;

  /// Add Budget
  ///
  /// In en, this message translates to:
  /// **'Add Budget'**
  String get addBudget;

  /// Create a new budget
  ///
  /// In en, this message translates to:
  /// **'Create a new budget'**
  String get createNewBudget;

  /// Come up with a name for your budget.
  ///
  /// In en, this message translates to:
  /// **'Come up with a name for your budget.'**
  String get comeUpBudget;

  /// For example 'Family'.
  ///
  /// In en, this message translates to:
  /// **'For example \'Family\'.'**
  String get forExampleBudget;

  /// Budget name
  ///
  /// In en, this message translates to:
  /// **'Budget name'**
  String get budgetName;

  /// Starting balance
  ///
  /// In en, this message translates to:
  /// **'Starting balance'**
  String get startingBalance;

  /// If you receive an electronic check, then take a screenshot of the place where the QR code is and upload the file
  ///
  /// In en, this message translates to:
  /// **'If you receive an electronic check, then take a screenshot of the place where the QR code is and upload the file'**
  String get emailCheque;

  /// Upload file
  ///
  /// In en, this message translates to:
  /// **'Upload file'**
  String get uploadFile;

  /// Process file
  ///
  /// In en, this message translates to:
  /// **'Process file'**
  String get processFile;

  /// No file
  ///
  /// In en, this message translates to:
  /// **'No file'**
  String get noFile;

  /// Invalid barcode
  ///
  /// In en, this message translates to:
  /// **'Invalid barcode'**
  String get invalidBarcode;

  /// From barcode parameters
  ///
  /// In en, this message translates to:
  /// **'From parameters'**
  String get fromParam;

  /// Invalid data
  ///
  /// In en, this message translates to:
  /// **'Invalid data'**
  String get invalidData;

  /// Too many requests
  ///
  /// In en, this message translates to:
  /// **'Too many requests to FNS'**
  String get tooManyRequests;

  /// Copying
  ///
  /// In en, this message translates to:
  /// **'Copying'**
  String get copying;

  /// Date
  ///
  /// In en, this message translates to:
  /// **'Дата'**
  String get date;

  /// For all the time
  ///
  /// In en, this message translates to:
  /// **'For all the time'**
  String get forAllTheTime;

  /// For the current month
  ///
  /// In en, this message translates to:
  /// **'For the current month'**
  String get forTheCurrentMonth;

  /// For the previous month
  ///
  /// In en, this message translates to:
  /// **'For the previous month'**
  String get forThePreviousMonth;

  /// For the last week
  ///
  /// In en, this message translates to:
  /// **'For the last week'**
  String get forTheLastWeek;

  /// For the last 3 days
  ///
  /// In en, this message translates to:
  /// **'For the last 3 days'**
  String get forTheLast3Days;

  /// Select date
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;
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


  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
