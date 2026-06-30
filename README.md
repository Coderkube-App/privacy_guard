# Privacy Guard

A comprehensive Flutter privacy protection SDK. 

Protect your users' sensitive data by preventing screenshots, detecting screen recordings, blurring app switcher previews, and hiding sensitive widgets—all through a clean, unified, platform-aware API.

---

## Why Privacy Guard?

Most packages solve only *one* of these problems. **Privacy Guard** brings them all under one roof with:
* **Ready-to-use Widgets**: Wrap your app in `<PrivacyGuard>` to auto-blur your UI in the OS background switcher.
* **Platform-Safe Calls**: Built-in checks (e.g., `isScreenshotDetectionSupported`) so your app never crashes on unsupported devices.
* **Rich Event Streams**: Get exact timestamps and platform details when screenshots or recordings occur.

---

## Feature Support Matrix

| Feature | Android | iOS |
|---------|:-------:|:---:|
| **Screenshot Prevention** | ✅ | ❌ |
| **Screenshot Detection** | ❌ | ✅ |
| **Screen Recording Detection** | ❌ | ✅ |
| **App Switcher Blur** | ✅ | ✅ |
| **Sensitive Widget Hiding** | ✅ | ✅ |

*(Desktop and Web platforms are not yet supported and will safely throw a `PlatformNotSupportedException` if called).*

---

## Installation

Add it to your `pubspec.yaml`:

```yaml
dependencies:
  privacy_guard: ^0.0.1
```

Then run:
```bash
flutter pub get
```

---

## Quick Start

### 1. Initialize the Service
Before using any features, initialize the service in your `main.dart`:

```dart
import 'package:privacy_guard/privacy_guard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrivacyGuard.initialize(); // <-- Add this
  runApp(MyApp());
}
```

### 2. The Easy Way: Wrap your App
Wrap your entire app (or specific sensitive screens) with the `PrivacyGuard` widget. It automatically listens to app lifecycle events and hides your app's content with a customizable locked screen when it goes into the background (e.g., in the OS recent apps list).

```dart
PrivacyGuard(
  child: MaterialApp(
    home: BankingDashboard(),
  ),
)
```

---

## Advanced Usage

### Prevent Screenshots (Android)
If you are building a banking or secure messaging app, you can completely block screenshots.

```dart
// Block screenshots & screen recording
await PrivacyGuard.preventScreenshots();

// Allow them again later
await PrivacyGuard.allowScreenshots();
```

### Detect Screenshots & Recordings (iOS)
iOS doesn't let you *block* screenshots, but it lets you know when they happen!

```dart
if (PrivacyGuard.isScreenshotDetectionSupported) {
  PrivacyGuard.onScreenshot.listen((event) {
    print('Screenshot taken at ${event.timestamp}!');
  });
}

if (PrivacyGuard.isRecordingDetectionSupported) {
  PrivacyGuard.onRecordingStarted.listen((event) => print('Recording started'));
  PrivacyGuard.onRecordingStopped.listen((event) => print('Recording stopped'));
}
```

### Protect Specific UI Elements
Don't want to hide the whole screen? Obscure just the sensitive parts (like account balances or passwords) using `SensitiveWidget`. Users can tap to reveal or hide the content.

```dart
SensitiveWidget(
  child: Text('\$12,345.67', style: TextStyle(fontSize: 32)),
)
```

### Manual App Switcher Blurring
If you aren't using the `PrivacyGuard` widget, you can manually trigger the blur effect:

```dart
await PrivacyGuard.blurAppSwitcher();
// Later...
await PrivacyGuard.removeAppSwitcherBlur();
```

---

## FAQ

**Q: Why doesn't screenshot prevention work on iOS?**
A: Apple restricts this at the OS level. No app can completely prevent screenshots on iOS. However, you *can* detect them using our `PrivacyGuard.onScreenshot` stream.

**Q: Why doesn't screenshot detection work on Android?**
A: Android doesn't expose a system-level event for this. Instead, Android provides `FLAG_SECURE` to completely prevent them, which you can use via `PrivacyGuard.preventScreenshots()`.

**Q: Can I customize the blur screen?**
A: Absolutely! The `PrivacyGuard` widget accepts an `overlayWidget` parameter so you can show a custom logo or "Locked" UI instead of the default lock icon.

---

## Contributing
Found a bug or want to add Web/Desktop support? Contributions are always welcome! Feel free to open an issue or submit a pull request.

## License
This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.
