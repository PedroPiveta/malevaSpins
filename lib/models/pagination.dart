class Pagination {
  final int page;
  final int pages;
  final int perPage;
  final int items;

  Pagination({
    required this.page,
    required this.pages,
    required this.perPage,
    required this.items,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      pages: json['pages'],
      perPage: json['per_page'],
      items: json['items'],
    );
  }
}
