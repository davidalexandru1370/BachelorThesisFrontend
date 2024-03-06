import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage _flutterSecureStorage =
      FlutterSecureStorage();

  static final SecureStorage _secureStorage = SecureStorage._internal();

  factory SecureStorage() {
    return _secureStorage;
  }

  SecureStorage._internal();

  Future<String?> read(String key) async {
    return await _flutterSecureStorage.read(key: key);
  }

  Future<String> readOrThrow(String key, Exception exception) async {
    if ((await contains(key)) == false) {
      throw exception;
    }

    return (await read(key))!;
  }

  Future<String> insert(String key, String value) async {
    await _flutterSecureStorage.write(key: key, value: value);
    return value;
  }

  Future<void> delete(String key) async {
    await _flutterSecureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _flutterSecureStorage.deleteAll();
  }

  Future<bool> contains(String key) async {
    return await _flutterSecureStorage.containsKey(key: key);
  }
}
