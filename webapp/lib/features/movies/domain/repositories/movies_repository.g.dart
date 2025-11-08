// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(moviesRepository)
const moviesRepositoryProvider = MoviesRepositoryProvider._();

final class MoviesRepositoryProvider
    extends
        $FunctionalProvider<
          MoviesRepository,
          MoviesRepository,
          MoviesRepository
        >
    with $Provider<MoviesRepository> {
  const MoviesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moviesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moviesRepositoryHash();

  @$internal
  @override
  $ProviderElement<MoviesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MoviesRepository create(Ref ref) {
    return moviesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MoviesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MoviesRepository>(value),
    );
  }
}

String _$moviesRepositoryHash() => r'7c7aa7903eb4e046797da957dc1c10b5836383e0';
