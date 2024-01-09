import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:sk/api_service/room_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
part 'room_provider.g.dart';
final roomsStream = StreamProvider((ref) => FirebaseChatCore.instance.rooms());
final messageStream = StreamProvider.family((ref, types.Room room) => FirebaseChatCore.instance.messages(room));

//
// final singleRoomStream = StreamProvider.family((ref, String userId) {
//   final datas = FirebaseFirestore.instance.collection('rooms').where('userIds',arrayContains: userId).snapshots();
//   // return  datas.map((event) => event.docs.map((e) {
//   //   final json = e.data();
//   //   return Post(
//   //       imageUrl: json['imageUrl'],
//   //       title: json['title'],
//   //       detail: json['detail'],
//   //       id: e.id,
//   //       imageId: json['imageId'],
//   //       userId: json['userId'],
//   //       like: Like.fromJson(json['like']),
//   //       comments: (json['comments'] as List).map((e) => Comment.fromJson(e)).toList()
//   //   );
//   // }).toList());
// });




@riverpod
class RoomNotify extends _$RoomNotify {
  @override
  FutureOr build() async {
    return ;
  }
  Future<void> roomCreate({
    required types.User user,
  }) async{
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => RoomService.roomCreate(user: user));
  }


}
