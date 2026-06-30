import '../core/platform_interface.dart';
import '../models/platform_type.dart';
import '../models/recording_event.dart';
import '../models/screenshot_event.dart';
import '../platform/android/android_privacy_guard.dart';
import '../platform/ios/ios_privacy_guard.dart';
import '../platform/stub/stub_privacy_guard.dart';
import '../utils/platform_utils.dart';

class PrivacyGuardService {
  PrivacyGuardService._();

  static final PrivacyGuardService _instance = PrivacyGuardService._();
  static PrivacyGuardService get instance => _instance;

  PlatformPrivacyGuard? _platform;
  bool _initialized = false;

  void setPlatform(PlatformPrivacyGuard platform) {
    _platform = platform;
    _initialized = true;
  }

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;
    _platform = _createPlatform();
    await _platform!.initialize();
    _initialized = true;
  }

  PlatformPrivacyGuard _createPlatform() {
    final platform = detectPlatformType();
    if (platform == PlatformType.android) {
      return AndroidPrivacyGuard();
    } else if (platform == PlatformType.ios) {
      return IOSPrivacyGuard();
    }
    return StubPrivacyGuard();
  }

  PlatformPrivacyGuard get _guard {
    if (!_initialized || _platform == null) {
      throw StateError(
        'PrivacyGuard has not been initialized. Call PrivacyGuard.initialize() first.',
      );
    }
    return _platform!;
  }

  Future<bool> preventScreenshots() => _guard.preventScreenshots();

  Future<bool> allowScreenshots() => _guard.allowScreenshots();

  Future<bool> blurAppSwitcher() => _guard.blurAppSwitcher();

  Future<bool> removeAppSwitcherBlur() => _guard.removeAppSwitcherBlur();

  bool get isScreenshotDetectionSupported =>
      _guard.isScreenshotDetectionSupported;

  bool get isRecordingDetectionSupported =>
      _guard.isRecordingDetectionSupported;

  Stream<ScreenshotEvent> get onScreenshot => _guard.onScreenshot;

  Stream<RecordingEvent> get onRecordingStarted => _guard.onRecordingStarted;

  Stream<RecordingEvent> get onRecordingStopped => _guard.onRecordingStopped;

  void dispose() {
    if (_initialized) {
      _platform?.dispose();
      _platform = null;
      _initialized = false;
    }
  }
}
