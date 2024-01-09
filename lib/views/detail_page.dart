import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sk/constants/app_sizes.dart';
import 'package:sk/models/post.dart';
import 'package:sk/provider/post_provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class DetailPage extends ConsumerWidget {
  final String id;
  final types.User user;
  DetailPage({super.key, required this.id, required this.user});

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(postProvider, (previous, next) {
      if(next.hasError && !next.isLoading){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                duration: Duration(seconds: 1),
                content: Text(next.error.toString())
            )
        );
      }
    });
    final state = ref.watch(singlePostStream(id));
    return Scaffold(
        body: SafeArea(
            child: state.when(
                data: (data){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl:data.imageUrl,
                        placeholder: (c, s) => Center(child: CircularProgressIndicator()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(data.title),
                          ],
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          onFieldSubmitted: (val){
                            if(val.isEmpty && val.length < 10){

                            }else{
                              final newComment = Comment(comment: val.toString(), userImage: user.imageUrl!, username: user.firstName!);
                              ref.read(postProvider.notifier).addComment(postId: id, comments: [...data.comments, newComment]);
                            }
                          },
                          decoration: InputDecoration(
                              hintText: 'add a comment'
                          ),
                        ),
                      ),
                      AppSizes.gapH22,
                      Expanded(
                          child: ListView.builder(
                              itemCount: data.comments.length,
                              itemBuilder: (context, index){
                                final comment = data.comments[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(comment.userImage),
                                  ),
                                  title: Text(comment.username),
                                  subtitle: Text(comment.comment),
                                );
                              })
                      )
                    ],
                  );
                },
                error: (err, st) => Center(child: Text('$err')),
                loading: () => Center(child: CircularProgressIndicator())
            ))
    );
  }
}