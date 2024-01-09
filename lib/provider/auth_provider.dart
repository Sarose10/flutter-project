import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sk/api_service/auth_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;



final userStream = StreamProvider.autoDispose((ref) => FirebaseAuth.instance.authStateChanges());
final friendStream = StreamProvider.autoDispose((ref) => FirebaseChatCore.instance.users());


final userProfile = StreamProvider.family((ref, String id) {
  final userDb = FirebaseFirestore.instance.collection('users');
  return  userDb.doc(id).snapshots().map((event){
    final json = event.data() as Map<String, dynamic>;
    return types.User(
        id: event.id,
        firstName: json['firstName'],
        imageUrl: json['imageUrl'],
        lastName: json['lastName'],
        metadata: json['metadata']
    );
  });
});


final authProvider = AsyncNotifierProvider(() => AuthProvider());
class AuthProvider extends AsyncNotifier{

  @override
  FutureOr build() {

  }

  Future<void> userLogin({
    required String email,
    required String password
  }) async{
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => AuthService.userLogin(email: email, password: password));
  }

  Future<void>userRegister({
    required String email,
    required String password,
    required String username,
    required XFile image
  }) async{
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => AuthService.userRegister(email: email, password: password, username: username, image: image));
  }

  Future<void> userLogOut() async{
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => AuthService.userLogOut());
  }


}