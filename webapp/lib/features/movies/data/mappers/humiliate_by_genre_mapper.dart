import 'package:webapp/features/movies/data/models/humiliate_by_genre_response.dart';
import 'package:webapp/features/movies/domain/entities/humiliate_by_genre.dart';

class HumiliateByGenreMapper {
  static HumiliateByGenre toEntity(HumiliateByGenreResponse dto) {
    return HumiliateByGenre(
      affectedDirectors: dto.affectedDirectors,
      affectedMovies: dto.affectedMovies,
      removedOscars: dto.removedOscars,
    );
  }
}
