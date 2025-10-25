import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_dto.g.dart';

@JsonSerializable()
class LocationDto {
  final double x;
  final int y;
  final int z;

  const LocationDto({
    required this.x,
    required this.y,
    required this.z,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) => _$LocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDtoToJson(this);
}