// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OscarHumiliationResponse _$OscarHumiliationResponseFromJson(
  Map<String, dynamic> json,
) => OscarHumiliationResponse(
  affectedDirectors: (json['affectedDirectors'] as num?)?.toInt(),
  affectedMovies: (json['affectedMovies'] as num?)?.toInt(),
  removedOscars: (json['removedOscars'] as num?)?.toInt(),
);

Map<String, dynamic> _$OscarHumiliationResponseToJson(
  OscarHumiliationResponse instance,
) => <String, dynamic>{
  'affectedDirectors': instance.affectedDirectors,
  'affectedMovies': instance.affectedMovies,
  'removedOscars': instance.removedOscars,
};

LooserDirector _$LooserDirectorFromJson(Map<String, dynamic> json) =>
    LooserDirector(
      name: json['name'] as String?,
      passportID: json['passportID'] as String?,
      filmsCount: (json['filmsCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LooserDirectorToJson(LooserDirector instance) =>
    <String, dynamic>{
      'name': instance.name,
      'passportID': instance.passportID,
      'filmsCount': instance.filmsCount,
    };

MoviePaginationResponse _$MoviePaginationResponseFromJson(
  Map<String, dynamic> json,
) => MoviePaginationResponse(
  content: (json['content'] as List<dynamic>?)
      ?.map((e) => Movie.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
  totalElements: (json['totalElements'] as num?)?.toInt(),
  totalPages: (json['totalPages'] as num?)?.toInt(),
);

Map<String, dynamic> _$MoviePaginationResponseToJson(
  MoviePaginationResponse instance,
) => <String, dynamic>{
  'content': instance.content,
  'page': instance.page,
  'size': instance.size,
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
};

MovieCountByGenreResponse _$MovieCountByGenreResponseFromJson(
  Map<String, dynamic> json,
) => MovieCountByGenreResponse(
  genre: $enumDecodeNullable(_$MovieGenreEnumMap, json['genre']),
  count: (json['count'] as num?)?.toInt(),
);

Map<String, dynamic> _$MovieCountByGenreResponseToJson(
  MovieCountByGenreResponse instance,
) => <String, dynamic>{
  'genre': _$MovieGenreEnumMap[instance.genre],
  'count': instance.count,
};

const _$MovieGenreEnumMap = {
  MovieGenre.comedy: 'COMEDY',
  MovieGenre.adventure: 'ADVENTURE',
  MovieGenre.tragedy: 'TRAGEDY',
  MovieGenre.scienceFiction: 'SCIENCE_FICTION',
};

TotalLengthResponse _$TotalLengthResponseFromJson(Map<String, dynamic> json) =>
    TotalLengthResponse(totalLength: (json['totalLength'] as num?)?.toInt());

Map<String, dynamic> _$TotalLengthResponseToJson(
  TotalLengthResponse instance,
) => <String, dynamic>{'totalLength': instance.totalLength};

MovieSearchByNameRequest _$MovieSearchByNameRequestFromJson(
  Map<String, dynamic> json,
) => MovieSearchByNameRequest(namePrefix: json['namePrefix'] as String);

Map<String, dynamic> _$MovieSearchByNameRequestToJson(
  MovieSearchByNameRequest instance,
) => <String, dynamic>{'namePrefix': instance.namePrefix};

MovieCountByGenreRequest _$MovieCountByGenreRequestFromJson(
  Map<String, dynamic> json,
) => MovieCountByGenreRequest(
  genre: $enumDecode(_$MovieGenreEnumMap, json['genre']),
);

Map<String, dynamic> _$MovieCountByGenreRequestToJson(
  MovieCountByGenreRequest instance,
) => <String, dynamic>{'genre': _$MovieGenreEnumMap[instance.genre]!};

MovieSearchRequestOperator _$MovieSearchRequestOperatorFromJson(
  Map<String, dynamic> json,
) => MovieSearchRequestOperator(
  name: json['name'] as String?,
  nationality: $enumDecodeNullable(_$CountryEnumMap, json['nationality']),
);

Map<String, dynamic> _$MovieSearchRequestOperatorToJson(
  MovieSearchRequestOperator instance,
) => <String, dynamic>{
  'name': instance.name,
  'nationality': _$CountryEnumMap[instance.nationality],
};

const _$CountryEnumMap = {
  Country.france: 'FRANCE',
  Country.vatican: 'VATICAN',
  Country.southKorea: 'SOUTH_KOREA',
};

RangeInt32 _$RangeInt32FromJson(Map<String, dynamic> json) => RangeInt32(
  min: (json['min'] as num?)?.toInt(),
  max: (json['max'] as num?)?.toInt(),
);

Map<String, dynamic> _$RangeInt32ToJson(RangeInt32 instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};

RangeInt64 _$RangeInt64FromJson(Map<String, dynamic> json) => RangeInt64(
  min: (json['min'] as num?)?.toInt(),
  max: (json['max'] as num?)?.toInt(),
);

Map<String, dynamic> _$RangeInt64ToJson(RangeInt64 instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};

RangeDouble _$RangeDoubleFromJson(Map<String, dynamic> json) => RangeDouble(
  min: (json['min'] as num?)?.toDouble(),
  max: (json['max'] as num?)?.toDouble(),
);

Map<String, dynamic> _$RangeDoubleToJson(RangeDouble instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};

CoordinatesXRange _$CoordinatesXRangeFromJson(Map<String, dynamic> json) =>
    CoordinatesXRange(
      min: (json['min'] as num?)?.toInt(),
      max: (json['max'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CoordinatesXRangeToJson(CoordinatesXRange instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};

CoordinatesYRange _$CoordinatesYRangeFromJson(Map<String, dynamic> json) =>
    CoordinatesYRange(
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CoordinatesYRangeToJson(CoordinatesYRange instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};

MovieCoordinatesFilter _$MovieCoordinatesFilterFromJson(
  Map<String, dynamic> json,
) => MovieCoordinatesFilter(
  x: json['x'] == null
      ? null
      : CoordinatesXRange.fromJson(json['x'] as Map<String, dynamic>),
  y: json['y'] == null
      ? null
      : CoordinatesYRange.fromJson(json['y'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MovieCoordinatesFilterToJson(
  MovieCoordinatesFilter instance,
) => <String, dynamic>{'x': instance.x, 'y': instance.y};

MovieLengthFilter _$MovieLengthFilterFromJson(Map<String, dynamic> json) =>
    MovieLengthFilter(
      min: (json['min'] as num?)?.toInt(),
      max: (json['max'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MovieLengthFilterToJson(MovieLengthFilter instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};

MovieOscarsCountFilter _$MovieOscarsCountFilterFromJson(
  Map<String, dynamic> json,
) => MovieOscarsCountFilter(
  min: (json['min'] as num?)?.toInt(),
  max: (json['max'] as num?)?.toInt(),
);

Map<String, dynamic> _$MovieOscarsCountFilterToJson(
  MovieOscarsCountFilter instance,
) => <String, dynamic>{'min': instance.min, 'max': instance.max};

MovieTotalBoxOfficeFilter _$MovieTotalBoxOfficeFilterFromJson(
  Map<String, dynamic> json,
) => MovieTotalBoxOfficeFilter(
  min: (json['min'] as num?)?.toDouble(),
  max: (json['max'] as num?)?.toDouble(),
);

Map<String, dynamic> _$MovieTotalBoxOfficeFilterToJson(
  MovieTotalBoxOfficeFilter instance,
) => <String, dynamic>{'min': instance.min, 'max': instance.max};

MovieSearchRequest _$MovieSearchRequestFromJson(Map<String, dynamic> json) =>
    MovieSearchRequest(
      sort: json['sort'] as String?,
      name: json['name'] as String?,
      genre: $enumDecodeNullable(_$MovieGenreEnumMap, json['genre']),
      oscarsCount: json['oscarsCount'] == null
          ? null
          : MovieOscarsCountFilter.fromJson(
              json['oscarsCount'] as Map<String, dynamic>,
            ),
      totalBoxOffice: json['totalBoxOffice'] == null
          ? null
          : MovieTotalBoxOfficeFilter.fromJson(
              json['totalBoxOffice'] as Map<String, dynamic>,
            ),
      length: json['length'] == null
          ? null
          : MovieLengthFilter.fromJson(json['length'] as Map<String, dynamic>),
      coordinates: json['coordinates'] == null
          ? null
          : MovieCoordinatesFilter.fromJson(
              json['coordinates'] as Map<String, dynamic>,
            ),
      operator: json['operator'] == null
          ? null
          : MovieSearchRequestOperator.fromJson(
              json['operator'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$MovieSearchRequestToJson(MovieSearchRequest instance) =>
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
