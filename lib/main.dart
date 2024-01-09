import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sk/firebase_options.dart';
import 'package:sk/provider/other_provider.dart';
import 'package:sk/views/status_page.dart';



void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  await Future.delayed(Duration(milliseconds: 500));
  runApp(ProviderScope(child: Home()));
}


class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final mode = ref.watch(toggleThemeProvider);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mode ? ThemeData.dark(
        useMaterial3: true,
      ): ThemeData.light(useMaterial3: true),
      home: StatusPage(),
    );
  }
}


class Counter extends StatelessWidget {

  final numControl = StreamController<int>();
  int n = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stream'),),
      body: StreamBuilder(
          stream: numControl.stream,
          builder: (context, snapshot) {
            print(snapshot.data);
            return Center(child: Text('${snapshot.data}', style: TextStyle(fontSize: 50),));
          }
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            numControl.sink.add(n++);
          }, child: Icon(Icons.add)),
    );
  }
}