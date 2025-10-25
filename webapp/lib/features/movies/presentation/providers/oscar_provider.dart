import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/providers.dart';
import '../../domain/entities/humiliate_by_genre.dart';
import '../../domain/entities/looser.dart';
import '../../domain/entities/movie_enums.dart';

part 'oscar_provider.g.dart';

class OscarScreenState {
  final AsyncValue<List<Looser>> loosers;
  final AsyncValue<HumiliateByGenre?> humiliationResult;

  OscarScreenState({
    this.loosers = const AsyncValue.loading(),
    this.humiliationResult = const AsyncValue.data(null),
  });

  OscarScreenState copyWith({
    AsyncValue<List<Looser>>? loosers,
    AsyncValue<HumiliateByGenre?>? humiliationResult,
  }) {
    return OscarScreenState(
      loosers: loosers ?? this.loosers,
      humiliationResult: humiliationResult ?? this.humiliationResult,
    );
  }
}

@riverpod
class OscarScreenController extends _$OscarScreenController {
  @override
  OscarScreenState build() {
    _loadLoosers();
    return OscarScreenState();
  }

  Future<void> _loadLoosers() async {
    state = state.copyWith(loosers: const AsyncValue.loading());
    final repo = ref.read(oscarRepositoryProvider);
    final result = await repo.getLoosers();
    state = state.copyWith(
      loosers: result.fold(
            (f) => AsyncValue.error(f, StackTrace.current),
            (l) => AsyncValue.data(l),
      ),
    );
  }

  Future<void> humiliate(MovieGenre genre) async {
    state = state.copyWith(humiliationResult: const AsyncValue.loading());
    final repo = ref.read(oscarRepositoryProvider);
    final result = await repo.humiliateByGenre(genre);
    state = state.copyWith(
      humiliationResult: result.fold(
            (f) => AsyncValue.error(f, StackTrace.current),
            (h) => AsyncValue.data(h),
      ),
    );
  }
}