import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/widgets/one_action_dialog.dart';
import '../../data/models/filters_request.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movies_repository.dart';

class MoviesListState {
  final List<Movie> movies;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final int totalElements;
  final bool hasMore;

  MoviesListState({
    this.movies = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.currentPage = 1,
    this.totalPages = 0,
    this.totalElements = 0,
    this.hasMore = false,
  });

  MoviesListState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    int? totalElements,
    bool? hasMore,
  }) {
    return MoviesListState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalElements: totalElements ?? this.totalElements,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class MoviesListNotifier extends StateNotifier<MoviesListState> {
  final MoviesRepository repository;
  final Ref ref;

  MoviesListNotifier(this.repository, this.ref) : super(MoviesListState());

  Future<void> loadMovies({bool loadMore = false}) async {
    if (state.isLoading || state.isLoadingMore) return;

    final filters = ref.read(moviesFilterProvider);
    final nextPage = loadMore ? state.currentPage + 1 : 1;

    state = state.copyWith(
      isLoading: !loadMore,
      isLoadingMore: loadMore,
      errorMessage: null,
    );

    final result = await repository.getMoviesByFilters(
      filters,
      page: nextPage,
      size: 10,
    );

    state = result.fold(
          (failure) => state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: failure.message,
      ),
          (response) {
        final movies = loadMore
            ? [...state.movies, ...response.content]
            : response.content;

        return state.copyWith(
          movies: movies,
          isLoading: false,
          isLoadingMore: false,
          currentPage: nextPage,
          totalPages: response.totalPages,
          totalElements: response.totalElements,
          hasMore: nextPage < response.totalPages,
        );
      },
    );
  }

  Future<void> deleteMovie(int id, BuildContext context) async {
    final result = await repository.deleteMovieById(id);

    result.fold(
      (failure) {
        showOneActionDialog(
          context,
          message: 'Ошибка при удалении фильма: ${failure.message}',
          buttonText: 'OK',
          action: () {},
        );
      },
      (_) {
        state = state.copyWith(
          movies: state.movies.where((m) => m.id != id).toList(),
          totalElements: state.totalElements - 1,
        );

        showOneActionDialog(
          context,
          message: 'Фильм успешно удален',
          buttonText: 'OK',
          action: () {},
        );
      },
    );
  }

  void refresh() {
    state = MoviesListState();
    loadMovies();
  }
}

final moviesListProvider =
    StateNotifierProvider<MoviesListNotifier, MoviesListState>((ref) {
      final repository = ref.watch(moviesRepositoryProvider);
      return MoviesListNotifier(repository, ref);
    });

final moviesFilterProvider = StateProvider<MoviesFilter>((ref) {
  return const MoviesFilter(
    sort: null,
    name: null,
    genre: null,
    oscarsCount: IntFilter(min: null, max: null),
    totalBoxOffice: DoubleFilter(min: null, max: null),
    length: IntFilter(min: null, max: null),
    coordinates: CoordinatesFilter(
      x: IntFilter(min: null, max: null),
      y: DoubleFilter(min: null, max: null),
    ),
    operator: PersonFilter(name: null, nationality: null),
  );
});
