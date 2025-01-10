part of 'framework.dart';

// ignore: avoid_classes_with_only_static_members
class LocaleInfo {
  /// Get all environment language variables
  static Map<String, String> get env => {
        'OS': Platform.operatingSystem,
        'OS_VERSION': Platform.operatingSystemVersion,
        'LOCALE': Platform.localeName,
      };
}
