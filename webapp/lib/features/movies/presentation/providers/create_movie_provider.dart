import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/movie_draft.dart';
import '../../domain/repositories/movies_repository.dart';

class CreateMovieState {
  final MovieDraft? draft;
  final bool isLoading;
  final String? errorMessage;

  CreateMovieState({this.draft, this.isLoading = false, this.errorMessage});

  CreateMovieState copyWith({
    MovieDraft? draft,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CreateMovieState(
      draft: draft ?? this.draft,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CreateMovieNotifier extends StateNotifier<CreateMovieState> {
  final MoviesRepository repository;

  CreateMovieNotifier(this.repository) : super(CreateMovieState());

  Future<void> createOrUpdate(MovieDraft draft, {int? movieId}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = movieId == null
        ? await repository.createMovie(draft)
        : await repository.updateMovie(movieId, draft);

    state = result.fold(
          (failure) => state.copyWith(isLoading: false, errorMessage: failure.message),
          (movie) => state.copyWith(isLoading: false, draft: draft, errorMessage: null),
    );
  }
}

final createMovieProvider =
StateNotifierProvider.autoDispose<CreateMovieNotifier, CreateMovieState>((ref) {
  final repo = ref.watch(moviesRepositoryProvider);
  return CreateMovieNotifier(repo);
});
