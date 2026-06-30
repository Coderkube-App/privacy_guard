import 'platform_type.dart';
import 'privacy_event.dart';

class RecordingEvent extends PrivacyEvent {
  final bool isRecording;

  const RecordingEvent({
    required super.timestamp,
    required super.platform,
    required this.isRecording,
  }) : super(
         eventType: isRecording
             ? EventType.recordingStarted
             : EventType.recordingStopped,
       );

  factory RecordingEvent.started(PlatformType platform) => RecordingEvent(
    timestamp: DateTime.now(),
    platform: platform,
    isRecording: true,
  );

  factory RecordingEvent.stopped(PlatformType platform) => RecordingEvent(
    timestamp: DateTime.now(),
    platform: platform,
    isRecording: false,
  );

  factory RecordingEvent.fromMap(Map<String, dynamic> map) => RecordingEvent(
    timestamp: DateTime.parse(map['timestamp'] as String),
    platform: PlatformType.values.firstWhere(
      (p) => p.name == map['platform'],
      orElse: () => PlatformType.unknown,
    ),
    isRecording: map['isRecording'] as bool,
  );

  @override
  String toString() =>
      'RecordingEvent(timestamp: $timestamp, platform: $platform, isRecording: $isRecording)';
}
