import 'package:dio/dio.dart';

import '../models/news.dart';




class ApiService{

  static final _dio = Dio();
  static Future<List<News>> getSearchNews({required String query}) async{
    try{
      final response = await _dio.get('https://newsapi.org/v2/everything',
          queryParameters: {
            'apiKey': '6755b948d1064281a661e72a262ccc2d',
            'q': query
          });
      return (response.data['articles'] as List).map((e) => News.fromJson(e)).toList();
    }on DioException catch (err){
      throw '${err.message}';
    }
  }

}