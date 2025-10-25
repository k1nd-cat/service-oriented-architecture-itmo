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
    r'00d1e0bb4e1a2ad99a84e5185953f717ad26dff0';

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
    r'e0326c9523dd730c8ad54260100dbec444a09922';
