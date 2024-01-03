import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sk/provider/auth_provider.dart';




class HomePage extends ConsumerWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {

    final state = ref.watch(friendStream);
    final userData = ref.watch(userProfile(FirebaseAuth.instance.currentUser!.uid));
    print(userData);
    return Scaffold(
        appBar: AppBar(

        ),
        drawer: Drawer(
          child: ListView(
            children: [
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
            body: Container(
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
                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(useData.imageUrl!),
                                ),
                                Text(useData.firstName!)
                              ],
                            );
                          }
                      );
                    },
                    error: (err, st) => Center(child: Text('$err')),
                    loading: () => Center(child: CircularProgressIndicator())
                )
            )
        )
    );
  }
}