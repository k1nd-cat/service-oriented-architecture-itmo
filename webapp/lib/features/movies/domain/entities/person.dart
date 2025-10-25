import 'location.dart';
import 'movie_enums.dart';

class Person {
  final String name;
  final String passportID;
  final EyeColor? eyeColor;
  final HairColor hairColor;
  final Country? nationality;
  final Location location;

  const Person({
    required this.name,
    required this.passportID,
    required this.eyeColor,
    required this.hairColor,
    required this.nationality,
    required this.location,
  });
}