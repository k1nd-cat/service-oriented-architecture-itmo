import 'package:json_annotation/json_annotation.dart';
import 'package:webapp/features/movies/data/models/coordinates_dto.dart';
import 'package:webapp/features/movies/domain/entities/movie_enums.dart';

import 'person_dto.dart';

part 'movie_dto.g.dart';

@JsonSerializable()
class MovieDto {
  @JsonKey(includeFromJson: true, includeToJson: false)
  final int? id;
  final String name;
  final CoordinatesDto coordinates;
  final DateTime? creationDate;
  final int? oscarsCount;
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
    required this.oscarsCount,
    required this.totalBoxOffice,
    required this.length,
    required this.director,
    required this.genre,
    required this.operator,
  });

  factory MovieDto.fromJson(Map<String, dynamic> json) => _$MovieDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDtoToJson(this);

  MovieDto copyWith({
    int? id,
    String? name,
    CoordinatesDto? coordinates,
    DateTime? creationDate,
    int? oscarsCount,
    double? totalBoxOffice,
    int? length,
    PersonDto? director,
    MovieGenre? genre,
    PersonDto? operator,
  }) {
    return MovieDto(
      id: id ?? this.id,
      name: name ?? this.name,
      coordinates: coordinates ?? this.coordinates,
      creationDate: creationDate ?? this.creationDate,
      oscarsCount: oscarsCount ?? this.oscarsCount,
      totalBoxOffice: totalBoxOffice ?? this.totalBoxOffice,
      length: length ?? this.length,
      director: director ?? this.director,
      genre: genre ?? this.genre,
      operator: operator ?? this.operator,
    );
  }
}