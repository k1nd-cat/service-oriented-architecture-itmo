// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(moviesDataSource)
const moviesDataSourceProvider = MoviesDataSourceProvider._();

final class MoviesDataSourceProvider
    extends
        $FunctionalProvider<
          MoviesDataSource,
          MoviesDataSource,
          MoviesDataSource
        >
    with $Provider<MoviesDataSource> {
  const MoviesDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moviesDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moviesDataSourceHash();

  @$internal
  @override
  $ProviderElement<MoviesDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MoviesDataSource create(Ref ref) {
    return moviesDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MoviesDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MoviesDataSource>(value),
    );
  }
}

String _$moviesDataSourceHash() => r'625092a69d69a97610355948f803852a89bc4a90';
