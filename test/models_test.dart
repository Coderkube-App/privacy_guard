import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_guard/privacy_guard.dart';

void main() {
  group('PlatformType', () {
    test('has correct display names', () {
      expect(PlatformType.android.displayName, 'Android');
      expect(PlatformType.ios.displayName, 'iOS');
      expect(PlatformType.web.displayName, 'Web');
    });

    test('isMobile returns true for Android and iOS', () {
      expect(PlatformType.android.isMobile, isTrue);
      expect(PlatformType.ios.isMobile, isTrue);
      expect(PlatformType.web.isMobile, isFalse);
    });

    test('isSupported returns true for Android and iOS', () {
      expect(PlatformType.android.isSupported, isTrue);
      expect(PlatformType.ios.isSupported, isTrue);
      expect(PlatformType.web.isSupported, isFalse);
    });
  });

  group('PrivacyEvent', () {
    test('creates event with correct properties', () {
      final event = PrivacyEvent(
        timestamp: DateTime(2025),
        platform: PlatformType.android,
        eventType: EventType.screenshot,
      );

      expect(event.timestamp, DateTime(2025));
      expect(event.platform, PlatformType.android);
      expect(event.eventType, EventType.screenshot);
    });

    test('toMap returns correct map', () {
      final event = PrivacyEvent(
        timestamp: DateTime(2025),
        platform: PlatformType.android,
        eventType: EventType.screenshot,
      );

      final map = event.toMap();
      expect(map['timestamp'], '2025-01-01T00:00:00.000');
      expect(map['platform'], 'android');
      expect(map['eventType'], 'screenshot');
    });
  });

  group('ScreenshotEvent', () {
    test('creates screenshot event with correct type', () {
      final event = ScreenshotEvent(
        timestamp: DateTime(2025),
        platform: PlatformType.ios,
      );

      expect(event.eventType, EventType.screenshot);
    });

    test('ScreenshotEvent.now uses current time', () {
      final before = DateTime.now();
      final event = ScreenshotEvent.now(PlatformType.android);
      final after = DateTime.now();

      expect(event.platform, PlatformType.android);
      expect(event.eventType, EventType.screenshot);
      expect(event.timestamp.isAfter(before), isTrue);
      expect(event.timestamp.isBefore(after), isTrue);
    });

    test('fromMap creates event correctly', () {
      final map = <String, dynamic>{
        'timestamp': '2025-06-15T10:30:00.000',
        'platform': 'android',
      };

      final event = ScreenshotEvent.fromMap(map);
      expect(event.timestamp, DateTime(2025, 6, 15, 10, 30));
      expect(event.platform, PlatformType.android);
    });
  });

  group('RecordingEvent', () {
    test('creates started event correctly', () {
      final event = RecordingEvent.started(PlatformType.ios);
      expect(event.isRecording, isTrue);
      expect(event.eventType, EventType.recordingStarted);
    });

    test('creates stopped event correctly', () {
      final event = RecordingEvent.stopped(PlatformType.ios);
      expect(event.isRecording, isFalse);
      expect(event.eventType, EventType.recordingStopped);
    });

    test('fromMap creates event correctly', () {
      final map = <String, dynamic>{
        'timestamp': '2025-06-15T10:30:00.000',
        'platform': 'ios',
        'isRecording': true,
      };

      final event = RecordingEvent.fromMap(map);
      expect(event.isRecording, isTrue);
      expect(event.platform, PlatformType.ios);
    });
  });
}
