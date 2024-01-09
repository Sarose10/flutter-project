import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sk/api_service/api_service.dart';


final apiProvider = AsyncNotifierProvider(() => ApiProvider());

class ApiProvider extends AsyncNotifier{

  @override
  FutureOr build() {

  }

  Future<void> getSearchNews({required String query}) async{
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ApiService.getSearchNews(query: query));
  }
}