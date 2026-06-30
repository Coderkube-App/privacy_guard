import '../models/platform_type.dart';
import 'privacy_guard_exception.dart';

class PlatformNotSupportedException extends PrivacyGuardException {
  final PlatformType platform;

  PlatformNotSupportedException(this.platform)
    : super(
        '${platform.displayName} is not yet supported by privacy_guard. '
        'See the documentation for supported platforms.',
        code: 'PLATFORM_NOT_SUPPORTED',
      );
}
