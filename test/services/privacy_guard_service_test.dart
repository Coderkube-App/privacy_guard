import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_guard/privacy_guard.dart';
import 'package:privacy_guard/src/platform/stub/stub_privacy_guard.dart';
import 'package:privacy_guard/src/services/privacy_guard_service.dart';

class MockPlatformGuard extends StubPrivacyGuard {
  bool screenshotsPrevented = false;
  bool blurEnabled = false;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> preventScreenshots() async {
    screenshotsPrevented = true;
    return true;
  }

  @override
  Future<bool> allowScreenshots() async {
    screenshotsPrevented = false;
    return true;
  }

  @override
  Future<bool> blurAppSwitcher() async {
    blurEnabled = true;
    return true;
  }

  @override
  Future<bool> removeAppSwitcherBlur() async {
    blurEnabled = false;
    return true;
  }

  @override
  bool get isScreenshotDetectionSupported => true;

  @override
  bool get isRecordingDetectionSupported => true;
}

void main() {
  group('PrivacyGuardService', () {
    late PrivacyGuardService service;
    late MockPlatformGuard mockPlatform;

    setUp(() {
      service = PrivacyGuardService.instance;
      mockPlatform = MockPlatformGuard();
      service.setPlatform(mockPlatform);
    });

    tearDown(() {
      service.dispose();
    });

    test('is initialized after setPlatform', () {
      expect(service.isInitialized, isTrue);
    });

    test('preventScreenshots returns true', () async {
      final result = await service.preventScreenshots();
      expect(result, isTrue);
    });

    test('allowScreenshots returns true', () async {
      final result = await service.allowScreenshots();
      expect(result, isTrue);
    });

    test('blurAppSwitcher returns true', () async {
      final result = await service.blurAppSwitcher();
      expect(result, isTrue);
    });

    test('removeAppSwitcherBlur returns true', () async {
      final result = await service.removeAppSwitcherBlur();
      expect(result, isTrue);
    });

    test('isScreenshotDetectionSupported returns true', () {
      expect(service.isScreenshotDetectionSupported, isTrue);
    });

    test('isRecordingDetectionSupported returns true', () {
      expect(service.isRecordingDetectionSupported, isTrue);
    });

    test('dispose resets state', () {
      expect(service.isInitialized, isTrue);
      service.dispose();
      expect(service.isInitialized, isFalse);
    });
  });
}
