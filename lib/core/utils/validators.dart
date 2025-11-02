/// FormValidators - Comprehensive validation utilities for the Alha app
/// 
/// Usage Examples:
/// 
/// 1. Basic validation:
///    String? error = FormValidators.validateEmail(email);
///    if (error != null) {
///      // Show error message
///    }
/// 
/// 2. Multiple validators:
///    String? error = FormValidators.validateMultiple(
///      value,
///      [
///        (v) => FormValidators.validateRequired(v, 'שם'),
///        (v) => FormValidators.validateMinLength(v, 2, 'שם'),
///      ],
///    );
/// 
/// 3. Check if valid:
///    bool isValid = FormValidators.isValid(value, FormValidators.validateEmail);
/// 
/// 4. Get error message:
///    String errorMsg = FormValidators.getValidationError(value, FormValidators.validateEmail);
/// 
/// All validation methods return null if valid, or a Hebrew error message if invalid.
class FormValidators {
  /// Validate first name
  static String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'שם פרטי נדרש';
    }
    if (value.trim().length < 2) {
      return 'שם פרטי חייב להכיל לפחות 2 תווים';
    }
    return null;
  }

  /// Validate last name
  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'שם משפחה נדרש';
    }
    if (value.trim().length < 2) {
      return 'שם משפחה חייב להכיל לפחות 2 תווים';
    }
    return null;
  }

  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'אימייל נדרש';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'אנא הכנס כתובת אימייל תקינה';
    }
    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'סיסמה נדרשת';
    }
    if (value.length < 8) {
      return 'סיסמה חייבת להכיל לפחות 8 תווים';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'סיסמה חייבת להכיל לפחות אות גדולה אחת';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'סיסמה חייבת להכיל לפחות אות קטנה אחת';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'סיסמה חייבת להכיל לפחות מספר אחד';
    }
    return null;
  }

  /// Validate phone number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'מספר טלפון נדרש';
    }
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'אנא הכנס מספר טלפון תקין';
    }
    return null;
  }

  /// Validate birth year
  static String? validateBirthYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'שנת לידה נדרשת';
    }
    final year = int.tryParse(value);
    if (year == null || year < 1950 || year > DateTime.now().year) {
      return 'אנא בחר שנת לידה תקינה';
    }
    return null;
  }

  /// Validate if value is not empty
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName נדרש';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.trim().length < minLength) {
      return '$fieldName חייב להכיל לפחות $minLength תווים';
    }
    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.trim().length > maxLength) {
      return '$fieldName חייב להכיל לכל היותר $maxLength תווים';
    }
    return null;
  }

  /// Validate numeric value
  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName נדרש';
    }
    if (double.tryParse(value) == null) {
      return '$fieldName חייב להיות מספר';
    }
    return null;
  }

  /// Validate integer value
  static String? validateInteger(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName נדרש';
    }
    if (int.tryParse(value) == null) {
      return '$fieldName חייב להיות מספר שלם';
    }
    return null;
  }

  /// Validate integer range
  static String? validateIntegerRange(String? value, int min, int max, String fieldName) {
    final intError = validateInteger(value, fieldName);
    if (intError != null) return intError;
    
    final year = int.parse(value!);
    if (year < min || year > max) {
      return '$fieldName חייב להיות בין $min ל-$max';
    }
    return null;
  }

  /// Validate URL format
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'כתובת URL נדרשת';
    }
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    if (!urlRegex.hasMatch(value.trim())) {
      return 'אנא הכנס כתובת URL תקינה';
    }
    return null;
  }

  /// Validate Hebrew text (basic check)
  static String? validateHebrewText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName נדרש';
    }
    // Basic Hebrew character range check
    final hebrewRegex = RegExp(r'[\u0590-\u05FF\uFB1D-\uFB4F]');
    if (!hebrewRegex.hasMatch(value.trim())) {
      return '$fieldName חייב להכיל טקסט בעברית';
    }
    return null;
  }

  /// Validate English text (basic check)
  static String? validateEnglishText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName נדרש';
    }
    // Basic English character range check
    final englishRegex = RegExp(r'[a-zA-Z]');
    if (!englishRegex.hasMatch(value.trim())) {
      return '$fieldName חייב להכיל טקסט באנגלית';
    }
    return null;
  }

  /// Validate alphanumeric
  static String? validateAlphanumeric(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName נדרש';
    }
    final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!alphanumericRegex.hasMatch(value.trim())) {
      return '$fieldName חייב להכיל רק אותיות ומספרים';
    }
    return null;
  }

  /// Validate no special characters (simplified)
  static String? validateNoSpecialChars(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName נדרש';
    }
    // Simplified special characters check
    if (value.contains('!') || value.contains('@') || value.contains('#') || 
        value.contains('\$') || value.contains('%') || value.contains('^') || 
        value.contains('&') || value.contains('*') || value.contains('(') || 
        value.contains(')') || value.contains('_') || value.contains('+') || 
        value.contains('-') || value.contains('=') || value.contains('[') || 
        value.contains(']') || value.contains('{') || value.contains('}') || 
        value.contains(';') || value.contains(':') || value.contains('"') || 
        value.contains('\\') || value.contains('|') || value.contains(',') || 
        value.contains('.') || value.contains('<') || value.contains('>') || 
        value.contains('/') || value.contains('?')) {
      return '$fieldName לא יכול להכיל תווים מיוחדים';
    }
    return null;
  }

  /// Validate date format (YYYY-MM-DD)
  static String? validateDateFormat(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName נדרש';
    }
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(value.trim())) {
      return '$fieldName חייב להיות בפורמט YYYY-MM-DD';
    }
    
    try {
      DateTime.parse(value.trim());
    } catch (e) {
      return '$fieldName חייב להיות תאריך תקין';
    }
    
    return null;
  }

  /// Validate time format (HH:MM)
  static String? validateTimeFormat(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName נדרש';
    }
    final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timeRegex.hasMatch(value.trim())) {
      return '$fieldName חייב להיות בפורמט HH:MM';
    }
    return null;
  }

  /// Validate positive number
  static String? validatePositiveNumber(String? value, String fieldName) {
    final numericError = validateNumeric(value, fieldName);
    if (numericError != null) return numericError;
    
    final number = double.parse(value!);
    if (number <= 0) {
      return '$fieldName חייב להיות מספר חיובי';
    }
    return null;
  }

  /// Validate percentage (0-100)
  static String? validatePercentage(String? value, String fieldName) {
    final numericError = validateNumeric(value, fieldName);
    if (numericError != null) return numericError;
    
    final percentage = double.parse(value!);
    if (percentage < 0 || percentage > 100) {
      return '$fieldName חייב להיות בין 0 ל-100';
    }
    return null;
  }

  /// Validate custom regex pattern
  static String? validatePattern(String? value, RegExp pattern, String fieldName, String errorMessage) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName נדרש';
    }
    if (!pattern.hasMatch(value.trim())) {
      return errorMessage;
    }
    return null;
  }

  /// Validate multiple validators
  static String? validateMultiple(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }

  /// Check if value is valid (no error message)
  static bool isValid(String? value, String? Function(String?) validator) {
    return validator(value) == null;
  }

  /// Get validation error or empty string
  static String getValidationError(String? value, String? Function(String?) validator) {
    return validator(value) ?? '';
  }
}
