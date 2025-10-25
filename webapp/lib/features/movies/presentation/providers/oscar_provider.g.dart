// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oscar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OscarScreenController)
const oscarScreenControllerProvider = OscarScreenControllerProvider._();

final class OscarScreenControllerProvider
    extends $NotifierProvider<OscarScreenController, OscarScreenState> {
  const OscarScreenControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'oscarScreenControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$oscarScreenControllerHash();

  @$internal
  @override
  OscarScreenController create() => OscarScreenController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OscarScreenState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OscarScreenState>(value),
    );
  }
}

String _$oscarScreenControllerHash() =>
    r'35a0315304df8b89406b62a94688811eaaa75eb5';

abstract class _$OscarScreenController extends $Notifier<OscarScreenState> {
  OscarScreenState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OscarScreenState, OscarScreenState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OscarScreenState, OscarScreenState>,
              OscarScreenState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
