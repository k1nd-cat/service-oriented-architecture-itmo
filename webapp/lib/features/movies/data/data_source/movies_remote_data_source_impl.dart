import 'package:dio/dio.dart';
import 'package:webapp/core/network/api_endpoints.dart';
import 'package:webapp/core/network/api_response.dart';
import 'package:webapp/core/network/base_error_data_source.dart';
import 'package:webapp/features/movies/data/data_source/movies_remote_data_source.dart';
import 'package:webapp/features/movies/data/models/enums_json_extensions.dart';

import '../../domain/entities/movie_enums.dart';
import '../models/filters_request.dart';
import '../models/movie_dto.dart';

class MoviesRemoteDataSourceImpl extends BaseRemoteDataSource
    implements MovieRemoteDataSource {

  MoviesRemoteDataSourceImpl(super.dio);

  @override
  Future<int> calculateMoviesCountByGenre(MovieGenre genre) async {
    return safeApiCall(() async {
      final response = await dio.post(
        ApiEndpoints.calculateMoviesCountByGenre,
        data: {'genre': genre.toJson},
      );

      return handleResponse<Map<String, dynamic>>(
            response,
            (data) => data,
          )['count']
          as int;
    });
  }

  @override
  Future<int> calculateTotalLength() async {
    return safeApiCall(() async {
      final response = await dio.post(ApiEndpoints.calculateTotalMoviesLength);

      return handleResponse<Map<String, dynamic>>(
            response,
            (data) => data,
          )['totalLength']
          as int;
    });
  }

  @override
  Future<MovieDto> createMovie(MovieDto movieDto) async {
    try {
      final response = await dio.post(
        ApiEndpoints.createMovie,
        data: movieDto.toJson(),
      );

      return handleResponse<MovieDto>(
        response,
        (json) => MovieDto.fromJson(json),
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  @override
  Future<void> deleteMovieById(int id) async {
    return safeApiCall(() async {
      final response = await dio.delete(ApiEndpoints.deleteMovieById('$id'));
    });
  }

  @override
  Future<MovieDto> getMovieById(int id) async {
    return safeApiCall(() async {
      final response = await dio.get(ApiEndpoints.getMovieById('$id'));
      return handleResponse<MovieDto>(
        response,
        (json) => MovieDto.fromJson(json),
      );
    });
  }

  @override
  Future<List<MovieDto>> getMovieListByName(String name) async {
    return safeApiCall(() async {
      final response = await dio.post(
        ApiEndpoints.searchMovieByName,
        data: {'namePrefix': name},
      );
      return handleListResponse<MovieDto>(
        response,
        (json) => MovieDto.fromJson(json),
      );
    });
  }

  @override
  Future<PaginatedResponse<MovieDto>> getMoviesByFilters(
    MoviesFilter filters, {
    int page = 1,
    int size = 10,
  }) async {
    return safeApiCall(() async {
      final response = await dio.post(
        ApiEndpoints.moviesFilters,
        queryParameters: {'page': page, 'size': size},
        data: filters.toJson(),
      );
      return handlePaginatedResponse<MovieDto>(
        response,
        (json) => MovieDto.fromJson(json),
      );
    });
  }

  @override
  Future<MovieDto> updateMovie(int id, MovieDto movieDto) async {
    return safeApiCall(() async {
      final response = await dio.put(
        ApiEndpoints.updateMovieById('$id'),
        data: movieDto.toJson(),
      );

      return handleResponse<MovieDto>(
        response,
        (json) => MovieDto.fromJson(json),
      );
    });
  }
}
