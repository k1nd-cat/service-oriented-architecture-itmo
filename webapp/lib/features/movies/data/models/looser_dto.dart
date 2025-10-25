import 'package:json_annotation/json_annotation.dart';

part 'looser_dto.g.dart';

@JsonSerializable(createToJson: false)
class LooserDto {
  final String name;
  final String passportID;
  final int filmsCount;

  const LooserDto({
    required this.name,
    required this.passportID,
    required this.filmsCount,
  });

  factory LooserDto.fromJson(Map<String, dynamic> json) => _$LooserDtoFromJson(json);
}