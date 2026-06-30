import 'platform_type.dart';
import 'privacy_event.dart';

class ScreenshotEvent extends PrivacyEvent {
  const ScreenshotEvent({required super.timestamp, required super.platform})
    : super(eventType: EventType.screenshot);

  factory ScreenshotEvent.now(PlatformType platform) =>
      ScreenshotEvent(timestamp: DateTime.now(), platform: platform);

  factory ScreenshotEvent.fromMap(Map<String, dynamic> map) => ScreenshotEvent(
    timestamp: DateTime.parse(map['timestamp'] as String),
    platform: PlatformType.values.firstWhere(
      (p) => p.name == map['platform'],
      orElse: () => PlatformType.unknown,
    ),
  );

  @override
  String toString() =>
      'ScreenshotEvent(timestamp: $timestamp, platform: $platform)';
}
