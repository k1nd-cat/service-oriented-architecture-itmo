import 'package:fpdart/fpdart.dart';
import 'package:webapp/core/error/exceptions/app_exception.dart';
import 'package:webapp/core/error/exceptions/server_exception.dart';
import 'package:webapp/core/error/failures/failure.dart';
import 'package:webapp/features/movies/data/data_source/oscar_data_source.dart';
import 'package:webapp/features/movies/data/mappers/humiliate_by_genre_mapper.dart';
import 'package:webapp/features/movies/data/mappers/looser_mapper.dart';
import 'package:webapp/features/movies/domain/repositories/oscar_repository.dart';
import 'package:webapp/features/movies/domain/entities/looser.dart';
import 'package:webapp/features/movies/domain/entities/movie_enums.dart';

import '../../domain/entities/humiliate_by_genre.dart';

class OscarRepositoryImpl implements OscarRepository {
  final OscarDataSource oscarRemoteDataSource;

  const OscarRepositoryImpl(this.oscarRemoteDataSource);

  @override
  Future<Either<Failure, List<Looser>>> getLoosers() async {
    try {
      final looserDtoList = await oscarRemoteDataSource.getLoosers();
      return Right(LooserMapper.toEntityList(looserDtoList));
    } on ServerException catch (e) {
      return Left(Failure(code: e.code, message: e.message));
    } on AppException catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(
        Failure(message: 'Произошла странная ошибка. Повторите попытку позже'),
      );
    }
  }

  @override
  Future<Either<Failure, HumiliateByGenre>> humiliateByGenre(MovieGenre genre) async {
    try {
      final result = await oscarRemoteDataSource.humiliateByGenre(genre);
      return Right(HumiliateByGenreMapper.toEntity(result));
    } on ServerException catch (e) {
      return Left(Failure(code: e.code, message: e.message));
    } on AppException catch (e) {
      return Left(Failure(message: e.message));
    } catch (e) {
      return Left(
        Failure(message: 'Произошла странная ошибка. Повторите попытку позже'),
      );
    }
  }
}
