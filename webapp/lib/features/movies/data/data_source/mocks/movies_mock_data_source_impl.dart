import 'package:fpdart/fpdart.dart';
import 'package:webapp/core/network/api_response.dart';
import 'package:webapp/features/movies/data/mocks/mock_data.dart';
import 'package:webapp/features/movies/data/models/filters_request.dart';
import 'package:webapp/features/movies/data/models/movie_dto.dart';
import 'package:webapp/features/movies/domain/entities/movie_enums.dart';

import '../movies_data_source.dart';

class MoviesMockDataSourceImpl implements MoviesDataSource {
  @override
  Future<int> calculateMoviesCountByGenre(MovieGenre genre) async {
    return MockData().movies.map((movie) => movie.genre == genre).length;
  }

  @override
  Future<int> calculateTotalLength() async {
    return MockData().movies.map((movie) => movie.length).reduce((a, b) => a + b);
  }

  @override
  Future<MovieDto> createMovie(MovieDto movieDto) async {
    final newMovie = movieDto.copyWith(
      id:
          MockData().movies
              .map((movie) => movie.id)
              .reduce((a, b) => a! > b! ? a : b) ??
          0 + 1,
      creationDate: DateTime.now(),
    );

    MockData().movies.add(newMovie);
    return newMovie;
  }

  @override
  Future<void> deleteMovieById(int id) async {
    MockData().movies.removeWhere((movie) => movie.id == id);
  }

  @override
  Future<MovieDto> getMovieById(int id) async {
    return MockData().movies.firstWhere((movie) => movie.id == id);
  }

  @override
  Future<List<MovieDto>> getMovieListByName(String name) async {
    return MockData().movies
        .filter(
          (movie) => movie.name.toLowerCase().startsWith(name.toLowerCase()),
        )
        .toList();
  }

  @override
  Future<PaginatedResponse<MovieDto>> getMoviesByFilters(
    MoviesFilter filters, {
    int page = 1,
    int size = 10,
  }) async {
    final startIndex = (page - 1) * size;
    final endIndex = startIndex + 10;
    return PaginatedResponse<MovieDto>(
      page: page,
      size: size,
      totalElements: MockData().movies.length,
      totalPages: MockData().movies.length ~/ page + 1,
      content: MockData().movies.sublist(startIndex, endIndex).toList(),
    );
  }

  @override
  Future<MovieDto> updateMovie(int id, MovieDto movieDto) async {
    final updatedMovie = MockData().movies
        .firstWhere((movie) => movie.id == id)
        .copyWith(
          name: movieDto.name,
          coordinates: movieDto.coordinates,
          oscarsCount: movieDto.oscarsCount,
          totalBoxOffice: movieDto.totalBoxOffice,
          length: movieDto.length,
          director: movieDto.director,
          genre: movieDto.genre,
          operator: movieDto.operator,
        );

    MockData().movies.removeWhere((movie) => movie.id == id);
    MockData().movies.add(updatedMovie);
    return updatedMovie;
  }
}
