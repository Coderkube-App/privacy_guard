import '../models/platform_type.dart';
import 'privacy_guard_exception.dart';

class RecordingDetectionUnavailableException extends PrivacyGuardException {
  final PlatformType platform;

  RecordingDetectionUnavailableException(this.platform)
    : super(
        'Screen recording detection is not available on ${platform.displayName}',
        code: 'RECORDING_DETECTION_UNAVAILABLE',
      );
}
