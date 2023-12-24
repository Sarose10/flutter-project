import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sk/constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';


void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  await Future.delayed(Duration(milliseconds: 500));
  runApp(ProviderScope(child: Home()));
}


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Raleway',
        colorSchemeSeed: AppColors.mainColor,
        scaffoldBackgroundColor: AppColors.backGroundColor,
      ),

    );
  }
}