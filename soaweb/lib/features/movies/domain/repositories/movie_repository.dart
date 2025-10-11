import 'package:soaweb/features/movies/data/models/movie_dto.dart';
import 'package:soaweb/features/movies/data/models/search_models.dart';

abstract class MovieRepository {
  Future<Movie> createMovie(MovieRequest movieRequest);

  Future<Movie> getMovieById(int id);

  Future<Movie> updateMovie(int id, MovieRequest movieRequest);

  Future<void> deleteMovie(int id);

  Future<MoviePaginationResponse> getMoviesWithFilters({
    MovieSearchRequest? searchRequest,
    int page = 1,
    int size = 10,
  });
}