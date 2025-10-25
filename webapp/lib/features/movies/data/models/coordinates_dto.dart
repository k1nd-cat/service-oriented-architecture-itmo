import 'package:json_annotation/json_annotation.dart';

part 'coordinates_dto.g.dart';

@JsonSerializable()
class CoordinatesDto {
  final int x;
  final double y;

  const CoordinatesDto({required this.x, required this.y});

  factory CoordinatesDto.fromJson(Map<String, dynamic> json) => _$CoordinatesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinatesDtoToJson(this);
}
