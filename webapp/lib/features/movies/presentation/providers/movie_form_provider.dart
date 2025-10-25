import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/movie_draft.dart';
import '../../data/repositories/providers.dart';

part 'movie_form_provider.g.dart';

@riverpod
class MovieForm extends _$MovieForm {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<bool> submitMovie({
    required MovieDraft draft,
    int? movieId,
  }) async {
    state = const AsyncValue.loading();

    final repo = ref.read(moviesRepositoryProvider);
    final resultEither = (movieId == null)
        ? await repo.createMovie(draft)
        : await repo.updateMovie(movieId, draft);

    state = resultEither.fold(
          (failure) => AsyncValue.error(failure, StackTrace.current),
          (_) => const AsyncValue.data(null),
    );

    return resultEither.isRight();
  }
}