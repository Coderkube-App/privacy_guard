import 'package:flutter/material.dart';

import 'src/models/recording_event.dart';
import 'src/models/screenshot_event.dart';
import 'src/services/privacy_guard_service.dart';

export 'src/core/platform_interface.dart' show PlatformPrivacyGuard;
export 'src/exceptions/platform_not_supported_exception.dart';
export 'src/exceptions/privacy_guard_exception.dart';
export 'src/exceptions/recording_detection_unavailable_exception.dart';
export 'src/exceptions/screenshot_not_supported_exception.dart';
export 'src/extensions/platform_extensions.dart';
export 'src/models/platform_type.dart';
export 'src/models/privacy_event.dart';
export 'src/models/recording_event.dart';
export 'src/models/screenshot_event.dart';
export 'src/services/privacy_guard_service.dart';
export 'src/widgets/sensitive_widget.dart';

/// A widget and static utility class that provides comprehensive privacy
/// protection features including screenshot prevention, detection, and
/// app switcher blurring.
///
/// Wrap your root application or sensitive screens with this widget to
/// automatically obscure the UI when the app goes into the background.
class PrivacyGuard extends StatefulWidget {
  /// The widget below this widget in the tree, typically your app's main UI.
  final Widget child;

  /// The background color to show when the app is backgrounded.
  /// Defaults to `Color(0xFF1A1A2E)` if not provided.
  final Color? overlayColor;

  /// A custom widget to display over the app when backgrounded.
  /// If null, a default lock icon overlay is used.
  final Widget? overlayWidget;

  /// Creates a PrivacyGuard widget to protect the [child] when the app is inactive.
  const PrivacyGuard({
    super.key,
    required this.child,
    this.overlayColor,
    this.overlayWidget,
  });

  static final PrivacyGuardService _service = PrivacyGuardService.instance;

  /// Initializes the privacy guard platform channels.
  /// **Must** be called before using any other static methods.
  static Future<void> initialize() => _service.initialize();

  /// Prevents the user from taking screenshots or screen recordings.
  ///
  /// Currently supported on: **Android**.
  /// On unsupported platforms, this throws a [PlatformNotSupportedException].
  static Future<bool> preventScreenshots() => _service.preventScreenshots();

  /// Re-allows the user to take screenshots or screen recordings.
  ///
  /// Currently supported on: **Android**.
  static Future<bool> allowScreenshots() => _service.allowScreenshots();

  /// Blurs or hides the app's content in the OS recent apps list/app switcher.
  ///
  /// Supported on: **Android**, **iOS**.
  static Future<bool> blurAppSwitcher() => _service.blurAppSwitcher();

  /// Removes the blur effect from the OS recent apps list/app switcher.
  ///
  /// Supported on: **Android**, **iOS**.
  static Future<bool> removeAppSwitcherBlur() =>
      _service.removeAppSwitcherBlur();

  /// A stream that emits a [ScreenshotEvent] whenever the user takes a screenshot.
  ///
  /// Use [isScreenshotDetectionSupported] to check availability before listening.
  static Stream<ScreenshotEvent> get onScreenshot => _service.onScreenshot;

  /// A stream that emits a [RecordingEvent] whenever a screen recording starts.
  ///
  /// Use [isRecordingDetectionSupported] to check availability before listening.
  static Stream<RecordingEvent> get onRecordingStarted =>
      _service.onRecordingStarted;

  /// A stream that emits a [RecordingEvent] whenever a screen recording stops.
  ///
  /// Use [isRecordingDetectionSupported] to check availability before listening.
  static Stream<RecordingEvent> get onRecordingStopped =>
      _service.onRecordingStopped;

  /// Whether [PrivacyGuard.initialize] has been successfully called.
  static bool get isInitialized => _service.isInitialized;

  /// Whether the current platform supports detecting screenshots.
  ///
  /// Returns `true` on iOS, `false` on Android and others.
  static bool get isScreenshotDetectionSupported =>
      _service.isScreenshotDetectionSupported;

  /// Whether the current platform supports detecting screen recordings.
  ///
  /// Returns `true` on iOS, `false` on Android and others.
  static bool get isRecordingDetectionSupported =>
      _service.isRecordingDetectionSupported;

  @override
  State<PrivacyGuard> createState() => _PrivacyGuardState();
}

class _PrivacyGuardState extends State<PrivacyGuard>
    with WidgetsBindingObserver {
  bool _isBackgrounded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _isBackgrounded =
          state == AppLifecycleState.paused ||
          state == AppLifecycleState.inactive;
    });
  }

  @override
  Widget build(BuildContext context) {
    final effectiveOverlayColor =
        widget.overlayColor ?? const Color(0xFF1A1A2E);

    final effectiveOverlayWidget =
        widget.overlayWidget ??
        Container(
          color: effectiveOverlayColor,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 48,
                  color: Colors.white.withAlpha(179),
                ),
                const SizedBox(height: 12),
                Text(
                  'Content Hidden',
                  style: TextStyle(
                    color: Colors.white.withAlpha(179),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );

    return Stack(
      children: [widget.child, if (_isBackgrounded) effectiveOverlayWidget],
    );
  }
}
