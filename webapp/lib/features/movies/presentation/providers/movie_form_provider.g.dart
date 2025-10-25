// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MovieForm)
const movieFormProvider = MovieFormProvider._();

final class MovieFormProvider extends $AsyncNotifierProvider<MovieForm, void> {
  const MovieFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'movieFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$movieFormHash();

  @$internal
  @override
  MovieForm create() => MovieForm();
}

String _$movieFormHash() => r'70a059473604085e023b8cceacdf4f2aa84417f6';

abstract class _$MovieForm extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
