import 'package:soaweb/features/movies/data/data_sources/movie_collection_service.dart';
import 'package:soaweb/features/movies/data/models/movie_dto.dart';
import 'package:soaweb/features/movies/data/models/search_models.dart';
import 'package:soaweb/features/movies/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieCollectionService _movieCollectionService;

  MovieRepositoryImpl(this._movieCollectionService);

  @override
  Future<Movie> createMovie(MovieRequest movieRequest) {
    return _movieCollectionService.createMovie(movieRequest);
  }

  @override
  Future<void> deleteMovie(int id) {
    return _movieCollectionService.deleteMovie(id);
  }

  @override
  Future<Movie> getMovieById(int id) {
    return _movieCollectionService.getMovieById(id);
  }

  @override
  Future<MoviePaginationResponse> getMoviesWithFilters({MovieSearchRequest? searchRequest, int page = 1, int size = 10}) {
    return _movieCollectionService.getMoviesWithFilters(searchRequest: searchRequest, page: page, size: size);
  }

  @override
  Future<Movie> updateMovie(int id, MovieRequest movieRequest) {
    return _movieCollectionService.updateMovie(id, movieRequest);
  }
}