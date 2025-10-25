import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soaweb/features/movies/data/models/movie_dto.dart';
import 'package:soaweb/features/movies/domain/repositories/movie_repository.dart';
import 'package:soaweb/features/movies/presentation/providers/movie_providers.dart';

final movieListNotifierProvider = StateNotifierProvider<MovieListNotifier, AsyncValue<List<Movie>>>((ref) {
  return MovieListNotifier(ref.watch(movieRepositoryProvider));
});

class MovieListNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  final MovieRepository _movieRepository;

  MovieListNotifier(this._movieRepository) : super(const AsyncValue.loading()) {
    _fetchMovies();
  }

  Future<void> refreshMovies() async {
    await _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    try {
      final response = await _movieRepository.getMoviesWithFilters();
      state = AsyncValue.data(response.content ?? []);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addMovie(MovieRequest movieRequest) async {
    try {
      await _movieRepository.createMovie(movieRequest);
      await _fetchMovies();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateMovie(int id, MovieRequest movieRequest) async {
    try {
      await _movieRepository.updateMovie(id, movieRequest);
      await _fetchMovies();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteMovie(int id) async {
    try {
      await _movieRepository.deleteMovie(id);
      await _fetchMovies();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
