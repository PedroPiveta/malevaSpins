import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

class DiscogsAuthService {
  static const _callbackScheme = 'maleva';
  static const _consumerKey = 'vOMZRxwQHEwtWGNAzmzY';
  static const _consumerSecret = 'nBVwnBUmRadkGSkAdFnOQXsrbbrkvDgK';

  final oauth1.Platform _platform = oauth1.Platform(
    'https://api.discogs.com/oauth/request_token',
    'https://www.discogs.com/oauth/authorize',
    'https://api.discogs.com/oauth/access_token',
    oauth1.SignatureMethods.hmacSha1,
  );

  late final oauth1.Authorization _authorization;
  final _appLinks = AppLinks();
  StreamSubscription? _sub;

  DiscogsAuthService() {
    final credentials = oauth1.ClientCredentials(_consumerKey, _consumerSecret);
    _authorization = oauth1.Authorization(credentials, _platform);
  }

  Future<oauth1.Credentials> login() async {
    try {
      final authResponse = await _authorization.requestTemporaryCredentials(
        '$_callbackScheme://callback',
      );

      final tempCredentials = authResponse.credentials;

      final authUrl = _authorization.getResourceOwnerAuthorizationURI(
        tempCredentials.token,
      );

      final completer = Completer<Uri>();

      _sub?.cancel();

      _sub = _appLinks.uriLinkStream.listen(
        (Uri uri) {
          if (uri.scheme == _callbackScheme) {
            if (!completer.isCompleted) {
              completer.complete(uri);
            }
            _sub?.cancel();
          }
        },
        onError: (err) {
          if (!completer.isCompleted) {
            completer.completeError(err);
          }
        },
      );

      try {
        await launchUrl(
          Uri.parse(authUrl),
          mode: LaunchMode.externalApplication,
        );
      } catch (launchError) {
        try {
          await launchUrl(Uri.parse(authUrl), mode: LaunchMode.platformDefault);
        } catch (e2) {
          _sub?.cancel();
          throw Exception('Não foi possível abrir o navegador: $e2');
        }
      }

      final uri = await completer.future.timeout(
        const Duration(minutes: 5),
        onTimeout: () {
          _sub?.cancel();
          throw Exception('Timeout - usuário não autorizou a tempo');
        },
      );

      final verifier = uri.queryParameters['oauth_verifier'];

      if (verifier == null || verifier.isEmpty) {
        throw Exception('OAuth verifier não encontrado na URL de callback');
      }

      final tokenResponse = await _authorization.requestTokenCredentials(
        tempCredentials,
        verifier,
      );

      return tokenResponse.credentials;
    } catch (e) {
      _sub?.cancel();
      rethrow;
    }
  }

  void dispose() {
    _sub?.cancel();
  }
}
