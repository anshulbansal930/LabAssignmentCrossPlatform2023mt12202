/// Helper class for common regular expression validations.
class AppRegexHelper {
  /// Validates if the given [email] is in a proper email format.
  static bool isEmailValid(String email) {
    return RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(email);
  }

  /// Checks if the [password] has a minimum length of 6 characters.
  static bool hasMinLength(String password) {
    return RegExp(r'^(?=.{6,})').hasMatch(password);
  }
}
