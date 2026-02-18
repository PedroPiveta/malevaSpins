class Label {
  final String name;
  final String? catno;

  Label({required this.name, this.catno});

  factory Label.fromJson(Map<String, dynamic> json) {
    return Label(name: json['name'], catno: json['catno']);
  }
}
