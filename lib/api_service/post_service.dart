import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sk/models/post.dart';




class PostService {

  static final  _db = FirebaseFirestore.instance.collection('posts');

  static Stream<List<Post>> getPosts(){
    return  _db.snapshots().map((event) => event.docs.map((e) {
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
  }


  static  Future<void> addPost({
    required String title,
    required String detail,
    required String userId,
    required XFile image
  }) async{
    try{
      final imageId = DateTime.now().toString();
      final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      await _db.add({
        'title': title,
        'detail': detail,
        'imageUrl': url,
        'imageId': imageId,
        'userId': userId,
        'like': {
          'likes': 0,
          'usernames': []
        },
        'comments': []
      });

    }on FirebaseException catch(err){
      throw '${err.message}';
    }
  }




  static  Future<void> likePost({
    required String postId,
    required int prevLike,
    required List<String> usernames
  }) async{
    try{

      await  _db.doc(postId).update({
        'like': {
          'likes': prevLike + 1,
          'usernames': usernames
        },
      });
    }on FirebaseException catch(err){
      throw '${err.message}';
    }
  }


  static  Future<void> addComment({
    required String postId,
    required List<Comment> comments
  }) async{
    try{

      await  _db.doc(postId).update({
        'comments': comments.map((e) => e.toMap()).toList()
      });
    }on FirebaseException catch(err){
      throw '${err.message}';
    }
  }


  static  Future<void> removePost({
    required String postId,
    required String imageId
  }) async{
    try{

      final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
      await ref.delete();
      await  _db.doc(postId).delete();
    }on FirebaseException catch(err){
      throw '${err.message}';
    }
  }


  static  Future<void> updatePost({
    required String title,
    required String detail,
    required String postId,
    XFile? image,
    String? imageId
  }) async{
    try{
      if(image == null){
        await _db.doc(postId).update({
          'title': title,
          'detail': detail
        });
      }else {
        final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
        await ref.delete();
        final newImageId = DateTime.now().toString();
        final ref1 = FirebaseStorage.instance.ref().child('postImage/$newImageId');
        await ref1.putFile(File(image.path));
        final url = await ref1.getDownloadURL();
        await _db.doc(postId).update({
          'title': title,
          'detail': detail,
          'imageUrl': url,
          'imageId': newImageId
        });
      }

    }on FirebaseException catch(err){
      throw '${err.message}';
    }
  }



}