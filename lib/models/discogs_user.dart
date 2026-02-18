class DiscogsUser {
  final int id;
  final String username;
  final String? name;
  final String? email;
  final String? avatarUrl;

  DiscogsUser({
    required this.id,
    required this.username,
    this.name,
    this.email,
    this.avatarUrl,
  });

  factory DiscogsUser.fromJson(Map<String, dynamic> json) {
    return DiscogsUser(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
    );
  }
}
