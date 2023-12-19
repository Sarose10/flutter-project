import 'package:dio/dio.dart';
import 'package:sk/constants/api.dart';
import 'package:sk/models/movie.dart';
import 'package:sk/models/video.dart';



class MovieService {

  static final dio = Dio(BaseOptions(
      headers: {
        'Authorization': Api.apiKey
      }
  ));

  static Future<List<Movie>> getMovie({required String apiPath}) async {
    try {
      final response = await dio.get(apiPath);
      return (response.data['results'] as List).map((e) => Movie.formJson(e) ).toList();
    } on DioException catch (err) {
      throw '${err.message}';
    }
  }


  static Future<List<Video>> getVideo({required int id}) async {
    try {
      final response = await dio.get('${Api.baseUrl}/movie/$id/videos');
      print(response.data);
      return (response.data['results'] as List).map((e) => Video.fromJson(e) ).toList();
    } on DioException catch (err) {
      throw '${err.message}';
    }
  }

  static Future<List<Movie>> getSearch({required String searchText}) async {
    try {
      final response = await dio.get('${Api.getSearchMovie}', queryParameters: {
        'query': searchText
      });
      print(response.data['results']);
      if((response.data['results'] as List).isEmpty){
        throw 'please provide another search keyword';
      }else{
        return (response.data['results'] as List).map((e) => Movie.formJson(e) ).toList();
      }

    } on DioException catch (err) {
      throw '${err.message}';
    }
  }



}