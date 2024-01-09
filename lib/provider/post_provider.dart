import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sk/api_service/post_service.dart';
import 'package:sk/models/post.dart';



final postProvider = AsyncNotifierProvider(() => PostProvider());
final postsStream = StreamProvider((ref) => PostService.getPosts());


final getPostByUser = StreamProvider.family((ref, String userId) {
  final datas = FirebaseFirestore.instance.collection('posts').where('userId',isEqualTo: userId).snapshots();
  return  datas.map((event) => event.docs.map((e) {
    final json = e.data();
    return Post(
        imageUrl: json['imageUrl'],
        title: json['title'],
        detail: json['detail'],
        id: e.id,
        imageId: json['imageId'],
        userId: json['userId'],
        like: Like.fromJson(json['like']),
        comments: (json['comments'] as List).map((e) => Comment.fromJson(e)).toList()
    );
  }).toList());
});


final singlePostStream = StreamProvider.family((ref, String id) {
  final postDb = FirebaseFirestore.instance.collection('posts');

  return  postDb.doc(id).snapshots().map((e){
    final json = e.data() as Map<String, dynamic>;
    return Post(
        imageUrl: json['imageUrl'],
        title: json['title'],
        detail: json['detail'],
        id: e.id,
        imageId: json['imageId'],
        userId: json['userId'],
        like: Like.fromJson(json['like']),
        comments: (json['comments'] as List).map((e) => Comment.fromJson(e)).toList()
    );
  });
});



class PostProvider extends AsyncNotifier{

  @override
  FutureOr build() {

  }

  Future<void> addPost({
    required String title,
    required String detail,
    required String userId,
    required XFile image
  }) async{
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => PostService.addPost(title: title, detail: detail, userId: userId, image: image));
  }

  Future<void> removePost({
    required String postId,
    required String imageId
  }) async{
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => PostService.removePost(postId: postId, imageId: imageId));
  }

  Future<void> updatePost({
    required String title,
    required String detail,
    required String postId,
    XFile? image,
    String? imageId
  }) async{
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => PostService.updatePost(
        imageId: imageId,
        image: image,
        title: title, detail: detail, postId: postId));
  }


  Future<void> likePost({
    required String postId,
    required int prevLike,
    required List<String> usernames
  }) async{
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => PostService.likePost(
        postId: postId, prevLike: prevLike, usernames: usernames));
  }

  Future<void> addComment({
    required String postId,
    required List<Comment> comments
  }) async{
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => PostService.addComment(postId: postId, comments: comments));
  }

}