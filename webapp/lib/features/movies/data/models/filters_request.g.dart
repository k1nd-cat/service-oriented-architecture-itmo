// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filters_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$MoviesFilterToJson(MoviesFilter instance) =>
    <String, dynamic>{
      'sort': instance.sort,
      'name': instance.name,
      'genre': _$MovieGenreEnumMap[instance.genre],
      'oscarsCount': instance.oscarsCount,
      'totalBoxOffice': instance.totalBoxOffice,
      'length': instance.length,
      'coordinates': instance.coordinates,
      'operator': instance.operator,
    };

const _$MovieGenreEnumMap = {
  MovieGenre.comedy: 'COMEDY',
  MovieGenre.adventure: 'ADVENTURE',
  MovieGenre.tragedy: 'TRAGEDY',
  MovieGenre.scienceFiction: 'SCIENCE_FICTION',
};

Map<String, dynamic> _$PersonFilterToJson(PersonFilter instance) =>
    <String, dynamic>{
      'name': instance.name,
      'nationality': _$CountryEnumMap[instance.nationality],
    };

const _$CountryEnumMap = {
  Country.france: 'FRANCE',
  Country.vatican: 'VATICAN',
  Country.southKorea: 'SOUTH_KOREA',
};

Map<String, dynamic> _$CoordinatesFilterToJson(CoordinatesFilter instance) =>
    <String, dynamic>{'x': instance.x, 'y': instance.y};

Map<String, dynamic> _$DoubleFilterToJson(DoubleFilter instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};

Map<String, dynamic> _$IntFilterToJson(IntFilter instance) => <String, dynamic>{
  'min': instance.min,
  'max': instance.max,
};
