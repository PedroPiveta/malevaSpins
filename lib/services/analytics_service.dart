import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/rendering.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ── Auth ──────────────────────────────────────────────────────────────────

  Future<void> logLogin() async {
    await _analytics.logLogin(loginMethod: 'discogs_oauth');
    debugPrint("Logged login event with method: discogs_oauth");
  }

  Future<void> logLoginError(String reason) async {
    await _analytics.logEvent(
      name: 'login_error',
      parameters: {'reason': reason},
    );
    debugPrint("Logged login_error event with reason: $reason");
  }

  Future<void> logLogout() async {
    await _analytics.logEvent(name: 'logout');
    debugPrint("Logged logout event");
  }

  // ── Collection ────────────────────────────────────────────────────────────

  Future<void> logCollectionLoaded(int itemCount) async {
    await _analytics.logEvent(
      name: 'collection_loaded',
      parameters: {'item_count': itemCount},
    );
    debugPrint("Logged collection_loaded event with itemCount: $itemCount");
  }

  Future<void> logAlbumViewed({
    required String albumId,
    required String albumTitle,
    required String artistName,
  }) async {
    await _analytics.logEvent(
      name: 'album_viewed',
      parameters: {
        'album_id': albumId,
        'album_title': albumTitle,
        'artist_name': artistName,
      },
    );
    debugPrint(
      "Logged album_viewed event for albumId: $albumId, albumTitle: $albumTitle, artistName: $artistName",
    );
  }

  // ── Listening ─────────────────────────────────────────────────────────────

  Future<void> logListeningStarted({
    required String albumId,
    required String albumTitle,
    required String artistName,
  }) async {
    await _analytics.logEvent(
      name: 'listening_started',
      parameters: {
        'album_id': albumId,
        'album_title': albumTitle,
        'artist_name': artistName,
      },
    );
    debugPrint(
      "Logged listening_started event for albumId: $albumId, albumTitle: $albumTitle, artistName: $artistName",
    );
  }

  Future<void> logListeningStopped({
    required String albumId,
    required int durationSeconds,
  }) async {
    await _analytics.logEvent(
      name: 'listening_stopped',
      parameters: {'album_id': albumId, 'duration_seconds': durationSeconds},
    );
    debugPrint(
      "Logged listening_stopped event for albumId: $albumId, durationSeconds: $durationSeconds",
    );
  }
}
