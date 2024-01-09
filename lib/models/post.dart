
class Post{
  final String title;
  final String id;
  final String detail;
  final String imageUrl;
  final String imageId;
  final String userId;
  final Like like;
  final List<Comment> comments;

  Post({
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
    return Like(
        likes: json['likes'],
        usernames: (json['usernames'] as List).map((e) => e as String).toList()
    );
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
  Map<String, dynamic> toMap(){
    return {'comment': this.comment, 'userImage': this.userImage, 'username': this.username};
  }

}