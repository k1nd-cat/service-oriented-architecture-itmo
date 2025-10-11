import 'package:json_annotation/json_annotation.dart';
import 'package:soaweb/features/movies/data/models/common_models.dart';
import 'package:soaweb/features/movies/data/models/movie_enums.dart';

part 'movie_dto.g.dart';

@JsonSerializable()
class Movie {
  final int id;

  final String name;

  final Coordinates coordinates;

  final DateTime creationDate;

  final int? oscarsCount;

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
    this.oscarsCount,
    this.totalBoxOffice,
    required this.length,
    required this.director,
    this.genre,
    this.operator,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}

@JsonSerializable()
class MovieRequest {
  final String name;

  final Coordinates coordinates;

  final int? oscarsCount;

  final double? totalBoxOffice;

  final int length;

  final Person director;

  final MovieGenre? genre;

  final Person? operator;

  MovieRequest({
    required this.name,
    required this.coordinates,
    this.oscarsCount,
    this.totalBoxOffice,
    required this.length,
    required this.director,
    this.genre,
    this.operator,
  });

  factory MovieRequest.fromJson(Map<String, dynamic> json) => _$MovieRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MovieRequestToJson(this);
}