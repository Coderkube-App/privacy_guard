import '../models/platform_type.dart';

extension PlatformTypeExtension on PlatformType {
  bool get isMobile => this == PlatformType.android || this == PlatformType.ios;

  bool get isDesktop =>
      this == PlatformType.macOS ||
      this == PlatformType.windows ||
      this == PlatformType.linux;

  bool get isSupported =>
      this == PlatformType.android || this == PlatformType.ios;
}
