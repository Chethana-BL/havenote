import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
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
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

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
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Havenote'**
  String get appTitle;

  /// No description provided for @actionSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get actionSignIn;

  /// No description provided for @actionSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get actionSignUp;

  /// No description provided for @actionLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get actionLogout;

  /// No description provided for @actionOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get actionSaved;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get actionShow;

  /// No description provided for @actionHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get actionHide;

  /// No description provided for @labelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get labelEmail;

  /// No description provided for @labelPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get labelPassword;

  /// No description provided for @labelForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get labelForgotPassword;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorInvalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid password'**
  String get authErrorInvalidPassword;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account is disabled.'**
  String get authErrorUserDisabled;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Your password is too weak.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorOperationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'This sign-in method is not enabled.'**
  String get authErrorOperationNotAllowed;

  /// No description provided for @authErrorNetworkRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your connection.'**
  String get authErrorNetworkRequestFailed;

  /// No description provided for @authPasswordRulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your password must include:'**
  String get authPasswordRulesTitle;

  /// No description provided for @authPasswordRuleMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get authPasswordRuleMinLength;

  /// No description provided for @authPasswordRuleUpper.
  ///
  /// In en, this message translates to:
  /// **'An uppercase letter (A–Z)'**
  String get authPasswordRuleUpper;

  /// No description provided for @authPasswordRuleLower.
  ///
  /// In en, this message translates to:
  /// **'A lowercase letter (a–z)'**
  String get authPasswordRuleLower;

  /// No description provided for @authPasswordRuleDigit.
  ///
  /// In en, this message translates to:
  /// **'A number (0–9)'**
  String get authPasswordRuleDigit;

  /// No description provided for @authPasswordRuleSpecial.
  ///
  /// In en, this message translates to:
  /// **'A symbol (!@#\\\$%^&*…)'**
  String get authPasswordRuleSpecial;

  /// No description provided for @authPasswordRuleMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords match'**
  String get authPasswordRuleMatch;

  /// No description provided for @authPasswordStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength:'**
  String get authPasswordStrength;

  /// No description provided for @authPasswordWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get authPasswordWeak;

  /// No description provided for @authPasswordMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get authPasswordMedium;

  /// No description provided for @authPasswordStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get authPasswordStrong;

  /// No description provided for @authForgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authForgotTitle;

  /// No description provided for @authForgotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we’ll send a reset link.'**
  String get authForgotSubtitle;

  /// No description provided for @authForgotSend.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get authForgotSend;

  /// No description provided for @authForgotBack.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get authForgotBack;

  /// No description provided for @authForgotSuccess.
  ///
  /// In en, this message translates to:
  /// **'If an account exists, we’ve sent a reset email.'**
  String get authForgotSuccess;

  /// No description provided for @authSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authSignUpTitle;

  /// No description provided for @authSignUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in the details to get started.'**
  String get authSignUpSubtitle;

  /// No description provided for @authSignUpConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authSignUpConfirmPasswordLabel;

  /// No description provided for @authSignUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUpButton;

  /// No description provided for @authSignUpToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get authSignUpToSignIn;

  /// No description provided for @authVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get authVerifyTitle;

  /// No description provided for @authVerifyBody.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification link to {email}. Open the link, then return here.'**
  String authVerifyBody(Object email);

  /// No description provided for @authVerifyIveVerified.
  ///
  /// In en, this message translates to:
  /// **'I’ve verified'**
  String get authVerifyIveVerified;

  /// No description provided for @authVerifyAlreadyVerified.
  ///
  /// In en, this message translates to:
  /// **'Your email is already verified.'**
  String get authVerifyAlreadyVerified;

  /// No description provided for @authVerifyResend.
  ///
  /// In en, this message translates to:
  /// **'Resend email'**
  String get authVerifyResend;

  /// No description provided for @authVerifyResent.
  ///
  /// In en, this message translates to:
  /// **'Verification email sent'**
  String get authVerifyResent;

  /// No description provided for @authVerifyChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get authVerifyChecking;

  /// No description provided for @authVerifyNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified yet. Check your inbox.'**
  String get authVerifyNotVerified;

  /// No description provided for @authVerifyWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait {secs, plural, one {1 second} other {{secs} seconds}} before resending'**
  String authVerifyWait(num secs);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get settingsDisplayName;

  /// No description provided for @settingsSignOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get settingsSignOutConfirmTitle;

  /// No description provided for @settingsSignOutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to access your notes.'**
  String get settingsSignOutConfirmBody;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deletes your account and all notes'**
  String get settingsDeleteAccountSubtitle;

  /// No description provided for @settingsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get settingsDeleteConfirmTitle;

  /// No description provided for @settingsDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and all notes, including images. This action cannot be undone.'**
  String get settingsDeleteConfirmBody;

  /// No description provided for @settingsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted.'**
  String get settingsDeleteSuccess;

  /// No description provided for @settingsDeleteRequiresReauthentication.
  ///
  /// In en, this message translates to:
  /// **'Please reauthenticate and try again (sign out, sign in, then delete).'**
  String get settingsDeleteRequiresReauthentication;

  /// No description provided for @authReauthTitle.
  ///
  /// In en, this message translates to:
  /// **'Reauthenticate'**
  String get authReauthTitle;

  /// No description provided for @authReauthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For your security, please confirm your password.'**
  String get authReauthSubtitle;

  /// No description provided for @authReauthConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get authReauthConfirm;

  /// No description provided for @authReauthSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reauthenticated'**
  String get authReauthSuccess;

  /// No description provided for @authReauthNeeded.
  ///
  /// In en, this message translates to:
  /// **'Please reauthenticate to continue.'**
  String get authReauthNeeded;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return SDe();
    case 'en': return SEn();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
