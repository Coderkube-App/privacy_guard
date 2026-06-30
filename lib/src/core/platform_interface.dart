import '../models/recording_event.dart';
import '../models/screenshot_event.dart';

abstract class PlatformPrivacyGuard {
  Future<void> initialize();

  Future<bool> preventScreenshots();

  Future<bool> allowScreenshots();

  Future<bool> blurAppSwitcher();

  Future<bool> removeAppSwitcherBlur();

  Stream<ScreenshotEvent> get onScreenshot;

  Stream<RecordingEvent> get onRecordingStarted;

  Stream<RecordingEvent> get onRecordingStopped;

  bool get isScreenshotDetectionSupported;

  bool get isRecordingDetectionSupported;

  void dispose();
}
