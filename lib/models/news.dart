class News{
  final String title;
  final String detail;
  final String urlToImage;

  News({
    required this.detail,
    required this.title,
    required this.urlToImage
  });

  factory News.fromJson(Map<String, dynamic> json){
    return News(
        detail: json['detail'] ?? '',
        title: json['title'] ?? '',
        urlToImage: json['urlToImage'] ?? ''
    );
  }
}