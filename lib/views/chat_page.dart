import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sk/provider/room_provider.dart';



class ChatPage extends ConsumerStatefulWidget {
  final types.Room room;
  const ChatPage({super.key, required this.room});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  bool isLoad = false;
  @override
  Widget build(BuildContext context) {
    final msgStream = ref.watch(messageStream(widget.room));
    return Scaffold(
        body: SafeArea(
            child: SafeArea(
                child: msgStream.when(
                    data: (data){
                      return Chat(
                        showUserAvatars: true,
                        showUserNames: true,
                        isAttachmentUploading: isLoad,
                        messages: data,
                        onAttachmentPressed: () {
                          setState(() {
                            isLoad = true;
                          });
                          final picker = ImagePicker();
                          picker.pickImage(source: ImageSource.gallery).then((value) async{
                            if(value != null) {
                              //print(File(value.path).lengthSync()/1024/1024);
                              final ref = FirebaseStorage.instance.ref().child('chatImage/${value.name}');
                              await ref.putFile(File(value.path));
                              final url = await ref.getDownloadURL();
                              final message = types.PartialImage(
                                name: value.name,
                                size: File(value.path).lengthSync(),
                                uri: url,
                              );
                              FirebaseChatCore.instance.sendMessage(
                                  message,
                                  widget.room.id);
                              setState(() {
                                isLoad = false;
                              });
                            }
                          });
                        },
                        onSendPressed: (val){
                          FirebaseChatCore.instance.sendMessage(val, widget.room.id);
                        },
                        user: types.User(
                            id: FirebaseAuth.instance.currentUser!.uid
                        ),
                      );
                    },
                    error: (err, st) => Center(child: Text('$err')),
                    loading: () => Center(child: CircularProgressIndicator())
                )
            ))
    );
  }
}