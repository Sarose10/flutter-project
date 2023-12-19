import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sk/api_service/movie_service.dart';
import 'package:sk/models/movie.dart';


final searchProvider = AsyncNotifierProvider(() => SearchProvider());


class SearchProvider extends AsyncNotifier{

@override
Future<List<Movie>> build() async{
return [];
}


Future<void> getSearchData(String searchText) async{
state = const AsyncLoading();
state  = await AsyncValue.guard(() => MovieService.getSearch(searchText: searchText));
}


}