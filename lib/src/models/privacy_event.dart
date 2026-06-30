import 'platform_type.dart';

enum EventType { screenshot, recordingStarted, recordingStopped }

class PrivacyEvent {
  final DateTime timestamp;
  final PlatformType platform;
  final EventType eventType;

  const PrivacyEvent({
    required this.timestamp,
    required this.platform,
    required this.eventType,
  });

  Map<String, dynamic> toMap() => {
    'timestamp': timestamp.toIso8601String(),
    'platform': platform.name,
    'eventType': eventType.name,
  };

  @override
  String toString() =>
      'PrivacyEvent(timestamp: $timestamp, platform: $platform, eventType: $eventType)';
}
