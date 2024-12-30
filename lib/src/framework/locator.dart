part of 'framework.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<Type, dynamic> _dependencies = {};

  void register<T>(T implementation) {
    _dependencies[T] = implementation;
  }

  T get<T>() {
    final implementation = _dependencies[T];
    if (implementation == null) {
      throw Exception('No implementation found for type $T');
    }
    return implementation as T;
  }
}
