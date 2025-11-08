import 'package:fpdart/fpdart.dart';
import 'package:webapp/core/entity/info_message.dart';
import 'package:webapp/core/error/exceptions/app_exception.dart';
import 'package:webapp/core/error/exceptions/server_exception.dart';
import 'package:webapp/core/error/failures/failure.dart';
import 'package:webapp/core/network/api_response.dart';
import 'package:webapp/features/movies/data/data_source/movies_data_source.dart';
import 'package:webapp/features/movies/data/mappers/movie_mapper.dart';
import 'package:webapp/features/movies/data/models/filters_request.dart';
import 'package:webapp/features/movies/domain/repositories/movies_repository.dart';
import 'package:webapp/features/movies/domain/entities/movie.dart';
import 'package:webapp/features/movies/domain/entities/movie_draft.dart';
import 'package:webapp/features/movies/domain/entities/movie_enums.dart';

class MoviesRepositoryImpl extends MoviesRepository {
  final MoviesDataSource moviesRemoteDataSource;

  MoviesRepositoryImpl(this.moviesRemoteDataSource);

  @override
  Future<Either<Failure, int>> calculateMoviesCountByGenre(
    MovieGenre genre,
  ) async {
    try {
      final count = await moviesRemoteDataSource.calculateMoviesCountByGenre(
        genre,
      );
      return Right(count);
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
  Future<Either<Failure, int>> calculateTotalLength() async {
    try {
      final length = await moviesRemoteDataSource.calculateTotalLength();
      return Right(length);
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
  Future<Either<Failure, Movie>> createMovie(MovieDraft movie) async {
    try {
      final movieDto = await moviesRemoteDataSource.createMovie(
        MovieMapper.toDto(movie),
      );
      return Right(MovieMapper.toEntity(movieDto));
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
  Future<Either<Failure, InfoMessage>> deleteMovieById(int id) async {
    try {
      await moviesRemoteDataSource.deleteMovieById(id);
      return Right(InfoMessage('Фильм успешно удалён'));
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
  Future<Either<Failure, Movie>> getMovieById(int id) async {
    try {
      final movieDto = await moviesRemoteDataSource.getMovieById(id);
      return Right(MovieMapper.toEntity(movieDto));
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

  // @override
  // Future<Either<Failure, List<Movie>>> getMovieListByName(String name) async {
  //   try {
  //     final movieDtoList = await moviesRemoteDataSource.getMovieListByName(
  //       name,
  //     );
  //     return Right(MovieMapper.toEntityList(movieDtoList));
  //   } on ServerException catch (e) {
  //     return Left(Failure(code: e.code, message: e.message));
  //   } on AppException catch (e) {
  //     return Left(Failure(message: e.message));
  //   } catch (e) {
  //     return Left(
  //       Failure(message: 'Произошла странная ошибка. Повторите попытку позже'),
  //     );
  //   }
  // }

  @override
  Future<Either<Failure, PaginatedResponse<Movie>>> getMoviesByFilters(
    MoviesFilter filters, {
    int page = 1,
    int size = 10,
  }) async {
    try {
      final paginatedMoviesDto = await moviesRemoteDataSource
          .getMoviesByFilters(filters, size: size, page: page);
      final paginatedMovies = PaginatedResponse<Movie>(
        page: paginatedMoviesDto.page,
        size: paginatedMoviesDto.size,
        totalElements: paginatedMoviesDto.totalElements,
        totalPages: paginatedMoviesDto.totalPages,
        content: MovieMapper.toEntityList(paginatedMoviesDto.content),
      );
      return Right(paginatedMovies);
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
  Future<Either<Failure, Movie>> updateMovie(int id, MovieDraft movie) async {
    try {
      final movieDto = await moviesRemoteDataSource.updateMovie(
        id,
        MovieMapper.toDto(movie),
      );
      return Right(MovieMapper.toEntity(movieDto));
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
