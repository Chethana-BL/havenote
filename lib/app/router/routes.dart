/// Route names
abstract class AppRouteName {
  AppRouteName._();

  static const splash = 'splash';
  static const auth = 'auth';
  static const signUp = 'signup';
  static const verifyEmail = 'verifyemail';
  static const forgotPassword = 'forgotpassword';
  static const reauth = 'reauth';
  static const home = 'home';
  static const editor = 'editor'; // create + edit (with :id)
  static const entry = 'entry';
  static const settings = 'settings';
}

/// Route path patterns
abstract class AppRoutePath {
  static const splash = '/splash';
  static const auth = '/auth';
  static const signUp = '/auth/sign-up';
  static const verifyEmail = '/auth/verify-email';
  static const forgotPassword = '/auth/forgot-password';
  static const reauth = '/auth/reauth';
  static const home = '/home';
  static const editor = '/editor';
  static const editorId = '/editor/:id';
  static const entry = '/entry/:id';
  static const settings = '/settings';

  /// Path parameter keys
  static const paramId = 'id';
}

/// Helper to build route paths with parameters.
abstract class AppRoute {
  AppRoute._();

  static String splash() => AppRoutePath.splash;
  static String auth() => AppRoutePath.auth;
  static String signUp() => AppRoutePath.signUp;
  static String verifyEmail() => AppRoutePath.verifyEmail;
  static String forgotPassword() => AppRoutePath.forgotPassword;
  static String reauth() => AppRoutePath.reauth;
  static String home() => AppRoutePath.home;
  static String settings() => AppRoutePath.settings;

  /// New note (create)
  static String editorNew() => AppRoutePath.editor;

  /// Edit note (edit)
  static String editorEdit(String id) => AppRoutePath.editorId.replaceFirst(
    ':${AppRoutePath.paramId}',
    Uri.encodeComponent(id),
  );

  /// Entry detail view
  static String entry(String id) => AppRoutePath.entry.replaceFirst(
    ':${AppRoutePath.paramId}',
    Uri.encodeComponent(id),
  );
}
