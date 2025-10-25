import 'package:webapp/core/network/api_response.dart';
import 'package:webapp/features/movies/data/models/filters_request.dart';
import 'package:webapp/features/movies/data/models/movie_dto.dart';
import 'package:webapp/features/movies/domain/entities/movie_enums.dart';

abstract class MovieRemoteDataSource {

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