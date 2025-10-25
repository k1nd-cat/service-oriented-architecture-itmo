// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

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

String _$moviesRepositoryHash() => r'2c6fd2ed3d3cc6b5a82d095e2ee8e614e41bbf95';

@ProviderFor(oscarRepository)
const oscarRepositoryProvider = OscarRepositoryProvider._();

final class OscarRepositoryProvider
    extends
        $FunctionalProvider<OscarRepository, OscarRepository, OscarRepository>
    with $Provider<OscarRepository> {
  const OscarRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'oscarRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$oscarRepositoryHash();

  @$internal
  @override
  $ProviderElement<OscarRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OscarRepository create(Ref ref) {
    return oscarRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OscarRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OscarRepository>(value),
    );
  }
}

String _$oscarRepositoryHash() => r'c32aecaa45ec94c96520da918c0673b0c7cd142f';
