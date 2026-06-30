enum PlatformType {
  android,
  ios,
  macOS,
  windows,
  linux,
  web,
  unknown;

  String get displayName {
    if (this == PlatformType.ios) return 'iOS';
    if (this == PlatformType.macOS) return 'macOS';
    return name[0].toUpperCase() + name.substring(1);
  }
}
