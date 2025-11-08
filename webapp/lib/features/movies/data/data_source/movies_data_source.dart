import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webapp/core/network/api_response.dart';
import 'package:webapp/features/movies/data/data_source/remote/movies_remote_data_source_impl.dart';
import 'package:webapp/features/movies/data/models/filters_request.dart';
import 'package:webapp/features/movies/data/models/movie_dto.dart';
import 'package:webapp/features/movies/domain/entities/movie_enums.dart';

import '../../../../core/network/network_providers.dart';
import 'mocks/movies_mock_data_source_impl.dart';

part 'movies_data_source.g.dart';

abstract class MoviesDataSource {

  Future<PaginatedResponse<MovieDto>> getMoviesByFilters(
      MoviesFilter filters, {
        int page = 1,
        int size = 10,
      });

  Future<MovieDto> createMovie(MovieDto movieDto);

  Future<MovieDto> getMovieById(int id);

  Future<MovieDto> updateMovie(int id, MovieDto movieDto);

  Future<void> deleteMovieById(int id);

  Future<int> calculateTotalLength();

  Future<int> calculateMoviesCountByGenre(MovieGenre genre);

  Future<List<MovieDto>> getMovieListByName(String name);
}

@riverpod
MoviesDataSource moviesDataSource(Ref ref) {
  return MoviesMockDataSourceImpl();
  // return MoviesRemoteDataSourceImpl(ref.watch(dioProvider));
}