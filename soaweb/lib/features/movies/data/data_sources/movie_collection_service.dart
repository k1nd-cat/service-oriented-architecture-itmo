import 'package:dio/dio.dart';
import 'package:soaweb/core/network/api_client.dart';
import 'package:soaweb/features/movies/data/models/movie_dto.dart';
import 'package:soaweb/features/movies/data/models/movie_enums.dart';
import 'package:soaweb/features/movies/data/models/search_models.dart';

class MovieCollectionService {
  final Dio _dio;

  MovieCollectionService(ApiClient apiClient) : _dio = apiClient.dio;

  dynamic _handleResponse(Response response) {
    if (response.statusCode == 204) {
      return null;
    }
    return response.data;
  }

  /// POST /movies - Создать новый фильм
  Future<Movie> createMovie(MovieRequest movieRequest) async {
    final response = await _dio.post(
      '/movies',
      data: movieRequest.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = _handleResponse(response);
    return Movie.fromJson(data as Map<String, dynamic>);
  }

  /// GET /movies/{id} - Получить фильм по ID
  Future<Movie> getMovieById(int id) async {
    final response = await _dio.get('/movies/$id');
    final data = _handleResponse(response);
    return Movie.fromJson(data as Map<String, dynamic>);
  }

  /// PUT /movies/{id} - Обновить фильм
  Future<Movie> updateMovie(int id, MovieRequest movieRequest) async {
    final response = await _dio.put(
      '/movies/$id',
      data: movieRequest.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = _handleResponse(response);
    return Movie.fromJson(data as Map<String, dynamic>);
  }

  /// DELETE /movies/{id} - Удалить фильм (Ожидается 204 No Content)
  Future<void> deleteMovie(int id) async {
    final response = await _dio.delete('/movies/$id');
    _handleResponse(response);
  }

  /// POST /movies/filters - Получить список фильмов (с фильтрацией и пагинацией)
  Future<MoviePaginationResponse> getMoviesWithFilters({
    MovieSearchRequest? searchRequest,
    int page = 1,
    int size = 20,
  }) async {
    final response = await _dio.post(
      '/movies/filters',
      queryParameters: {
        'page': page,
        'size': size,
      },
      data: searchRequest?.toJson() ?? {},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = _handleResponse(response);
    return MoviePaginationResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /movies/search-by-name - Найти фильмы по началу названия
  Future<List<Movie>> searchMoviesByName(MovieSearchByNameRequest searchRequest) async {
    final response = await _dio.post(
      '/movies/search-by-name',
      data: searchRequest.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = _handleResponse(response) as List<dynamic>;
    return data.map((json) => Movie.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// POST /movies/count-by-genre - Подсчитать количество фильмов по жанру
  Future<MovieCountByGenreResponse> countMoviesByGenre(MovieCountByGenreRequest countRequest) async {
    final response = await _dio.post(
      '/movies/count-by-genre',
      data: countRequest.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = _handleResponse(response);
    return MovieCountByGenreResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /movies/calculate-total-length - Рассчитать сумму длительности всех фильмов
  Future<TotalLengthResponse> calculateTotalLength() async {
    final response = await _dio.post(
      '/movies/calculate-total-length',
      data: {},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = _handleResponse(response);
    return TotalLengthResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /oscar/directors/humiliate-by-genre/{genre} - Отобрать Оскары у режиссеров по жанру
  Future<OscarHumiliationResponse> humiliateDirectorsByGenre(MovieGenre genre) async {
    final genreValue = genre.value;
    final response = await _dio.post(
      '/oscar/directors/humiliate-by-genre/$genreValue',
      data: {},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = _handleResponse(response);
    return OscarHumiliationResponse.fromJson(data as Map<String, dynamic>);
  }

  /// POST /oscar/directors/get-loosers - Получить список режиссеров-неудачников
  Future<List<LooserDirector>> getLooserDirectors() async {
    final response = await _dio.post(
      '/oscar/directors/get-loosers',
      data: {},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    final data = _handleResponse(response) as List<dynamic>;
    return data.map((json) => LooserDirector.fromJson(json as Map<String, dynamic>)).toList();
  }
}
