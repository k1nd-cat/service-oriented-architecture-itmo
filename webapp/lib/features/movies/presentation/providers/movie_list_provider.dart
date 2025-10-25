import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webapp/core/network/api_response.dart';

import '../../data/models/filters_request.dart';
import '../../data/repositories/providers.dart';
import '../../domain/entities/movie.dart';

part 'movie_list_provider.g.dart';

@riverpod
class MoviesFilterState extends _$MoviesFilterState {
  @override
  MoviesFilter build() {
    return const MoviesFilter(
      sort: null,
      name: null,
      genre: null,
      totalBoxOffice: IntFilter(min: null, max: null),
      length: IntFilter(min: null, max: null),
      coordinates: CoordinatesFilter(
        x: IntFilter(min: null, max: null),
        y: DoubleFilter(min: null, max: null),
      ),
      operator: PersonFilter(name: null, nationality: null),
    );
  }

  void updateFilter(MoviesFilter newFilter) {
    state = newFilter;
  }
}

@riverpod
Future<PaginatedResponse<Movie>> moviesList(
    Ref ref, {
      int size = 10,
    }) {
  final filter = ref.watch(moviesFilterStateProvider);
  final page = ref.watch(currentPageProvider);
  final moviesRepo = ref.watch(moviesRepositoryProvider);

  return moviesRepo
      .getMoviesByFilters(filter, page: page, size: size)
      .then((either) => either.fold(
        (failure) => throw failure,
        (response) => response,
  ));
}

@riverpod
class CurrentPage extends _$CurrentPage {
  static const int pageSize = 10;

  int _totalPages = 1;

  @override
  int build() {
    ref.listen(moviesListProvider(size: pageSize), (prev, next) {
      next.whenData((response) {
        final totalItems = response.totalElements;
        _totalPages = (totalItems / pageSize).ceil();

        if (state > _totalPages) {
          state = _totalPages;
        }
      });
    });

    return 1;
  }

  void _reloadMoviesList() {
    ref.invalidate(moviesListProvider(size: pageSize));
  }

  void goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      state = page;
      _reloadMoviesList();
    }
  }

  void nextPage() {
    if (state < _totalPages) {
      state = state + 1;
      _reloadMoviesList();
    }
  }

  void previousPage() {
    if (state > 1) {
      state = state - 1;
      _reloadMoviesList();
    }
  }

  int get totalPages => _totalPages;
}