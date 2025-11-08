// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oscar_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(oscarDataSource)
const oscarDataSourceProvider = OscarDataSourceProvider._();

final class OscarDataSourceProvider
    extends
        $FunctionalProvider<OscarDataSource, OscarDataSource, OscarDataSource>
    with $Provider<OscarDataSource> {
  const OscarDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'oscarDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$oscarDataSourceHash();

  @$internal
  @override
  $ProviderElement<OscarDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OscarDataSource create(Ref ref) {
    return oscarDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OscarDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OscarDataSource>(value),
    );
  }
}

String _$oscarDataSourceHash() => r'ae0f3c7daa546b2728dde758e866374b5d1245aa';
