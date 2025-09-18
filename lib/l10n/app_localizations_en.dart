// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Havenote';

  @override
  String get actionSignIn => 'Sign In';

  @override
  String get actionSignUp => 'Sign Up';

  @override
  String get actionLogout => 'Sign Out';

  @override
  String get actionOk => 'OK';

  @override
  String get actionSave => 'Save';

  @override
  String get actionSaved => 'Saved';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionShow => 'Show';

  @override
  String get actionHide => 'Hide';

  @override
  String get labelEmail => 'Email';

  @override
  String get labelPassword => 'Password';

  @override
  String get labelForgotPassword => 'Forgot password?';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get authErrorInvalidEmail => 'Enter a valid email address.';

  @override
  String get authErrorInvalidPassword => 'Enter a valid password';

  @override
  String get authErrorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get authErrorUserDisabled => 'This account is disabled.';

  @override
  String get authErrorEmailInUse => 'An account already exists with this email.';

  @override
  String get authErrorWeakPassword => 'Your password is too weak.';

  @override
  String get authErrorTooManyRequests => 'Too many attempts. Try again later.';

  @override
  String get authErrorOperationNotAllowed => 'This sign-in method is not enabled.';

  @override
  String get authErrorNetworkRequestFailed => 'Network error. Check your connection.';

  @override
  String get authPasswordRulesTitle => 'Your password must include:';

  @override
  String get authPasswordRuleMinLength => 'At least 8 characters';

  @override
  String get authPasswordRuleUpper => 'An uppercase letter (A–Z)';

  @override
  String get authPasswordRuleLower => 'A lowercase letter (a–z)';

  @override
  String get authPasswordRuleDigit => 'A number (0–9)';

  @override
  String get authPasswordRuleSpecial => 'A symbol (!@#\\\$%^&*…)';

  @override
  String get authPasswordRuleMatch => 'Passwords match';

  @override
  String get authPasswordStrength => 'Strength:';

  @override
  String get authPasswordWeak => 'Weak';

  @override
  String get authPasswordMedium => 'Medium';

  @override
  String get authPasswordStrong => 'Strong';

  @override
  String get authForgotTitle => 'Reset Password';

  @override
  String get authForgotSubtitle => 'Enter your email and we’ll send a reset link.';

  @override
  String get authForgotSend => 'Send reset link';

  @override
  String get authForgotBack => 'Back to Sign In';

  @override
  String get authForgotSuccess => 'If an account exists, we’ve sent a reset email.';

  @override
  String get authSignUpTitle => 'Create Account';

  @override
  String get authSignUpSubtitle => 'Fill in the details to get started.';

  @override
  String get authSignUpConfirmPasswordLabel => 'Confirm password';

  @override
  String get authSignUpButton => 'Sign Up';

  @override
  String get authSignUpToSignIn => 'Already have an account? Sign in';

  @override
  String get authVerifyTitle => 'Verify your email';

  @override
  String authVerifyBody(Object email) {
    return 'We sent a verification link to $email. Open the link, then return here.';
  }

  @override
  String get authVerifyIveVerified => 'I’ve verified';

  @override
  String get authVerifyAlreadyVerified => 'Your email is already verified.';

  @override
  String get authVerifyResend => 'Resend email';

  @override
  String get authVerifyResent => 'Verification email sent';

  @override
  String get authVerifyChecking => 'Checking…';

  @override
  String get authVerifyNotVerified => 'Not verified yet. Check your inbox.';

  @override
  String authVerifyWait(num secs) {
    String _temp0 = intl.Intl.pluralLogic(
      secs,
      locale: localeName,
      other: '$secs seconds',
      one: '1 second',
    );
    return 'Please wait $_temp0 before resending';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSignOutConfirmTitle => 'Sign out?';

  @override
  String get settingsSignOutConfirmBody => 'You will need to sign in again to access your notes.';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsDeleteAccountSubtitle => 'Deletes your account and all notes';

  @override
  String get settingsDeleteConfirmTitle => 'Delete account?';

  @override
  String get settingsDeleteConfirmBody => 'This will permanently delete your account and all notes, including images. This action cannot be undone.';

  @override
  String get settingsDeleteSuccess => 'Your account has been deleted.';

  @override
  String get settingsDeleteRequiresReauthentication => 'Please reauthenticate and try again (sign out, sign in, then delete).';

  @override
  String get authReauthTitle => 'Reauthenticate';

  @override
  String get authReauthSubtitle => 'For your security, please confirm your password.';

  @override
  String get authReauthConfirm => 'Confirm';

  @override
  String get authReauthSuccess => 'Reauthenticated';

  @override
  String get authReauthNeeded => 'Please reauthenticate to continue.';
}
