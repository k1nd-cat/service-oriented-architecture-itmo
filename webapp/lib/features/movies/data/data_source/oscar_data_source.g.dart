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

String _$oscarDataSourceHash() => r'5f5a31e561f23cacbad92aec41d8460638f7dd6a';
