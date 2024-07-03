import 'package:flutter/foundation.dart' show immutable;

@immutable
class ValidationUtils {
  // Validate email
  static bool isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return emailRegExp.hasMatch(email);
  }

  // Validate password (minimum 8 characters, at least one letter, one number, and one special character)
  static bool isValidPassword(String password) {
    final passwordRegExp = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$',
    );
    return passwordRegExp.hasMatch(password);
  }

  // Validate phone number (basic validation)
  static bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegExp = RegExp(
      r'^\+?1?\d{9,15}$',
    );
    return phoneRegExp.hasMatch(phoneNumber);
  }

  // Validate country code (1 to 3 digits)
  static bool isValidCountryCode(String countryCode) {
    final countryCodeRegExp = RegExp(
      r'^\d{1,3}$',
    );
    return countryCodeRegExp.hasMatch(countryCode);
  }

  // Validate non-empty string
  static bool isNotEmpty(String value) {
    return value.isNotEmpty;
  }

  // Validate username (only lowercase letters, numbers, and dots)
  static bool isValidUsername(String username) {
    final usernameRegExp = RegExp(
      r'^[a-z0-9.]+$',
    );
    return usernameRegExp.hasMatch(username);
  }
}
