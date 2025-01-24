import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageManager {
  LocalStorageManager._();

  static const _iosOptions = IOSOptions(accessibility: KeychainAccessibility.first_unlock);
  static const _androidOptions = AndroidOptions(encryptedSharedPreferences: true);

  static const FlutterSecureStorage _secureStorage =
      FlutterSecureStorage(iOptions: _iosOptions, aOptions: _androidOptions);

  static Future<Set<String>?> getKeys() async =>
      (await _secureStorage.readAll(/*aOptions: _androidOptions*/ /*iOptions: _iosOptions*/)).keys.toSet();

  static Future<bool> containsKey(String key) async => _secureStorage.containsKey(
        key: key, /*aOptions: _androidOptions*/ /*iOptions: _iosOptions*/
      );

  static Future<void> setString(String key, String value) async => _secureStorage.write(
        key: key,
        value: value,
        /*aOptions: _androidOptions*/
        /*iOptions: _iosOptions*/
      );

  static Future<void> setBool(String key, {required bool value}) async => _secureStorage.write(
        key: key,
        value: value.toString(),
        /*aOptions: _androidOptions*/
        /*iOptions: _iosOptions*/
      );

  static Future<void> setNum(String key, num value) async => _secureStorage.write(
        key: key,
        value: value.toString(),
        /*aOptions: _androidOptions*/
        /*iOptions: _iosOptions*/
      );

  static Future<void> _setList<T>(String key, List<T> value) async {
    final buffer = json.encode(value);
    await _secureStorage.write(
      key: key,
      value: buffer,
      /*aOptions: _androidOptions*/
      /*iOptions: _iosOptions*/
    );
  }

  static Future<void> _setMap(String key, Map<String, dynamic> value) async {
    final buffer = json.encode(value);
    await _secureStorage.write(
      key: key,
      value: buffer,
      /*aOptions: _androidOptions*/
      /*iOptions: _iosOptions*/
    );
  }

  static Future<void> setMap(String key, Map<String, dynamic> value) => _setMap(key, value);

  static Future<void> setStringList(String key, List<String> value) => _setList<String>(key, value);

  static Future<void> setNumList(String key, List<num> value) => _setList<num>(key, value);

  static Future<void> setBoolList(String key, List<bool> value) => _setList<bool>(key, value);
  static Future<void> setMapList(String key, List<Map<String, dynamic>> value) =>
      _setList<Map<String, dynamic>>(key, value);

  static Future<String?> getString(String key) async => _secureStorage.read(
        key: key, /*aOptions: _androidOptions*/ /*iOptions: _iosOptions*/
      );

  static Future<bool?> getBool(String key) async {
    final string = await _secureStorage.read(
      key: key, /*aOptions: _androidOptions*/ /*iOptions: _iosOptions*/
    );
    if (string == null) return null;
    if (string == 'true') {
      return true;
    } else if (string == 'false') {
      return false;
    } else {
      return null;
    }
  }

  static Future<num?> getNum(String key) async => num.tryParse(
        await _secureStorage.read(
              key: key, /*aOptions: _androidOptions*/ /*iOptions: _iosOptions*/
            ) ??
            '',
      );

  static Future<List<T>?> _getList<T>(String key) async {
    final string = await _secureStorage.read(
      key: key, /*aOptions: _androidOptions*/ /*iOptions: _iosOptions*/
    );
    if (string == null) return null;
    final list = (json.decode(string) as List).cast<T>();
    return list;
  }

  static Future<Map<String, dynamic>?> _getMap(String key) async {
    final string = await _secureStorage.read(
      key: key, /*aOptions: _androidOptions*/ /*iOptions: _iosOptions*/
    );
    if (string == null) return null;
    // ignore: inference_failure_on_function_invocation
    final map = (json.decode(string) as Map<String, dynamic>?)?.cast();
    return map as Map<String, dynamic>?;
  }

  static Future<Map<String, dynamic>?> getMap(String key) => _getMap(key);

  static Future<List<String>?> getStringList(String key) => _getList<String>(key);

  static Future<List<num>?> getNumList(String key) => _getList<num>(key);

  static Future<List<bool>?> getBoolList(String key) => _getList<bool>(key);

  static Future<List<Map<String, dynamic>>?> getMapList(String key) => _getList<Map<String, dynamic>>(key);

  static Future<void> remove(String key) async => _secureStorage.delete(
        key: key, /*aOptions: _androidOptions*/ /*iOptions: _iosOptions*/
      );

  static Future<void> clearAll() async =>
      _secureStorage.deleteAll(/*aOptions: _androidOptions*/ /*iOptions: _iosOptions*/);
  static Future<void> clearMap(String key) async {
    final map = await LocalStorageManager.getMap(key);

    map?.clear();
    await LocalStorageManager.setMap(key, map!);
  }

  static Future<void> updateMap(String key, int value) async {
    final map = await LocalStorageManager.getMap(key);
    map?.update(key, (val) => value);

    await LocalStorageManager.setMap(key, map!);
  }
}

enum LocalStorage { token, login, userId }

extension LocalStorageExtension on LocalStorage {
  String get key {
    switch (this) {
      case LocalStorage.token:
        return 'token';
      case LocalStorage.login:
        return 'login';
      case LocalStorage.userId:
        return 'userId';
    }
  }
}
