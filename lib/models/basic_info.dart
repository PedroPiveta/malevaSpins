import 'package:maleva_spins/models/track.dart';

import 'artist.dart';
import 'label.dart';

class BasicInfo {
  final int id;
  final String title;
  final int year;
  final String? thumb;
  final String? coverImage;
  final List<Artist> artists;
  final List<Label> labels;
  final List<Track>? tracklist;

  BasicInfo({
    required this.id,
    required this.title,
    required this.year,
    this.thumb,
    this.coverImage,
    required this.artists,
    required this.labels,
    this.tracklist,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      id: json['id'],
      title: json['title'],
      year: json['year'],
      thumb: json['thumb'],
      coverImage: json['cover_image'],
      artists: (json['artists'] as List)
          .map((a) => Artist.fromJson(a))
          .toList(),
      labels: (json['labels'] as List).map((l) => Label.fromJson(l)).toList(),
      tracklist: json['tracklist'] != null
          ? (json['tracklist'] as List)
                .map((t) => Track(title: t['title'], duration: t['duration']))
                .toList()
          : null,
    );
  }
}
