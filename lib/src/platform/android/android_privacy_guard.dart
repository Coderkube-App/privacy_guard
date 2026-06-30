import 'package:flutter/services.dart';

import '../../core/platform_interface.dart';
import '../../models/recording_event.dart';
import '../../models/screenshot_event.dart';

class AndroidPrivacyGuard extends PlatformPrivacyGuard {
  static const _methodChannel = MethodChannel('privacy_guard/android');
  static const _screenshotChannel = EventChannel(
    'privacy_guard/android/screenshot',
  );
  static const _recordingChannel = EventChannel(
    'privacy_guard/android/recording',
  );

  bool _screenshotDetectionSupported = false;
  bool _recordingDetectionSupported = false;

  @override
  Future<void> initialize() async {
    try {
      final capabilities = await _methodChannel
          .invokeMethod<Map<dynamic, dynamic>>('initialize');
      _screenshotDetectionSupported =
          capabilities?['screenshotDetection'] as bool? ?? false;
      _recordingDetectionSupported =
          capabilities?['recordingDetection'] as bool? ?? false;
    } on MissingPluginException {
      _screenshotDetectionSupported = false;
      _recordingDetectionSupported = false;
    }
  }

  @override
  Future<bool> preventScreenshots() async {
    try {
      return await _methodChannel.invokeMethod<bool>('preventScreenshots') ??
          false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<bool> allowScreenshots() async {
    try {
      return await _methodChannel.invokeMethod<bool>('allowScreenshots') ??
          false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<bool> blurAppSwitcher() async {
    try {
      return await _methodChannel.invokeMethod<bool>('blurAppSwitcher') ??
          false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<bool> removeAppSwitcherBlur() async {
    try {
      return await _methodChannel.invokeMethod<bool>('removeAppSwitcherBlur') ??
          false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Stream<ScreenshotEvent> get onScreenshot {
    if (!_screenshotDetectionSupported) {
      return const Stream.empty();
    }
    return _screenshotChannel.receiveBroadcastStream().map(
      (event) => ScreenshotEvent.fromMap(event as Map<String, dynamic>),
    );
  }

  @override
  Stream<RecordingEvent> get onRecordingStarted {
    if (!_recordingDetectionSupported) {
      return const Stream.empty();
    }
    return _recordingChannel
        .receiveBroadcastStream()
        .where((event) => event is Map && event['isRecording'] == true)
        .map((event) => RecordingEvent.fromMap(event as Map<String, dynamic>));
  }

  @override
  Stream<RecordingEvent> get onRecordingStopped {
    if (!_recordingDetectionSupported) {
      return const Stream.empty();
    }
    return _recordingChannel
        .receiveBroadcastStream()
        .where((event) => event is Map && event['isRecording'] == false)
        .map((event) => RecordingEvent.fromMap(event as Map<String, dynamic>));
  }

  @override
  bool get isScreenshotDetectionSupported => _screenshotDetectionSupported;

  @override
  bool get isRecordingDetectionSupported => _recordingDetectionSupported;

  @override
  void dispose() {}
}
