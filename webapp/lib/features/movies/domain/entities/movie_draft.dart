import 'package:webapp/features/movies/domain/entities/coordinates.dart';

import 'movie_enums.dart';
import 'person.dart';

class MovieDraft {
  final int? id;
  final String name;
  final Coordinates coordinates;
  final int? oscarsCount;
  final double? totalBoxOffice;
  final int length;
  final Person director;
  final MovieGenre? genre;
  final Person? operator;

  const MovieDraft({
    this.id,
    required this.name,
    required this.coordinates,
    required this.oscarsCount,
    required this.totalBoxOffice,
    required this.length,
    required this.director,
    required this.genre,
    required this.operator,
  });
}