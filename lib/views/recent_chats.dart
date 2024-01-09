import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sk/provider/room_provider.dart';
import 'package:sk/views/chat_page.dart';


class RecentChats extends ConsumerWidget{
  const RecentChats({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(roomsStream);
    return Scaffold(
        body: SafeArea(
            child: state.when(data: (data){
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index){
                    final room = data[index];
                    return ListTile(
                      onTap: (){
                        Get.to(() => ChatPage(room: room), transition: Transition.leftToRight);
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(room.imageUrl!),
                      ),
                      title: Text(room.name!),
                    );
                  }
              );
            }, error: (err, st){
              return Center(child: Text('$err'));
            }, loading: () => Center(child: CircularProgressIndicator())
            )
        )
    );
  }
}
