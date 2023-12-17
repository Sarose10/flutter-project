import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sk/api_service/movie_service.dart';






final movieProvider = FutureProvider.family(
        (ref, String apiPath) => MovieService.getMovie(apiPath: apiPath));

final videoProvider = FutureProvider.family(
        (ref, int id) => MovieService.getVideo(id: id));