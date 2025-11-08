import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/movie_enums.dart';
import '../../domain/entities/looser.dart';
import '../../domain/entities/humiliate_by_genre.dart';
import '../../domain/repositories/oscar_repository.dart';
import '../../domain/repositories/movies_repository.dart';

class AdditionalFeaturesState {
  final bool isLoading;
  final String? errorMessage;
  final List<Looser>? loosers;
  final HumiliateByGenre? humiliateResult;
  final int? totalLength;
  final Map<MovieGenre, int> genreCounts;

  AdditionalFeaturesState({
    this.isLoading = false,
    this.errorMessage,
    this.loosers,
    this.humiliateResult,
    this.totalLength,
    this.genreCounts = const {},
  });

  AdditionalFeaturesState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Looser>? loosers,
    HumiliateByGenre? humiliateResult,
    int? totalLength,
    Map<MovieGenre, int>? genreCounts,
  }) {
    return AdditionalFeaturesState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      loosers: loosers ?? this.loosers,
      humiliateResult: humiliateResult ?? this.humiliateResult,
      totalLength: totalLength ?? this.totalLength,
      genreCounts: genreCounts ?? this.genreCounts,
    );
  }
}

class AdditionalFeaturesNotifier
    extends StateNotifier<AdditionalFeaturesState> {
  final OscarRepository oscarRepository;
  final MoviesRepository moviesRepository;

  AdditionalFeaturesNotifier({
    required this.oscarRepository,
    required this.moviesRepository,
  }) : super(AdditionalFeaturesState());

  Future<void> getLoosers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await oscarRepository.getLoosers();

    state = result.fold(
      (failure) =>
          state.copyWith(isLoading: false, errorMessage: failure.message),
      (loosers) => state.copyWith(isLoading: false, loosers: loosers),
    );
  }

  Future<void> humiliateByGenre(MovieGenre genre) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await oscarRepository.humiliateByGenre(genre);

    state = result.fold(
      (failure) =>
          state.copyWith(isLoading: false, errorMessage: failure.message),
      (humiliateResult) =>
          state.copyWith(isLoading: false, humiliateResult: humiliateResult),
    );
  }

  Future<void> calculateTotalLength() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await moviesRepository.calculateTotalLength();

    state = result.fold(
      (failure) =>
          state.copyWith(isLoading: false, errorMessage: failure.message),
      (totalLength) =>
          state.copyWith(isLoading: false, totalLength: totalLength),
    );
  }

  Future<void> calculateMoviesCountByGenre(MovieGenre genre) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await moviesRepository.calculateMoviesCountByGenre(genre);

    state = result.fold(
      (failure) =>
          state.copyWith(isLoading: false, errorMessage: failure.message),
      (count) => state.copyWith(
        isLoading: false,
        genreCounts: {...state.genreCounts, genre: count},
      ),
    );
  }

  Future<void> calculateAllGenreCounts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final Map<MovieGenre, int> counts = {};

    for (final genre in MovieGenre.values) {
      final result = await moviesRepository.calculateMoviesCountByGenre(genre);
      result.fold((failure) => null, (count) => counts[genre] = count);
    }

    state = state.copyWith(isLoading: false, genreCounts: counts);
  }

  void clearResults() {
    state = AdditionalFeaturesState();
  }
}

final additionalFeaturesProvider =
    StateNotifierProvider<AdditionalFeaturesNotifier, AdditionalFeaturesState>((
      ref,
    ) {
      return AdditionalFeaturesNotifier(
        oscarRepository: ref.watch(oscarRepositoryProvider),
        moviesRepository: ref.watch(moviesRepositoryProvider),
      );
    });
