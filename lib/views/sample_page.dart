import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sk/provider/api_provider.dart';



class SamplePage extends ConsumerWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(apiProvider);
    return Scaffold(


      body: state.when(
          data: (data){
            print(data);
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    onFieldSubmitted: (val){
                      ref.read(apiProvider.notifier).getSearchNews(query: val.trim());
                    },
                  ),
                  if(data !=null) Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index){
                            return ListTile(
                              title: Text(data[index].title),
                            );
                          }
                      )
                  )
                ],
              ),
            );
          },
          error: (err, st) => Center(child: Text('$err')),
          loading: () => Center(child: CircularProgressIndicator())
      ),
    );
  }
}