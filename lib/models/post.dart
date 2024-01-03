
class Product{
  final String title;
  final String id;
  final String detail;
  final String imageUrl;
  final String imageId;
  final String userId;
  final Like like;
  final List<Comment> comments;

  Product({
    required this.imageUrl,
    required this.title,
    required this.detail,
    required this.id,
    required this.imageId,
    required this.userId,
    required this.like,
    required this.comments
  });

}


class Like{
  final int likes;
  final List<String> usernames;

  Like({
    required this.likes,
    required this.usernames
  });

  factory Like.fromJson(Map<String, dynamic> json){
    return Like(likes: json['likes'], usernames: json['usernames']);
  }

}

class Comment{
  final String comment;
  final String userImage;
  final String username;
  Comment({
    required this.comment,
    required this.userImage,
    required this.username
  });
  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(comment: json['comment'], userImage: json['userImage'], username: json['username']);
  }

}