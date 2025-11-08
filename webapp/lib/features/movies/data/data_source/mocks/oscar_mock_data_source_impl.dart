import 'package:fpdart/fpdart.dart';
import 'package:webapp/features/movies/data/data_source/oscar_data_source.dart';
import 'package:webapp/features/movies/data/mocks/mock_data.dart';
import 'package:webapp/features/movies/data/models/humiliate_by_genre_response.dart';
import 'package:webapp/features/movies/data/models/looser_dto.dart';
import 'package:webapp/features/movies/domain/entities/movie_enums.dart';

import '../../models/movie_dto.dart';

class OscarMockDataSourceImpl implements OscarDataSource {
  @override
  Future<List<LooserDto>> getLoosers() async {
    final movies = MockData().movies;

    final loserMovies = movies
        .where((movie) => movie.oscarsCount == 0)
        .toList();
    final Map<String, List<MovieDto>> moviesByDirector = {};
    for (var movie in loserMovies) {
      final id = movie.director.passportID;
      moviesByDirector.putIfAbsent(id, () => []).add(movie);
    }

    return moviesByDirector.entries.map((entry) {
      final movie = entry.value.first;
      return LooserDto(
        name: movie.director.name,
        passportID: movie.director.passportID,
        filmsCount: entry.value.length,
      );
    }).toList();
  }

  @override
  Future<HumiliateByGenreResponse> humiliateByGenre(MovieGenre genre) async {
    final directorsIds = MockData().movies
        .filter((movie) => movie.genre == genre)
        .map((movie) => movie.director.passportID)
        .toSet();

    var removedOscars = 0, affectedMovies = 0;
    for (var movie in MockData().movies) {
      if (!directorsIds.contains(movie.director.passportID)) continue;
      affectedMovies++;
      removedOscars += movie.oscarsCount ?? 0;
      MockData().movies.add(movie.copyWith(oscarsCount: 0));
      MockData().movies.removeWhere((m) => m.id == movie.id);
    }

    return HumiliateByGenreResponse(
      affectedDirectors: directorsIds.length,
      affectedMovies: affectedMovies,
      removedOscars: removedOscars,
    );
  }
}
