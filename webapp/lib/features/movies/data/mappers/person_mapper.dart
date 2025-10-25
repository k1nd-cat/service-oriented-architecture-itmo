import 'package:webapp/features/movies/data/mappers/location_mapper.dart';
import 'package:webapp/features/movies/data/models/person_dto.dart';
import 'package:webapp/features/movies/domain/entities/person.dart';

class PersonMapper {
  static Person toEntity(PersonDto dto) {
    return Person(
      name: dto.name,
      passportID: dto.passportID,
      location: LocationMapper.toEntity(dto.location),
      eyeColor: dto.eyeColor,
      hairColor: dto.hairColor,
      nationality: dto.nationality,
    );
  }

  static PersonDto toDto(Person entity) {
    return PersonDto(
      name: entity.name,
      passportID: entity.passportID,
      eyeColor: entity.eyeColor,
      hairColor: entity.hairColor,
      nationality: entity.nationality,
      location: LocationMapper.toDto(entity.location),
    );
  }

  static List<Person> toEntityList(List<PersonDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}
