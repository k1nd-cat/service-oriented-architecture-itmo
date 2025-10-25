import 'package:webapp/features/movies/data/models/looser_dto.dart';
import 'package:webapp/features/movies/domain/entities/looser.dart';

class LooserMapper {
  static Looser toEntity(LooserDto dto) {
    return Looser(name: dto.name, passportID: dto.passportID, filmsCount: dto.filmsCount);
  }

  static List<Looser> toEntityList(List<LooserDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}