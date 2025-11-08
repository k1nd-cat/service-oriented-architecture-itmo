import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webapp/core/error/failures/failure.dart';
import 'package:webapp/core/network/api_response.dart';
import 'package:webapp/features/movies/domain/entities/movie_draft.dart';

import '../../data/data_source/movies_data_source.dart';
import '../../data/repositories/movies_repository_impl.dart';
import '../entities/movie.dart';
import '../entities/movie_enums.dart';
import '../../data/models/filters_request.dart';

part 'movies_repository.g.dart';

abstract class MoviesRepository {
  Future<Either<Failure, PaginatedResponse<Movie>>> getMoviesByFilters(
    MoviesFilter filters, {
    int page = 1,
    int size = 10,
  });

  Future<Either<Failure, Movie>> createMovie(MovieDraft movie);

  Future<Either<Failure, Movie>> getMovieById(int id);

  Future<Either<Failure, Movie>> updateMovie(int id, MovieDraft movie);

  Future<Either<Failure, void>> deleteMovieById(int id);

  Future<Either<Failure, int>> calculateTotalLength();

  Future<Either<Failure, int>> calculateMoviesCountByGenre(MovieGenre genre);

  Future<Either<Failure, List<Movie>>> getMovieListByName(String name);
}

@riverpod
MoviesRepository moviesRepository(Ref ref) {
  return MoviesRepositoryImpl(ref.watch(moviesDataSourceProvider));
}
