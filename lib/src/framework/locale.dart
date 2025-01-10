part of 'framework.dart';

class LocaleInfo {
  /// Get current system locale
  String get systemLocale => Platform.localeName;

  /// Get all environment language variables
  Map<String, String> get env => {
        'OS': Platform.operatingSystem,
        'OS_VERSION': Platform.operatingSystemVersion,
        'LOCALE': Platform.localeName,
      };

  /// Parse locale parts (language, country, encoding)
  Map<String, String> parseLocale() {
    final parts = systemLocale.split('_');
    return {
      'language': parts[0],
      'country': parts.length > 1 ? parts[1].split('.')[0] : '',
      'encoding': parts.length > 1 && parts[1].contains('.') ? parts[1].split('.')[1] : '',
    };
  }
}
