class Lazy<T> {
  Lazy(this._initializer);

  final T Function() _initializer;
  T? _value;

  T get value {
    _value ??= _initializer();
    return _value as T;
  }

  bool get isInitialized => _value != null;

  @override
  bool operator ==(Object other) {
    if (other is Lazy<T>) {
      return _value == other._value && isInitialized == other.isInitialized;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(_value, isInitialized);

  @override
  String toString() {
    return {
      'value': _value,
      'isInitialized': isInitialized,
    }.toString();
  }
}
