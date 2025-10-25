import 'coordinates.dart';
import 'movie_enums.dart';
import 'person.dart';

class Movie {
  final int id;
  final String name;
  final Coordinates coordinates;
  final DateTime creationDate;
  final int? oscarCount;
  final double? totalBoxOffice;
  final int length;
  final Person director;
  final MovieGenre? genre;
  final Person? operator;

  const Movie({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.creationDate,
    required this.oscarCount,
    required this.totalBoxOffice,
    required this.length,
    required this.director,
    required this.genre,
    required this.operator,
  });
}