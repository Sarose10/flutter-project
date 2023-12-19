import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sk/constants/app_sizes.dart';
import 'package:sk/provider/search_provider.dart';
import 'package:sk/views/detail_page.dart';


class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final state= ref.watch(searchProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text('Search Movies'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                onFieldSubmitted: (val){
                  if(val.isEmpty){

                  }else{
                    ref.read(searchProvider.notifier).getSearchData(val.trim());
                  }
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    hintText: 'search',
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder()
                ),
              ),
              AppSizes.gapH16,
              Expanded(
                  child: state.when(
                      data: (data){
                        return GridView.builder(
                            itemCount: data.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 2/3
                            ),
                            itemBuilder: (context, index){
                              final movie = data[index];
                              return InkWell(
                                  onTap: (){
                                    Get.to(() => DetailPage(movie: movie));
                                  },
                                  child: Image.network(movie.poster_path));
                            }
                        );
                      },
                      error: (err, st) => Center(child: Text('$err')),
                      loading: () => Center(child: CircularProgressIndicator())
                  )
              ),
            ],
          ),
        )
    );
  }
}