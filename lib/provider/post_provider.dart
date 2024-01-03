import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sk/api_service/PostService.dart';



final productProvider = AsyncNotifierProvider(() => ProductProvider());
final productsStream = StreamProvider((ref) => ProductService.getProducts());

class ProductProvider extends AsyncNotifier{

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
    state = await AsyncValue.guard(() => ProductService.addPost(title: title, detail: detail, userId: userId, image: image));
  }

  Future<void> removePost({
    required String postId,
    required String imageId
  }) async{
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ProductService.removePost(postId: postId, imageId: imageId));
  }

  Future<void> updatePost({
    required String title,
    required String detail,
    required String postId,
    XFile? image,
    String? imageId
  }) async{
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ProductService.updatePost(title: title, detail: detail, postId: postId));
  }


}