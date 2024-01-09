
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sk/provider/auth_provider.dart';
import 'package:sk/provider/other_provider.dart';
import 'package:sk/provider/post_provider.dart';
import 'package:sk/views/detail_page.dart';
import 'package:sk/views/recent_chats.dart';
import 'package:sk/views/user_detail.dart';
import 'package:sk/views/widgets/add_page.dart';
import 'package:sk/views/widgets/update_page.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;



class HomePage extends ConsumerWidget{


  types.User? user;

  @override
  Widget build(BuildContext context, ref) {

    final state = ref.watch(friendStream);
    final userData = ref.watch(userProfile(FirebaseAuth.instance.currentUser!.uid));
    final posts = ref.watch(postsStream);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    //final st = ref.watch(commentProvider);

    final mode = ref.watch(toggleThemeProvider);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){
              ref.read(toggleThemeProvider.notifier).change();
            }, icon: Icon(mode ? Icons.dark_mode: Icons.light_mode))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              userData.when(
                  data: (data){
                    user= data;
                    return DrawerHeader(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                                image: NetworkImage(data.imageUrl!))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(data.firstName!),
                            Text(data.metadata!['email']),
                          ],));
                  },
                  error: (err, st) => Center(child: Text('$err')),
                  loading: () => Center(child: CircularProgressIndicator())),
              ListTile(
                onTap: (){
                  Navigator.of(context).pop();
                  Get.to(() => RecentChats(), transition:  Transition.leftToRight);
                },
                title: Text('Recent Chats'),
                leading: Icon(Icons.chat),
              ),
              ListTile(
                onTap: (){
                  Navigator.of(context).pop();
                  Get.to(() => AddPage(), transition:  Transition.leftToRight);
                },
                title: Text('add post'),
                leading: Icon(Icons.add),
              ),
              ListTile(
                onTap: (){

                  ref.read(authProvider.notifier).userLogOut();
                },
                title: Text('User LogOut'),
                leading: Icon(Icons.exit_to_app),
              )
            ],
          ),
        ),
        body: Scaffold(
            body: Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: 120,
                    child: state.when(
                        data: (data){
                          return ListView.separated(
                              separatorBuilder: (c, i){
                                return SizedBox(width: 20,);
                              },
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (context, index){
                                final useData = data[index];
                                return InkWell(
                                  onTap: (){
                                    Get.to(() => UserDetail(user: useData));
                                  },
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(useData.imageUrl!),
                                      ),
                                      Text(useData.firstName!)
                                    ],
                                  ),
                                );
                              }
                          );
                        },
                        error: (err, st) => Center(child: Text('$err')),
                        loading: () => Center(child: Container())
                    )
                ),
                // ElevatedButton(onPressed: (){}, child: Text('aslkdjlsadklkj')),
                // OutlinedButton(onPressed: (){}, child: Text('a;skd;slak')),
                // TextButton(onPressed: (){}, child: Text('sd;lk')),
                // IconButton(onPressed: (){}, icon: Icon(Icons.favorite)),
                // FilledButton(onPressed: (){}, child: Text('aslkdjlks')),
                // ExpansionTile(title: Text('show list'), children: [
                //   Text('1'),
                //   Text('2'),
                //   Text('3'),
                // ]),
                Expanded(
                    child: posts.when(
                        data: (data){
                          return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, index){
                                final post = data[index];
                                return MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: (){
                                    Get.to(() => DetailPage(id: post.id, user: user!), transition: Transition.leftToRight);
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(post.title),
                                              if(userId == post.userId)   ElevatedButton(onPressed: (){
                                                Get.defaultDialog(
                                                    title: 'Customize',
                                                    content: Text('Edit or remove'),
                                                    actions: [
                                                      IconButton(onPressed: (){
                                                        Navigator.of(context).pop();
                                                        Get.to(() => UpdatePage(post), transition:  Transition.leftToRight);
                                                      }, icon: Icon(Icons.edit)),
                                                      IconButton(onPressed: (){
                                                        Navigator.of(context).pop();
                                                        Get.defaultDialog(
                                                            title: 'Hold On',
                                                            content: Text('Are u sure to remove ?'),
                                                            actions: [
                                                              TextButton(onPressed: (){
                                                                Navigator.of(context).pop();
                                                              }, child: Text('Cancel')),
                                                              TextButton(onPressed: (){
                                                                Navigator.of(context).pop();
                                                              }, child: Text('Sure')),

                                                            ]
                                                        );
                                                      }, icon: Icon(Icons.delete)),
                                                    ]
                                                );
                                              }, child: Icon(Icons.more_horiz_rounded))
                                            ],
                                          ),
                                          CachedNetworkImage(
                                            placeholder: (e,s){
                                              return Center(child: CircularProgressIndicator());
                                            },
                                            imageUrl: post.imageUrl, height: 300,),
                                          Row(
                                            children: [
                                              Expanded(child: Text(post.detail)),
                                              if(userId != post.userId)  Row(
                                                children: [
                                                  IconButton(onPressed: (){
                                                    if(post.like.usernames.contains(user?.firstName)){
                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                          duration: Duration(seconds: 1),
                                                          content: Text('You have already like this post')));
                                                    }else{
                                                      ref.read(postProvider.notifier).likePost(
                                                          postId: post.id,
                                                          prevLike: post.like.likes,
                                                          usernames: [...post.like.usernames, user!.firstName!]
                                                      );
                                                    }
                                                  }, icon: Icon(Icons.thumb_up_alt_outlined)),
                                                  Text(post.like.likes > 0 ?  '${post.like.likes}': '')
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        error:(err,st) => Center(child: Text('$err')),
                        loading: () => Center(child: CircularProgressIndicator())
                    )
                ),
              ],
            )
        )
    );
  }
}

