import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sk/constants/app_sizes.dart';
import 'package:sk/models/post.dart';
import 'package:sk/provider/other_provider.dart';
import 'package:sk/provider/post_provider.dart';


class UpdatePage extends ConsumerStatefulWidget {
  final Post post;
  UpdatePage(this.post);

  @override
  ConsumerState<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends ConsumerState<UpdatePage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    ref.listen(postProvider, (previous, next) {
      if(next.hasError && !next.isLoading){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                duration: Duration(seconds: 5),
                content: Text(next.error.toString())
            )
        );
      }else if(!next.hasError && !next.isLoading){
        Get.back();
      }
    });
    final state = ref.watch(postProvider);
    final image = ref.watch(imageProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text('Update Form'),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: FormBuilder(
              key: _formKey,
              child: ListView(
                children: [


                  FormBuilderTextField(
                    name: 'title',
                    keyboardType: TextInputType.text,
                    initialValue: widget.post.title,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  AppSizes.gapH10,
                  FormBuilderTextField(
                    name: 'detail',
                    initialValue: widget.post.detail,
                    decoration: const InputDecoration(labelText: 'Detail'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      // FormBuilderValidators.minLength(6),
                      // FormBuilderValidators.maxLength(25),
                    ]),
                  ),
                  AppSizes.gapH20,
                  InkWell(
                    onTap: (){
                      ref.read(imageProvider.notifier).pickImage();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)
                      ),
                      height: 140,
                      width: double.infinity,
                      child: image == null ? Image.network(widget.post.imageUrl)
                          : Image.file(File(image.path))
                      ,
                    ),
                  ),
                  AppSizes.gapH20,
                  ElevatedButton(
                      onPressed: (){
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState?.saveAndValidate(focusOnInvalid: false) ?? false) {
                          final map = _formKey.currentState!.value;

                          if(image == null){
                            ref.read(postProvider.notifier).updatePost(
                                title: map['title'],
                                detail: map['detail'],
                                postId: widget.post.id
                            );
                          }else{
                            ref.read(postProvider.notifier).updatePost(
                              image: image,
                              title: map['title'],
                              detail: map['detail'],
                              postId: widget.post.id,
                              imageId: widget.post.imageId,
                            );
                          }



                        }
                      }, child: state.isLoading ? Center(child: CircularProgressIndicator()): Text('submit')
                  ),
                  AppSizes.gapH16,

                ],
              )
          ),
        )
    );
  }
}