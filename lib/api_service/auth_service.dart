import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;




class AuthService {

  static FirebaseAuth _auth = FirebaseAuth.instance;

  static  Future<void> userLogin({
    required String email,
    required String password
  }) async{

    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(err){
      throw '${err.message}';
    }
  }


  static  Future<void> userRegister({
    required String email,
    required String password,
    required String username,
    required XFile image
  }) async{
    try{
      final ref = FirebaseStorage.instance.ref().child('userImage/${image.name}');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();

      final response = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
            firstName: username,
            id: response.user!.uid,
            imageUrl: url,
            lastName: 'Doe',
            metadata: {
              'email': email,
              // 'middleName': ''
            }
        ),
      );


    }on FirebaseAuthException catch(err){
      throw '${err.message}';
    }
  }


  static  Future<void> userLogOut() async{
    try{
      await _auth.signOut();
    }on FirebaseAuthException catch(err){
      throw '${err.message}';
    }
  }



}