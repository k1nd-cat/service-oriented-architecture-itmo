import 'package:json_annotation/json_annotation.dart';
import 'package:webapp/features/movies/data/models/location_dto.dart';
import 'package:webapp/features/movies/domain/entities/movie_enums.dart';

part 'person_dto.g.dart';

@JsonSerializable()
class PersonDto {
  final String name;
  final String passportID;
  final EyeColor? eyeColor;
  final HairColor hairColor;
  final Country? nationality;
  final LocationDto location;

  const PersonDto({
    required this.name,
    required this.passportID,
    required this.eyeColor,
    required this.hairColor,
    required this.nationality,
    required this.location,
  });

  factory PersonDto.fromJson(Map<String, dynamic> json) => _$PersonDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PersonDtoToJson(this);
}