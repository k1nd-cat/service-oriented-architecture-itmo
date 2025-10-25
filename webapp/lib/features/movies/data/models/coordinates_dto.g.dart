// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinates_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoordinatesDto _$CoordinatesDtoFromJson(Map<String, dynamic> json) =>
    CoordinatesDto(
      x: (json['x'] as num).toInt(),
      y: (json['y'] as num).toDouble(),
    );

Map<String, dynamic> _$CoordinatesDtoToJson(CoordinatesDto instance) =>
    <String, dynamic>{'x': instance.x, 'y': instance.y};
