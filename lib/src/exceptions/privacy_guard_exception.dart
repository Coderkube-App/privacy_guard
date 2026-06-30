class PrivacyGuardException implements Exception {
  final String message;
  final String? code;

  const PrivacyGuardException(this.message, {this.code});

  @override
  String toString() => 'PrivacyGuardException(${code ?? "UNKNOWN"}): $message';
}
