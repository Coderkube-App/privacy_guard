import '../../core/platform_interface.dart';
import '../../exceptions/platform_not_supported_exception.dart';
import '../../models/platform_type.dart';
import '../../models/recording_event.dart';
import '../../models/screenshot_event.dart';

class StubPrivacyGuard extends PlatformPrivacyGuard {
  @override
  Future<void> initialize() async {
    throw PlatformNotSupportedException(PlatformType.unknown);
  }

  @override
  Future<bool> preventScreenshots() async {
    throw PlatformNotSupportedException(PlatformType.unknown);
  }

  @override
  Future<bool> allowScreenshots() async {
    throw PlatformNotSupportedException(PlatformType.unknown);
  }

  @override
  Future<bool> blurAppSwitcher() async {
    throw PlatformNotSupportedException(PlatformType.unknown);
  }

  @override
  Future<bool> removeAppSwitcherBlur() async {
    throw PlatformNotSupportedException(PlatformType.unknown);
  }

  @override
  Stream<ScreenshotEvent> get onScreenshot => const Stream.empty();

  @override
  Stream<RecordingEvent> get onRecordingStarted => const Stream.empty();

  @override
  Stream<RecordingEvent> get onRecordingStopped => const Stream.empty();

  @override
  bool get isScreenshotDetectionSupported => false;

  @override
  bool get isRecordingDetectionSupported => false;

  @override
  void dispose() {}
}
