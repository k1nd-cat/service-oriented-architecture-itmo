import 'package:webapp/features/movies/data/models/movie_dto.dart';
import 'package:webapp/features/movies/domain/entities/movie.dart';
import 'package:webapp/features/movies/domain/entities/movie_draft.dart';

import 'coordinates_mapper.dart';
import 'person_mapper.dart';

class MovieMapper {
  static Movie toEntity(MovieDto dto) {
    return Movie(
      id: dto.id!,
      name: dto.name,
      coordinates: CoordinatesMapper.toEntity(dto.coordinates),
      creationDate: dto.creationDate!,
      length: dto.length,
      director: PersonMapper.toEntity(dto.director),
      oscarsCount: dto.oscarsCount,
      totalBoxOffice: dto.totalBoxOffice,
      genre: dto.genre,
      operator: dto.operator != null
          ? PersonMapper.toEntity(dto.operator!)
          : null,
    );
  }

  static MovieDto toDto(MovieDraft entity) {
    return MovieDto(
      id: entity.id,
      name: entity.name,
      coordinates: CoordinatesMapper.toDto(entity.coordinates),
      creationDate: null,
      oscarsCount: entity.oscarsCount,
      totalBoxOffice: entity.totalBoxOffice,
      length: entity.length,
      director: PersonMapper.toDto(entity.director),
      genre: entity.genre,
      operator: entity.operator != null
          ? PersonMapper.toDto(entity.operator!)
          : null,
    );
  }

  static List<Movie> toEntityList(List<MovieDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}
