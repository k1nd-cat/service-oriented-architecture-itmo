import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webapp/core/network/network_providers.dart';
import 'package:webapp/features/movies/data/data_source/movies_remote_data_source.dart';
import 'package:webapp/features/movies/data/data_source/oscar_remote_data_source.dart';
import 'package:webapp/features/movies/data/data_source/oscar_remote_data_source_impl.dart';

import 'movies_remote_data_source_impl.dart';

part 'providers.g.dart';

@riverpod
MovieRemoteDataSource moviesRemoteDataSource(Ref ref) {
  return MoviesRemoteDataSourceImpl(ref.watch(dioProvider));
}

@riverpod
OscarRemoteDataSource oscarRemoteDataSource(Ref ref) {
  return OscarRemoteDataSourceImpl(ref.watch(dioProvider));
}
