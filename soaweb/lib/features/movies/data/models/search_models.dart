import 'package:json_annotation/json_annotation.dart';

import 'movie_dto.dart';
import 'movie_enums.dart';

part 'search_models.g.dart';

@JsonSerializable()
class OscarHumiliationResponse {
  final int? affectedDirectors;

  final int? affectedMovies;

  final int? removedOscars;

  OscarHumiliationResponse({
    this.affectedDirectors,
    this.affectedMovies,
    this.removedOscars,
  });

  factory OscarHumiliationResponse.fromJson(Map<String, dynamic> json) => _$OscarHumiliationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OscarHumiliationResponseToJson(this);
}

@JsonSerializable()
class LooserDirector {
  final String? name;

  final String? passportID;

  final int? filmsCount;

  LooserDirector({
    this.name,
    this.passportID,
    this.filmsCount,
  });

  factory LooserDirector.fromJson(Map<String, dynamic> json) => _$LooserDirectorFromJson(json);

  Map<String, dynamic> toJson() => _$LooserDirectorToJson(this);
}

@JsonSerializable()
class MoviePaginationResponse {
  final List<Movie>? content;

  final int? page;

  final int? size;

  final int? totalElements;

  final int? totalPages;

  MoviePaginationResponse({
    this.content,
    this.page,
    this.size,
    this.totalElements,
    this.totalPages,
  });

  factory MoviePaginationResponse.fromJson(Map<String, dynamic> json) => _$MoviePaginationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MoviePaginationResponseToJson(this);
}

@JsonSerializable()
class MovieCountByGenreResponse {
  final MovieGenre? genre;

  final int? count;

  MovieCountByGenreResponse({
    this.genre,
    this.count,
  });

  factory MovieCountByGenreResponse.fromJson(Map<String, dynamic> json) => _$MovieCountByGenreResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieCountByGenreResponseToJson(this);
}

@JsonSerializable()
class TotalLengthResponse {
  final int? totalLength;

  TotalLengthResponse({
    this.totalLength,
  });

  factory TotalLengthResponse.fromJson(Map<String, dynamic> json) => _$TotalLengthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TotalLengthResponseToJson(this);
}

@JsonSerializable()
class MovieSearchByNameRequest {
  final String namePrefix;

  MovieSearchByNameRequest({
    required this.namePrefix,
  });

  factory MovieSearchByNameRequest.fromJson(Map<String, dynamic> json) => _$MovieSearchByNameRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MovieSearchByNameRequestToJson(this);
}

@JsonSerializable()
class MovieCountByGenreRequest {
  final MovieGenre genre;

  MovieCountByGenreRequest({
    required this.genre,
  });

  factory MovieCountByGenreRequest.fromJson(Map<String, dynamic> json) => _$MovieCountByGenreRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MovieCountByGenreRequestToJson(this);
}

@JsonSerializable()
class MovieSearchRequestOperator {
  final String? name;

  final Country? nationality;

  MovieSearchRequestOperator({
    this.name,
    this.nationality,
  });

  factory MovieSearchRequestOperator.fromJson(Map<String, dynamic> json) => _$MovieSearchRequestOperatorFromJson(json);

  Map<String, dynamic> toJson() => _$MovieSearchRequestOperatorToJson(this);
}

@JsonSerializable()
class RangeInt32 {
  final int? min;

  final int? max;

  RangeInt32({this.min, this.max});

  factory RangeInt32.fromJson(Map<String, dynamic> json) => _$RangeInt32FromJson(json);
  Map<String, dynamic> toJson() => _$RangeInt32ToJson(this);
}

@JsonSerializable()
class RangeInt64 {
  final int? min;

  final int? max;

  RangeInt64({this.min, this.max});

  factory RangeInt64.fromJson(Map<String, dynamic> json) => _$RangeInt64FromJson(json);
  Map<String, dynamic> toJson() => _$RangeInt64ToJson(this);
}

@JsonSerializable()
class RangeDouble {
  final double? min;

  final double? max;

  RangeDouble({this.min, this.max});

  factory RangeDouble.fromJson(Map<String, dynamic> json) => _$RangeDoubleFromJson(json);
  Map<String, dynamic> toJson() => _$RangeDoubleToJson(this);
}

@JsonSerializable()
class CoordinatesXRange extends RangeInt32 {
  CoordinatesXRange({super.min, super.max});

  factory CoordinatesXRange.fromJson(Map<String, dynamic> json) => _$CoordinatesXRangeFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$CoordinatesXRangeToJson(this);
}

@JsonSerializable()
class CoordinatesYRange extends RangeDouble {
  CoordinatesYRange({super.min, super.max});

  factory CoordinatesYRange.fromJson(Map<String, dynamic> json) => _$CoordinatesYRangeFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$CoordinatesYRangeToJson(this);
}

@JsonSerializable()
class MovieCoordinatesFilter {
  final CoordinatesXRange? x;

  final CoordinatesYRange? y;

  MovieCoordinatesFilter({this.x, this.y});

  factory MovieCoordinatesFilter.fromJson(Map<String, dynamic> json) => _$MovieCoordinatesFilterFromJson(json);

  Map<String, dynamic> toJson() => _$MovieCoordinatesFilterToJson(this);
}

@JsonSerializable()
class MovieLengthFilter extends RangeInt64 {
  MovieLengthFilter({super.min, super.max});

  factory MovieLengthFilter.fromJson(Map<String, dynamic> json) => _$MovieLengthFilterFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovieLengthFilterToJson(this);
}

@JsonSerializable()
class MovieOscarsCountFilter extends RangeInt32 {
  MovieOscarsCountFilter({super.min, super.max});

  factory MovieOscarsCountFilter.fromJson(Map<String, dynamic> json) => _$MovieOscarsCountFilterFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovieOscarsCountFilterToJson(this);
}

@JsonSerializable()
class MovieTotalBoxOfficeFilter extends RangeDouble {
  MovieTotalBoxOfficeFilter({super.min, super.max});

  factory MovieTotalBoxOfficeFilter.fromJson(Map<String, dynamic> json) => _$MovieTotalBoxOfficeFilterFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MovieTotalBoxOfficeFilterToJson(this);
}

@JsonSerializable()
class MovieSearchRequest {
  final String? sort;

  final String? name;

  final MovieGenre? genre;

  final MovieOscarsCountFilter? oscarsCount;

  final MovieTotalBoxOfficeFilter? totalBoxOffice;

  final MovieLengthFilter? length;

  final MovieCoordinatesFilter? coordinates;

  final MovieSearchRequestOperator? operator;

  MovieSearchRequest({
    this.sort,
    this.name,
    this.genre,
    this.oscarsCount,
    this.totalBoxOffice,
    this.length,
    this.coordinates,
    this.operator,
  });

  factory MovieSearchRequest.fromJson(Map<String, dynamic> json) => _$MovieSearchRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MovieSearchRequestToJson(this);
}