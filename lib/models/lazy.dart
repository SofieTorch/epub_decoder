class Lazy<T> {
  Lazy(this._initializer);

  final T Function() _initializer;
  T? _value;

  T get value {
    _value ??= _initializer();
    return _value!;
  }

  bool get isInitialized => _value != null;
}
