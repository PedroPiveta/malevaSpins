import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

class AuthStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyToken = 'discogs_token';
  static const _keySecret = 'discogs_secret';

  static Future<void> saveCredentials(oauth1.Credentials credentials) async {
    await _storage.write(key: _keyToken, value: credentials.token);
    await _storage.write(key: _keySecret, value: credentials.tokenSecret);
  }

  static Future<oauth1.Credentials?> loadCredentials() async {
    final token = await _storage.read(key: _keyToken);
    final secret = await _storage.read(key: _keySecret);

    if (token != null && secret != null) {
      return oauth1.Credentials(token, secret);
    }

    return null;
  }

  static Future<void> clearCredentials() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keySecret);
  }

  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _keyToken);
    return token != null;
  }
}
