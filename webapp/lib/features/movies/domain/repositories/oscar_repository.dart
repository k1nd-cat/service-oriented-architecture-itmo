import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webapp/core/error/failures/failure.dart';
import 'package:webapp/features/movies/domain/entities/looser.dart';

import '../../data/data_source/oscar_data_source.dart';
import '../../data/repositories/oscar_repository_impl.dart';
import '../entities/humiliate_by_genre.dart';
import '../entities/movie_enums.dart';

part 'oscar_repository.g.dart';

abstract class OscarRepository {
  Future<Either<Failure, List<Looser>>> getLoosers();

  Future<Either<Failure, HumiliateByGenre>> humiliateByGenre(MovieGenre genre);
}

@riverpod
OscarRepository oscarRepository(Ref ref) {
  return OscarRepositoryImpl(ref.watch(oscarDataSourceProvider));
}
