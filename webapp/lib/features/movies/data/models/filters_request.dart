import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/movie_enums.dart';

part 'filters_request.g.dart';

@JsonSerializable(createFactory: false)
class MoviesFilter {
  final String? sort;
  final String? name;
  final MovieGenre? genre;
  final IntFilter oscarsCount;
  final DoubleFilter totalBoxOffice;
  final IntFilter length;
  final CoordinatesFilter coordinates;
  final PersonFilter operator;

  const MoviesFilter({
    required this.sort,
    required this.name,
    required this.genre,
    required this.oscarsCount,
    required this.totalBoxOffice,
    required this.length,
    required this.coordinates,
    required this.operator,
  });

  Map<String, dynamic> toJson() => _$MoviesFilterToJson(this);

  MoviesFilter copyWith({
    String? sort,
    String? name,
    MovieGenre? genre,
    IntFilter? oscarsCount,
    DoubleFilter? totalBoxOffice,
    IntFilter? length,
    CoordinatesFilter? coordinates,
    PersonFilter? operator,
  }) {
    return MoviesFilter(
      sort: sort ?? this.sort,
      name: name ?? this.name,
      genre: genre ?? this.genre,
      oscarsCount: oscarsCount ?? this.oscarsCount,
      totalBoxOffice: totalBoxOffice ?? this.totalBoxOffice,
      length: length ?? this.length,
      coordinates: coordinates ?? this.coordinates,
      operator: operator ?? this.operator,
    );
  }

}

@JsonSerializable(createFactory: false)
class PersonFilter {
  final String? name;
  final Country? nationality;

  const PersonFilter({
    required this.name,
    required this.nationality,
  });

  Map<String, dynamic> toJson() => _$PersonFilterToJson(this);

  PersonFilter copyWith({
    String? name,
    Country? nationality,
  }) {
    return PersonFilter(
      name: name ?? this.name,
      nationality: nationality ?? this.nationality,
    );
  }
}

@JsonSerializable(createFactory: false)
class CoordinatesFilter {
  final IntFilter? x;
  final DoubleFilter? y;

  const CoordinatesFilter({
    required this.x,
    required this.y,
  });

  Map<String, dynamic> toJson() => _$CoordinatesFilterToJson(this);

  CoordinatesFilter copyWith({
    IntFilter? x,
    DoubleFilter? y,
  }) {
    return CoordinatesFilter(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}

@JsonSerializable(createFactory: false)
class DoubleFilter {
  final double? min;
  final double? max;

  const DoubleFilter({
    required this.min,
    required this.max,
  });

  Map<String, dynamic> toJson() => _$DoubleFilterToJson(this);

  DoubleFilter copyWith({
    double? min,
    double? max,
  }) {
    return DoubleFilter(
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }
}

@JsonSerializable(createFactory: false)
class IntFilter {
  final int? min;
  final int? max;

  const IntFilter({
    required this.min,
    required this.max,
  });

  Map<String, dynamic> toJson() => _$IntFilterToJson(this);

  IntFilter copyWith({
    int? min,
    int? max,
  }) {
    return IntFilter(
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }
}
