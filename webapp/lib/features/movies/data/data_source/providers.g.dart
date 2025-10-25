// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(moviesRemoteDataSource)
const moviesRemoteDataSourceProvider = MoviesRemoteDataSourceProvider._();

final class MoviesRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          MovieRemoteDataSource,
          MovieRemoteDataSource,
          MovieRemoteDataSource
        >
    with $Provider<MovieRemoteDataSource> {
  const MoviesRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moviesRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moviesRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<MovieRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MovieRemoteDataSource create(Ref ref) {
    return moviesRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MovieRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MovieRemoteDataSource>(value),
    );
  }
}

String _$moviesRemoteDataSourceHash() =>
    r'3268cff1379e8a559f96ca5cb8490eb1fdd1e390';

@ProviderFor(oscarRemoteDataSource)
const oscarRemoteDataSourceProvider = OscarRemoteDataSourceProvider._();

final class OscarRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          OscarRemoteDataSource,
          OscarRemoteDataSource,
          OscarRemoteDataSource
        >
    with $Provider<OscarRemoteDataSource> {
  const OscarRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'oscarRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$oscarRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<OscarRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OscarRemoteDataSource create(Ref ref) {
    return oscarRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OscarRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OscarRemoteDataSource>(value),
    );
  }
}

String _$oscarRemoteDataSourceHash() =>
    r'236f1bcec1688dab837a427d039fd6289d4b29e0';
