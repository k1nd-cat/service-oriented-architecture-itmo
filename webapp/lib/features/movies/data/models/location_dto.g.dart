// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationDto _$LocationDtoFromJson(Map<String, dynamic> json) => LocationDto(
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toInt(),
  z: (json['z'] as num).toInt(),
);

Map<String, dynamic> _$LocationDtoToJson(LocationDto instance) =>
    <String, dynamic>{'x': instance.x, 'y': instance.y, 'z': instance.z};
