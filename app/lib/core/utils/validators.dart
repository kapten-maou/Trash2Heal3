/// Form validation utilities for Trash2Heal mobile app
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  /// Password validation (minimum 6 characters)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  /// Strong password validation
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf besar';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password harus mengandung huruf kecil';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }

    return null;
  }

  /// Phone number validation (Indonesia)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    // Indonesia phone: 08xx-xxxx-xxxx or 62xxx-xxxx-xxxx
    if (digitsOnly.length < 10 || digitsOnly.length > 13) {
      return 'Nomor telepon tidak valid';
    }

    if (!digitsOnly.startsWith('0') && !digitsOnly.startsWith('62')) {
      return 'Nomor telepon harus diawali 0 atau 62';
    }

    return null;
  }

  /// Required field validation
  static String? required(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  /// Minimum length validation
  static String? minLength(String? value, int min,
      [String fieldName = 'Field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (value.length < min) {
      return '$fieldName minimal $min karakter';
    }

    return null;
  }

  /// Maximum length validation
  static String? maxLength(String? value, int max,
      [String fieldName = 'Field']) {
    if (value != null && value.length > max) {
      return '$fieldName maksimal $max karakter';
    }
    return null;
  }

  /// Numeric validation
  static String? numeric(String? value, [String fieldName = 'Field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (double.tryParse(value) == null) {
      return '$fieldName harus berupa angka';
    }

    return null;
  }

  /// Positive number validation
  static String? positiveNumber(String? value, [String fieldName = 'Field']) {
    final numericError = numeric(value, fieldName);
    if (numericError != null) return numericError;

    final number = double.parse(value!);
    if (number <= 0) {
      return '$fieldName harus lebih dari 0';
    }

    return null;
  }

  /// PIN validation (6 digits)
  static String? pin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN tidak boleh kosong';
    }

    if (value.length != 6) {
      return 'PIN harus 6 digit';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'PIN hanya boleh berisi angka';
    }

    return null;
  }

  /// Confirm password validation
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (value != password) {
      return 'Password tidak cocok';
    }

    return null;
  }

  /// Address validation
  static String? address(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alamat tidak boleh kosong';
    }

    if (value.trim().length < 10) {
      return 'Alamat minimal 10 karakter';
    }

    return null;
  }

  /// Weight validation (kg)
  static String? weight(String? value) {
    final numericError = positiveNumber(value, 'Berat');
    if (numericError != null) return numericError;

    final weight = double.parse(value!);
    if (weight > 1000) {
      return 'Berat maksimal 1000 kg';
    }

    return null;
  }

  /// URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL tidak boleh kosong';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Format URL tidak valid';
    }

    return null;
  }

  /// Combine multiple validators
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}
