import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soaweb/core/network/api_client.dart';
import 'package:soaweb/features/movies/data/data_sources/movie_collection_service.dart';
import 'package:soaweb/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:soaweb/features/movies/domain/repositories/movie_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final movieCollectionServiceProvider = Provider<MovieCollectionService>(
      (ref) => MovieCollectionService(ref.watch(apiClientProvider)),
);

final movieRepositoryProvider = Provider<MovieRepository>(
      (ref) => MovieRepositoryImpl(ref.watch(movieCollectionServiceProvider)),
);