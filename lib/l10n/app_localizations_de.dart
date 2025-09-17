// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class SDe extends S {
  SDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Havenote';

  @override
  String get actionSignIn => 'Anmelden';

  @override
  String get actionSignUp => 'Registrieren';

  @override
  String get actionLogout => 'Abmelden';

  @override
  String get actionShow => 'Anzeigen';

  @override
  String get actionHide => 'Ausblenden';

  @override
  String get labelEmail => 'E-Mail';

  @override
  String get labelPassword => 'Passwort';

  @override
  String get labelForgotPassword => 'Passwort vergessen?';

  @override
  String get errorGeneric => 'Etwas ist schiefgelaufen';

  @override
  String get authErrorInvalidEmail => 'Bitte eine gültige E-Mail-Adresse eingeben.';

  @override
  String get authErrorInvalidPassword => 'Bitte ein gültiges Passwort eingeben.';

  @override
  String get authErrorInvalidCredentials => 'E-Mail oder Passwort ist falsch.';

  @override
  String get authErrorUserDisabled => 'Dieses Konto ist deaktiviert.';

  @override
  String get authErrorEmailInUse => 'Mit dieser E-Mail existiert bereits ein Konto.';

  @override
  String get authErrorWeakPassword => 'Das Passwort ist zu schwach.';

  @override
  String get authErrorTooManyRequests => 'Zu viele Versuche. Bitte später erneut versuchen.';

  @override
  String get authErrorOperationNotAllowed => 'Diese Anmeldemethode ist nicht aktiviert.';

  @override
  String get authErrorNetworkRequestFailed => 'Netzwerkfehler. Bitte Verbindung prüfen.';

  @override
  String get authPasswordRulesTitle => 'Ihr Passwort muss Folgendes enthalten:';

  @override
  String get authPasswordRuleMinLength => 'Mindestens 8 Zeichen';

  @override
  String get authPasswordRuleUpper => 'Einen Großbuchstaben (A–Z)';

  @override
  String get authPasswordRuleLower => 'Einen Kleinbuchstaben (a–z)';

  @override
  String get authPasswordRuleDigit => 'Eine Zahl (0–9)';

  @override
  String get authPasswordRuleSpecial => 'Ein Sonderzeichen (!@#\\\$%^&*…)';

  @override
  String get authPasswordRuleMatch => 'Passwörter stimmen überein';

  @override
  String get authPasswordStrength => 'Stärke:';

  @override
  String get authPasswordWeak => 'Schwach';

  @override
  String get authPasswordMedium => 'Mittel';

  @override
  String get authPasswordStrong => 'Stark';

  @override
  String get authForgotTitle => 'Passwort zurücksetzen';

  @override
  String get authForgotSubtitle => 'Geben Sie Ihre E-Mail ein, wir senden Ihnen einen Link zum Zurücksetzen.';

  @override
  String get authForgotSend => 'Link senden';

  @override
  String get authForgotBack => 'Zur Anmeldung';

  @override
  String get authForgotSuccess => 'Falls ein Konto existiert, haben wir eine E-Mail zum Zurücksetzen gesendet.';

  @override
  String get authSignUpTitle => 'Konto erstellen';

  @override
  String get authSignUpSubtitle => 'Füllen Sie die Angaben aus, um zu starten.';

  @override
  String get authSignUpConfirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get authSignUpButton => 'Registrieren';

  @override
  String get authSignUpToSignIn => 'Bereits ein Konto? Anmelden';

  @override
  String get authVerifyTitle => 'E-Mail-Adresse bestätigen';

  @override
  String authVerifyBody(Object email) {
    return 'Wir haben einen Bestätigungslink an $email gesendet. Öffnen Sie den Link und kehren Sie dann hierher zurück.';
  }

  @override
  String get authVerifyIveVerified => 'Ich habe bestätigt';

  @override
  String get authVerifyAlreadyVerified => 'Ihre E-Mail ist bereits verifiziert.';

  @override
  String get authVerifyResend => 'E-Mail erneut senden';

  @override
  String get authVerifyResent => 'Bestätigungs-E-Mail gesendet';

  @override
  String get authVerifyChecking => 'Prüfen…';

  @override
  String get authVerifyNotVerified => 'Noch nicht bestätigt. Bitte Posteingang prüfen.';

  @override
  String authVerifyWait(num secs) {
    String _temp0 = intl.Intl.pluralLogic(
      secs,
      locale: localeName,
      other: '$secs Sekunden',
      one: '1 Sekunde',
    );
    return 'Bitte $_temp0 warten, bevor Sie erneut senden';
  }
}
