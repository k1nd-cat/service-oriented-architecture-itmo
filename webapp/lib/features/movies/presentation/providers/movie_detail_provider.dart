import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/providers.dart';
import '../../domain/entities/movie.dart';

part 'movie_detail_provider.g.dart';

@riverpod
Future<Movie> movieDetail(Ref ref, int id) {
  final moviesRepo = ref.watch(moviesRepositoryProvider);
  return moviesRepo.getMovieById(id).then((either) => either.fold(
        (failure) => throw failure,
        (movie) => movie,
  ));
}