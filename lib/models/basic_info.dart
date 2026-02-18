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

  BasicInfo({
    required this.id,
    required this.title,
    required this.year,
    this.thumb,
    this.coverImage,
    required this.artists,
    required this.labels,
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
    );
  }
}
