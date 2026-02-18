import 'dart:convert';
import 'package:oauth1/oauth1.dart' as oauth1;
import '../models/discogs_user.dart';
import '../models/discogs_collection.dart';

class DiscogsApiService {
  static const _consumerKey = 'vOMZRxwQHEwtWGNAzmzY';
  static const _consumerSecret = 'nBVwnBUmRadkGSkAdFnOQXsrbbrkvDgK';
  static const _baseUrl = 'https://api.discogs.com';

  final oauth1.Credentials _credentials;
  late final oauth1.Client _client;

  DiscogsApiService(this._credentials) {
    final platform = oauth1.Platform(
      'https://api.discogs.com/oauth/request_token',
      'https://www.discogs.com/oauth/authorize',
      'https://api.discogs.com/oauth/access_token',
      oauth1.SignatureMethods.hmacSha1,
    );

    final clientCredentials = oauth1.ClientCredentials(
      _consumerKey,
      _consumerSecret,
    );

    _client = oauth1.Client(
      platform.signatureMethod,
      clientCredentials,
      _credentials,
    );
  }

  Future<DiscogsUser> getUserIdentity() async {
    final response = await _client.get(Uri.parse('$_baseUrl/oauth/identity'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final user = DiscogsUser.fromJson(data);

      // Fetch full profile to get avatar_url
      final profileResponse = await _client.get(
        Uri.parse('$_baseUrl/users/${user.username}'),
      );

      if (profileResponse.statusCode == 200) {
        final profileData = json.decode(profileResponse.body);
        return DiscogsUser(
          id: user.id,
          username: user.username,
          name: user.name,
          email: user.email,
          avatarUrl: profileData['avatar_url'],
        );
      }

      return user;
    }

    throw Exception('Failed to fetch user identity: ${response.statusCode}');
  }

  Future<Map<String, dynamic>> getUserProfile(String username) async {
    final response = await _client.get(Uri.parse('$_baseUrl/users/$username'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    throw Exception('Failed to fetch user profile: ${response.statusCode}');
  }

  Future<DiscogsCollection> getUserCollection(
    String username, {
    int page = 1,
    int perPage = 50,
  }) async {
    final response = await _client.get(
      Uri.parse(
        '$_baseUrl/users/$username/collection/folders/0/releases?page=$page&per_page=$perPage',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DiscogsCollection.fromJson(data);
    }

    throw Exception('Failed to fetch collection: ${response.statusCode}');
  }

  Future<Map<String, dynamic>> getRelease(int releaseId) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/releases/$releaseId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    throw Exception('Failed to fetch release: ${response.statusCode}');
  }

  Future<Map<String, dynamic>> search(
    String query, {
    String? type,
    int page = 1,
    int perPage = 50,
  }) async {
    final uri = Uri.parse('$_baseUrl/database/search').replace(
      queryParameters: {
        'q': query,
        'page': page.toString(),
        'per_page': perPage.toString(),
        'type': ?type,
      },
    );

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    throw Exception('Failed to search: ${response.statusCode}');
  }
}
