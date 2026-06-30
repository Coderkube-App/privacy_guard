import 'package:flutter/foundation.dart';
import '../models/platform_type.dart';

PlatformType detectPlatformType() {
  if (kIsWeb) return PlatformType.web;
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return PlatformType.android;
    case TargetPlatform.iOS:
      return PlatformType.ios;
    case TargetPlatform.macOS:
      return PlatformType.macOS;
    case TargetPlatform.windows:
      return PlatformType.windows;
    case TargetPlatform.linux:
      return PlatformType.linux;
    case TargetPlatform.fuchsia:
      return PlatformType.unknown;
  }
}

bool isPlatformSupported() {
  final platform = detectPlatformType();
  return platform == PlatformType.android || platform == PlatformType.ios;
}
