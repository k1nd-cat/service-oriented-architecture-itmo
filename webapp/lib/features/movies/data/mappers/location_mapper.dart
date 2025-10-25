import 'package:webapp/features/movies/data/models/location_dto.dart';
import 'package:webapp/features/movies/domain/entities/location.dart';

class LocationMapper {
  static Location toEntity(LocationDto dto) {
    return Location(x: dto.x, y: dto.y, z: dto.z);
  }

  static LocationDto toDto(Location entity) {
    return LocationDto(x: entity.x, y: entity.y, z: entity.z);
  }

  static List<Location> toEntityList(List<LocationDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}
