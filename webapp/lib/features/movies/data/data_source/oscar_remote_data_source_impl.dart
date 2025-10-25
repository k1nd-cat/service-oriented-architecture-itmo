import 'package:webapp/core/network/api_endpoints.dart';
import 'package:webapp/core/network/base_error_data_source.dart';
import 'package:webapp/features/movies/data/data_source/oscar_remote_data_source.dart';
import 'package:webapp/features/movies/data/models/enums_json_extensions.dart';
import 'package:webapp/features/movies/data/models/humiliate_by_genre_response.dart';
import 'package:webapp/features/movies/data/models/looser_dto.dart';
import 'package:webapp/features/movies/domain/entities/movie_enums.dart';

class OscarRemoteDataSourceImpl extends BaseRemoteDataSource
    implements OscarRemoteDataSource {
  OscarRemoteDataSourceImpl(super.dio);

  @override
  Future<List<LooserDto>> getLoosers() async {
    return safeApiCall(() async {
      final response = await dio.post(ApiEndpoints.getLosersDirectorsList);
      return handleListResponse<LooserDto>(
        response,
        (json) => LooserDto.fromJson(json),
      );
    });
  }

  @override
  Future<HumiliateByGenreResponse> humiliateByGenre(MovieGenre genre) async {
    return safeApiCall(() async {
      final response = await dio.post(ApiEndpoints.humiliateOscarsByGenre(genre.toJson()));

      return handleResponse(response, (json) => HumiliateByGenreResponse.fromJson(json));
    });
  }
}
