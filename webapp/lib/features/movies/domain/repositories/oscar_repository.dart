import 'package:fpdart/fpdart.dart';
import 'package:webapp/core/error/failures/failure.dart';
import 'package:webapp/features/movies/domain/entities/looser.dart';

import '../entities/humiliate_by_genre.dart';
import '../entities/movie_enums.dart';

abstract class OscarRepository {
  Future<Either<Failure, List<Looser>>> getLoosers();

  Future<Either<Failure, HumiliateByGenre>> humiliateByGenre(MovieGenre genre);
}