import 'package:json_annotation/json_annotation.dart';
import 'package:webapp/features/movies/data/models/coordinates_dto.dart';
import 'package:webapp/features/movies/domain/entities/movie_enums.dart';

import 'person_dto.dart';

part 'movie_dto.g.dart';

@JsonSerializable()
class MovieDto {
  final int? id;
  final String name;
  final CoordinatesDto coordinates;
  final DateTime? creationDate;
  final int? oscarCount;
  final double? totalBoxOffice;
  final int length;
  final PersonDto director;
  final MovieGenre? genre;
  final PersonDto? operator;

  const MovieDto({
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

  factory MovieDto.fromJson(Map<String, dynamic> json) => _$MovieDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDtoToJson(this);
}