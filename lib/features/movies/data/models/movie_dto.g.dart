// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  coordinates: Coordinates.fromJson(
    json['coordinates'] as Map<String, dynamic>,
  ),
  creationDate: DateTime.parse(json['creationDate'] as String),
  oscarsCount: (json['oscarsCount'] as num?)?.toInt(),
  totalBoxOffice: (json['totalBoxOffice'] as num?)?.toDouble(),
  length: (json['length'] as num).toInt(),
  director: Person.fromJson(json['director'] as Map<String, dynamic>),
  genre: $enumDecodeNullable(_$MovieGenreEnumMap, json['genre']),
  operator: json['operator'] == null
      ? null
      : Person.fromJson(json['operator'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'coordinates': instance.coordinates,
  'creationDate': instance.creationDate.toIso8601String(),
  'oscarsCount': instance.oscarsCount,
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

MovieRequest _$MovieRequestFromJson(Map<String, dynamic> json) => MovieRequest(
  name: json['name'] as String,
  coordinates: Coordinates.fromJson(
    json['coordinates'] as Map<String, dynamic>,
  ),
  oscarsCount: (json['oscarsCount'] as num?)?.toInt(),
  totalBoxOffice: (json['totalBoxOffice'] as num?)?.toDouble(),
  length: (json['length'] as num).toInt(),
  director: Person.fromJson(json['director'] as Map<String, dynamic>),
  genre: $enumDecodeNullable(_$MovieGenreEnumMap, json['genre']),
  operator: json['operator'] == null
      ? null
      : Person.fromJson(json['operator'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MovieRequestToJson(MovieRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'coordinates': instance.coordinates,
      'oscarsCount': instance.oscarsCount,
      'totalBoxOffice': instance.totalBoxOffice,
      'length': instance.length,
      'director': instance.director,
      'genre': _$MovieGenreEnumMap[instance.genre],
      'operator': instance.operator,
    };
