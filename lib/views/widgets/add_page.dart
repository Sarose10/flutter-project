import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sk/constants/app_sizes.dart';
import 'package:sk/provider/auth_provider.dart';
import 'package:sk/provider/other_provider.dart';
import 'package:sk/provider/post_provider.dart';


class AddPage extends ConsumerStatefulWidget {

  @override
  ConsumerState<AddPage> createState() => _AddPageState();
}

class _AddPageState extends ConsumerState<AddPage> {
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
          title: Text('Add Form'),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: FormBuilder(
              key: _formKey,
              child: ListView(
                children: [


                  FormBuilderTextField(
                    name: 'title',
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  AppSizes.gapH10,
                  FormBuilderTextField(
                    name: 'detail',
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
                      child: image == null ? Center(child: Text('please select an image'))
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

                          }else{
                            ref.read(postProvider.notifier).addPost(
                                image: image,
                                title: map['title'],
                                detail: map['detail'],
                                userId: FirebaseAuth.instance.currentUser!.uid
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