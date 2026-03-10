import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/listening_session.dart';
import '../models/listening_history.dart';

class ListeningTimerService extends ChangeNotifier {
  static final ListeningTimerService _instance =
      ListeningTimerService._internal();
  factory ListeningTimerService() => _instance;
  ListeningTimerService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  ListeningSession? _currentSession;
  Timer? _timer;
  Duration _totalListeningTime = Duration.zero;
  List<ListeningHistory> _history = [];

  ListeningSession? get currentSession => _currentSession;
  Duration get totalListeningTime => _totalListeningTime;
  bool get isPlaying => _currentSession != null;
  List<ListeningHistory> get history => _history;

  // Calcula o tempo total incluindo a sessão atual
  Duration get totalTimeWithCurrent {
    if (_currentSession != null) {
      return _totalListeningTime + _currentSession!.elapsedTime;
    }
    return _totalListeningTime;
  }

  Future<void> initialize() async {
    // Inicializar notificações
    await _initializeNotifications();

    // Carregar dados salvos
    await _loadSession();
    await _loadTotalTime();
    await _loadHistory();

    // Iniciar timer se houver sessão ativa
    if (_currentSession != null) {
      _startTimer();
      await _showNotification();
    }
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings: initSettings);

    // Criar canal de notificação no Android
    const androidChannel = AndroidNotificationChannel(
      'listening_timer',
      'Timer de Audição',
      description: 'Mostra o álbum que você está ouvindo',
      importance: Importance.low,
      playSound: false,
      enableVibration: false,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> startListening({
    required String albumId,
    required String albumTitle,
    required String artistName,
    String? coverImage,
  }) async {
    // Parar sessão anterior se existir
    if (_currentSession != null) {
      await stopListening();
    }

    _currentSession = ListeningSession(
      albumId: albumId,
      albumTitle: albumTitle,
      artistName: artistName,
      coverImage: coverImage,
      startTime: DateTime.now(),
    );

    await _saveSession();
    _startTimer();
    await _showNotification();
    notifyListeners();
  }

  Future<void> stopListening() async {
    if (_currentSession != null) {
      final elapsed = _currentSession!.elapsedTime;

      // Adicionar tempo da sessão atual ao total
      _totalListeningTime += elapsed;
      await _saveTotalTime();

      // Adicionar ao histórico
      final historyEntry = ListeningHistory(
        albumId: _currentSession!.albumId,
        albumTitle: _currentSession!.albumTitle,
        artistName: _currentSession!.artistName,
        coverImage: _currentSession!.coverImage,
        startTime: _currentSession!.startTime,
        endTime: DateTime.now(),
        duration: elapsed,
      );

      _history.insert(0, historyEntry); // Adiciona no início
      await _saveHistory();
    }

    _currentSession = null;
    _timer?.cancel();
    _timer = null;

    await _clearSession();
    await _cancelNotification();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      notifyListeners();
      _updateNotification();
    });
  }

  Future<void> _showNotification() async {
    if (_currentSession == null) return;

    final session = _currentSession!;
    final elapsed = session.elapsedTime;

    AndroidNotificationDetails androidDetails;
    if (session.coverImage != null && session.coverImage!.isNotEmpty) {
      androidDetails = AndroidNotificationDetails(
        'listening_timer',
        'Timer de Audição',
        channelDescription: 'Mostra o álbum que você está ouvindo',
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        autoCancel: false,
        playSound: false,
        enableVibration: false,
        showWhen: false,
        styleInformation: BigPictureStyleInformation(
          FilePathAndroidBitmap(session.coverImage!),
          contentTitle: session.albumTitle,
          summaryText: '${session.artistName} • ${formatDuration(elapsed)}',
        ),
      );
    } else {
      androidDetails = const AndroidNotificationDetails(
        'listening_timer',
        'Timer de Audição',
        channelDescription: 'Mostra o álbum que você está ouvindo',
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        autoCancel: false,
        playSound: false,
        enableVibration: false,
        showWhen: false,
      );
    }

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id: 0,
      title: session.albumTitle,
      body: '${session.artistName} • ${formatDuration(elapsed)}',
      notificationDetails: details,
      payload: null,
    );
  }

  Future<void> _updateNotification() async {
    await _showNotification();
  }

  Future<void> _cancelNotification() async {
    await _notificationsPlugin.cancel(id: 0);
  }

  Future<void> _saveSession() async {
    if (_currentSession == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'current_listening_session',
      jsonEncode(_currentSession!.toJson()),
    );
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString('current_listening_session');
    if (sessionJson != null) {
      try {
        _currentSession = ListeningSession.fromJson(jsonDecode(sessionJson));
      } catch (e) {
        debugPrint('Erro ao carregar sessão: $e');
        await _clearSession();
      }
    }
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_listening_session');
  }

  Future<void> _saveTotalTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'total_listening_seconds',
      _totalListeningTime.inSeconds,
    );
  }

  Future<void> _loadTotalTime() async {
    final prefs = await SharedPreferences.getInstance();
    final seconds = prefs.getInt('total_listening_seconds') ?? 0;
    _totalListeningTime = Duration(seconds: seconds);
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = _history.map((e) => e.toJson()).toList();
    await prefs.setString('listening_history', jsonEncode(historyJson));
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('listening_history');
    if (historyJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(historyJson);
        _history = decoded.map((e) => ListeningHistory.fromJson(e)).toList();
      } catch (e) {
        debugPrint('Erro ao carregar histórico: $e');
        _history = [];
      }
    }
  }

  Future<void> clearHistory() async {
    _history.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('listening_history');
    notifyListeners();
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
