import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypted_lib;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sipp_mobile/component/other/snackbar.dart';
import 'package:sipp_mobile/enums/local_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  CacheManager._private();

  static CacheManager instance = CacheManager._private();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  factory CacheManager() {
    return instance;
  }

  static encrypted_lib.Encrypter _generateCipher() {
    final key = encrypted_lib.Key.fromUtf8("s1ppm0b1l3k3yn0onekn0wsibelievei");
    final b64Key = encrypted_lib.Key.fromBase64(base64Url.encode(key.bytes));
    final fernetObj = encrypted_lib.Fernet(b64Key);
    final encrypter = encrypted_lib.Encrypter(fernetObj);
    return encrypter;
  }

  static Future<void> _writeUserData(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> _readUserData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(key);
    return username;
  }

  static Future<void> _deleteUserData(String key) async {
    await _storage.delete(key: key, aOptions: const AndroidOptions(encryptedSharedPreferences: true, keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding, storageCipherAlgorithm: StorageCipherAlgorithm.AES_CBC_PKCS7Padding));
  }

  Future<void> saveInitialUserData(String? token, String? fullName, String? email) async {
    await _writeUserData(SharedPrefs.isLogin.key, "true");
    await _writeUserData(SharedPrefs.token.key, token ?? "");
    await _writeUserData(SharedPrefs.fullName.key, fullName ?? "");
    await _writeUserData(SharedPrefs.email.key, email ?? "");
  }

  Future<bool> checkHasLogin() async {
    bool hasLogin = await _readUserData(SharedPrefs.isLogin.key) == "true";
    return hasLogin;
  }

  Future<String?> getUserToken() async {
    String? token = await _readUserData(SharedPrefs.token.key);
    return token;
  }

  Future<String?> getUserName() async {
    String? name = await _readUserData(SharedPrefs.fullName.key);
    return name;
  }

  Future<String?> getUserEmail() async {
    String? email = await _readUserData(SharedPrefs.email.key);
    return email;
  }

  Future<void> deleteUserSession() async {
    await _deleteUserData(SharedPrefs.fullName.key);
    await _deleteUserData(SharedPrefs.email.key);
    await _deleteUserData(SharedPrefs.token.key);
    await _deleteUserData(SharedPrefs.isLogin.key);
  }

}