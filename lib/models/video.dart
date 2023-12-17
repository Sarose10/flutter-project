class Video {

  final String name;
  final String key;
  final String publishedAt;
  final String id;

  Video({
    required this.name,
    required this.key,
    required this.publishedAt,
    required this.id,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      name: json['name'],
      key: json['key'],
      publishedAt: json['published_at'],
      id: json['id'],
    );
  }
}