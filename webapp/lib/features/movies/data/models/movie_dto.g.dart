// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDto _$MovieDtoFromJson(Map<String, dynamic> json) => MovieDto(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  coordinates: CoordinatesDto.fromJson(
    json['coordinates'] as Map<String, dynamic>,
  ),
  creationDate: json['creationDate'] == null
      ? null
      : DateTime.parse(json['creationDate'] as String),
  oscarCount: (json['oscarCount'] as num?)?.toInt(),
  totalBoxOffice: (json['totalBoxOffice'] as num?)?.toDouble(),
  length: (json['length'] as num).toInt(),
  director: PersonDto.fromJson(json['director'] as Map<String, dynamic>),
  genre: $enumDecodeNullable(_$MovieGenreEnumMap, json['genre']),
  operator: json['operator'] == null
      ? null
      : PersonDto.fromJson(json['operator'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MovieDtoToJson(MovieDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'coordinates': instance.coordinates,
  'creationDate': instance.creationDate?.toIso8601String(),
  'oscarCount': instance.oscarCount,
  'totalBoxOffice': instance.totalBoxOffice,
  'length': instance.length,
  'director': instance.director,
  'genre': _$MovieGenreEnumMap[instance.genre],
  'operator': instance.operator,
};

const _$MovieGenreEnumMap = {
  MovieGenre.comedy: 'COMEDY',
  MovieGenre.adventure: 'ADVENTURE',
  MovieGenre.tragedy: 'TRAGEDY',
  MovieGenre.scienceFiction: 'SCIENCE_FICTION',
};
