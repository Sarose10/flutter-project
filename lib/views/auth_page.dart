import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sk/constants/app_sizes.dart';
import 'package:sk/provider/auth_provider.dart';
import 'package:sk/provider/other_provider.dart';



class AuthPage extends ConsumerStatefulWidget {

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if(next.hasError && !next.isLoading){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                duration: Duration(seconds: 5),
                content: Text(next.error.toString())
            )
        );
      }
    });
    final state = ref.watch(authProvider);
    final isLogin = ref.watch(loginProvider);
    final image = ref.watch(imageProvider);
    final isShow = ref.watch(toggleProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(isLogin ? 'Login Form': 'SignUp Form'),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: FormBuilder(
              key: _formKey,
              child: ListView(
                children: [

                  if(!isLogin)  FormBuilderTextField(
                    name: 'fullname',
                    decoration: const InputDecoration(labelText: 'FullName'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  AppSizes.gapH10,
                  FormBuilderTextField(
                    name: 'email',
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                  ),
                  AppSizes.gapH10,
                  FormBuilderTextField(
                    name: 'password',
                    obscureText: isShow ? false: true,
                    decoration:  InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: (){
                              ref.read(toggleProvider.notifier).change();
                            }, icon: Icon(isShow ?Icons.remove_red_eye: Icons.lock_open_sharp)),
                        labelText: 'Password'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                      FormBuilderValidators.maxLength(25),
                    ]),
                  ),
                  AppSizes.gapH20,
                  if(!isLogin) InkWell(
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
                          if(isLogin){
                            ref.read(authProvider.notifier).userLogin(
                                email: map['email'], password: map['password']
                            );
                          }else{
                            if(image == null){

                            }else{
                              ref.read(authProvider.notifier).userRegister(
                                  image: image,
                                  username: map['fullname'],
                                  email: map['email'],
                                  password: map['password']
                              );
                            }

                          }

                        }
                      }, child: state.isLoading ? Center(child: CircularProgressIndicator()): Text('submit')
                  ),
                  AppSizes.gapH16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(isLogin ? 'Don\'t have an Acoount': 'Already have an Acoount'),
                      TextButton(
                          style: TextButton.styleFrom(
                            // backgroundColor: Colors.white,
                            // foregroundColor: Colors.black,
                          ),
                          onPressed: (){
                            ref.read(loginProvider.notifier).change();
                          }, child: Text(isLogin ? 'Sign Up': 'Login'))

                    ],
                  )
                ],
              )
          ),
        )
    );
  }
}