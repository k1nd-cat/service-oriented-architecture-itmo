import 'package:webapp/features/movies/data/models/coordinates_dto.dart';
import 'package:webapp/features/movies/domain/entities/coordinates.dart';

class CoordinatesMapper {
  static Coordinates toEntity(CoordinatesDto dto) {
    return Coordinates(x: dto.x, y: dto.y);
  }

  static CoordinatesDto toDto(Coordinates entity) {
    return CoordinatesDto(x: entity.x, y: entity.y);
  }

  static List<Coordinates> toEntityList(List<CoordinatesDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}