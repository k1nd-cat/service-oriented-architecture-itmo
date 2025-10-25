import '../../domain/entities/movie_enums.dart';
import '../models/humiliate_by_genre_response.dart';
import '../models/looser_dto.dart';

abstract class OscarRemoteDataSource {
  Future<List<LooserDto>> getLoosers();

  Future<HumiliateByGenreResponse> humiliateByGenre(MovieGenre genre);
}