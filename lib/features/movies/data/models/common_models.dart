import 'package:json_annotation/json_annotation.dart';
import 'package:soaweb/features/movies/data/models/movie_enums.dart';

part 'common_models.g.dart';

@JsonSerializable()
class Coordinates {
  final int x;

  final double y;

  Coordinates({
    required this.x,
    required this.y,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}

@JsonSerializable()
class Location {
  final double x;

  final int y;

  final int z;

  Location({
    required this.x,
    required this.y,
    required this.z,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable()
class Person {
  final String name;

  final String passportID;

  final EyeColor? eyeColor;

  final HairColor hairColor;

  final Country? nationality;

  final Location location;

  Person({
    required this.name,
    required this.passportID,
    this.eyeColor,
    required this.hairColor,
    this.nationality,
    required this.location,
  });

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

@JsonSerializable()
class Error {
  final String error;

  final String message;

  final DateTime? timestamp;

  final String? path;

  Error({
    required this.error,
    required this.message,
    this.timestamp,
    this.path,
  });

  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorToJson(this);
}
