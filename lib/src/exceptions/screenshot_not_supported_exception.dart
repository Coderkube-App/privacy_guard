import '../models/platform_type.dart';
import 'privacy_guard_exception.dart';

class ScreenshotNotSupportedException extends PrivacyGuardException {
  final PlatformType platform;

  ScreenshotNotSupportedException(this.platform)
    : super(
        'Screenshot detection is not supported on ${platform.displayName}',
        code: 'SCREENSHOT_NOT_SUPPORTED',
      );
}
