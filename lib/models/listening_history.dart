class ListeningHistory {
  final String albumId;
  final String albumTitle;
  final String artistName;
  final String? coverImage;
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;

  ListeningHistory({
    required this.albumId,
    required this.albumTitle,
    required this.artistName,
    this.coverImage,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'albumTitle': albumTitle,
      'artistName': artistName,
      'coverImage': coverImage,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationSeconds': duration.inSeconds,
    };
  }

  factory ListeningHistory.fromJson(Map<String, dynamic> json) {
    return ListeningHistory(
      albumId: json['albumId'],
      albumTitle: json['albumTitle'],
      artistName: json['artistName'],
      coverImage: json['coverImage'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      duration: Duration(seconds: json['durationSeconds']),
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final startDate = DateTime(startTime.year, startTime.month, startTime.day);

    if (startDate == today) {
      return 'Hoje às ${_formatTime(startTime)}';
    } else if (startDate == yesterday) {
      return 'Ontem às ${_formatTime(startTime)}';
    } else {
      return '${startTime.day}/${startTime.month}/${startTime.year} às ${_formatTime(startTime)}';
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
