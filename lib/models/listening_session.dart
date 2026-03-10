class ListeningSession {
  final String albumId;
  final String albumTitle;
  final String artistName;
  final String? coverImage;
  final DateTime startTime;

  ListeningSession({
    required this.albumId,
    required this.albumTitle,
    required this.artistName,
    this.coverImage,
    required this.startTime,
  });

  Duration get elapsedTime => DateTime.now().difference(startTime);

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'albumTitle': albumTitle,
      'artistName': artistName,
      'coverImage': coverImage,
      'startTime': startTime.toIso8601String(),
    };
  }

  factory ListeningSession.fromJson(Map<String, dynamic> json) {
    return ListeningSession(
      albumId: json['albumId'],
      albumTitle: json['albumTitle'],
      artistName: json['artistName'],
      coverImage: json['coverImage'],
      startTime: DateTime.parse(json['startTime']),
    );
  }
}
