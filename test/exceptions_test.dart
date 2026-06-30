import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_guard/privacy_guard.dart';

void main() {
  group('PrivacyGuardException', () {
    test('creates with message and optional code', () {
      const exception = PrivacyGuardException(
        'Something went wrong',
        code: 'ERR_001',
      );
      expect(exception.message, 'Something went wrong');
      expect(exception.code, 'ERR_001');
      expect(exception.toString(), contains('ERR_001'));
    });
  });

  group('ScreenshotNotSupportedException', () {
    test('creates with platform info', () {
      final exception = ScreenshotNotSupportedException(PlatformType.web);
      expect(exception.platform, PlatformType.web);
      expect(exception.code, 'SCREENSHOT_NOT_SUPPORTED');
      expect(exception.message, contains('Web'));
    });
  });

  group('RecordingDetectionUnavailableException', () {
    test('creates with platform info', () {
      final exception = RecordingDetectionUnavailableException(
        PlatformType.windows,
      );
      expect(exception.platform, PlatformType.windows);
      expect(exception.code, 'RECORDING_DETECTION_UNAVAILABLE');
      expect(exception.message, contains('Windows'));
    });
  });

  group('PlatformNotSupportedException', () {
    test('creates with platform info', () {
      final exception = PlatformNotSupportedException(PlatformType.web);
      expect(exception.platform, PlatformType.web);
      expect(exception.code, 'PLATFORM_NOT_SUPPORTED');
      expect(exception.message, contains('Web'));
    });
  });
}
