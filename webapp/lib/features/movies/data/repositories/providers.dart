import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webapp/features/movies/data/data_source/providers.dart';
import 'package:webapp/features/movies/domain/repositories/movies_repository.dart';

import 'movies_repository_impl.dart';
import '../../domain/repositories/oscar_repository.dart';
import 'oscar_repository_impl.dart';

part 'providers.g.dart';

@riverpod
MoviesRepository moviesRepository(Ref ref) {
  return MoviesRepositoryImpl(ref.watch(moviesRemoteDataSourceProvider));
}

@riverpod
OscarRepository oscarRepository(Ref ref) {
  return OscarRepositoryImpl(ref.watch(oscarRemoteDataSourceProvider));
}
