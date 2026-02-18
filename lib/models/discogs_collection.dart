import 'collection_item.dart';
import 'pagination.dart';

class DiscogsCollection {
  final List<CollectionItem> items;
  final Pagination pagination;

  DiscogsCollection({required this.items, required this.pagination});

  factory DiscogsCollection.fromJson(Map<String, dynamic> json) {
    return DiscogsCollection(
      items: (json['releases'] as List)
          .map((item) => CollectionItem.fromJson(item))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}
