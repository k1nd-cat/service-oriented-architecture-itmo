// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oscar_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$oscarRepositoryHash() => r'ea5aa242a65dfc174b01d1f64c5af4ddb8cb3090';
