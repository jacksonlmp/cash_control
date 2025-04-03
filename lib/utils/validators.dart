class Validators {
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  static bool isStrongPassword(String password) {
    return RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(password);
  }
}
