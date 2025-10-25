// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MoviesFilterState)
const moviesFilterStateProvider = MoviesFilterStateProvider._();

final class MoviesFilterStateProvider
    extends $NotifierProvider<MoviesFilterState, MoviesFilter> {
  const MoviesFilterStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moviesFilterStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moviesFilterStateHash();

  @$internal
  @override
  MoviesFilterState create() => MoviesFilterState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MoviesFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MoviesFilter>(value),
    );
  }
}

String _$moviesFilterStateHash() => r'ef225a4f8c0e0757ec09da084b3e5b341134c932';

abstract class _$MoviesFilterState extends $Notifier<MoviesFilter> {
  MoviesFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MoviesFilter, MoviesFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MoviesFilter, MoviesFilter>,
              MoviesFilter,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(moviesList)
const moviesListProvider = MoviesListFamily._();

final class MoviesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaginatedResponse<Movie>>,
          PaginatedResponse<Movie>,
          FutureOr<PaginatedResponse<Movie>>
        >
    with
        $FutureModifier<PaginatedResponse<Movie>>,
        $FutureProvider<PaginatedResponse<Movie>> {
  const MoviesListProvider._({
    required MoviesListFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'moviesListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$moviesListHash();

  @override
  String toString() {
    return r'moviesListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PaginatedResponse<Movie>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaginatedResponse<Movie>> create(Ref ref) {
    final argument = this.argument as int;
    return moviesList(ref, size: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MoviesListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$moviesListHash() => r'96d49fae57bc9a868b8c30b66f8c270604ce62e5';

final class MoviesListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PaginatedResponse<Movie>>, int> {
  const MoviesListFamily._()
    : super(
        retry: null,
        name: r'moviesListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MoviesListProvider call({int size = 10}) =>
      MoviesListProvider._(argument: size, from: this);

  @override
  String toString() => r'moviesListProvider';
}

@ProviderFor(CurrentPage)
const currentPageProvider = CurrentPageProvider._();

final class CurrentPageProvider extends $NotifierProvider<CurrentPage, int> {
  const CurrentPageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPageHash();

  @$internal
  @override
  CurrentPage create() => CurrentPage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$currentPageHash() => r'e6f85598898b275347c04a800baa60ab23afb991';

abstract class _$CurrentPage extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
