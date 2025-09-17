/// Route names
abstract class AppRouteName {
  AppRouteName._();

  static const splash = 'splash';
  static const auth = 'auth';
  static const signUp = 'signup';
  static const verifyEmail = 'verifyemail';
  static const forgotPassword = 'forgotpassword';
  static const home = 'home';
}

/// Route path patterns
abstract class AppRoutePath {
  static const splash = '/splash';
  static const auth = '/auth';
  static const signUp = '/auth/sign-up';
  static const verifyEmail = '/auth/verify-email';
  static const forgotPassword = '/auth/forgot-password';
  static const home = '/home';
}

/// Helper to build route paths with parameters.
abstract class AppRoute {
  AppRoute._();

  static String splash() => AppRoutePath.splash;
  static String auth() => AppRoutePath.auth;
  static String signUp() => AppRoutePath.signUp;
  static String verifyEmail() => AppRoutePath.verifyEmail;
  static String forgotPassword() => AppRoutePath.forgotPassword;
  static String home() => AppRoutePath.home;
}
