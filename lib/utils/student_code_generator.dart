import 'dart:math';

/// Generates unique student codes/IDs for parent-student linking.
///
/// Format: AJR-XXXXX-XXXX
/// Where X is alphanumeric, prefixed with 'AJR' for Ajyal Al-Rafidain.
class StudentCodeGenerator {
  static const String _prefix = 'AJR';
  static const String _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static final Random _random = Random.secure();

  /// Generate a unique student code.
  /// Format: AJR-XXXXX-XXXX (e.g., AJR-K7M3P-2N9X)
  static String generate() {
    final part1 = _generatePart(5);
    final part2 = _generatePart(4);
    return '$_prefix-$part1-$part2';
  }

  static String _generatePart(int length) {
    return List.generate(
      length,
      (_) => _chars[_random.nextInt(_chars.length)],
    ).join();
  }

  /// Validate that a code matches the expected format.
  static bool isValidCode(String code) {
    final regex = RegExp(r'^AJR-[A-Z2-9]{5}-[A-Z2-9]{4}$');
    return regex.hasMatch(code);
  }
}
