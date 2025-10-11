// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coordinates _$CoordinatesFromJson(Map<String, dynamic> json) => Coordinates(
  x: (json['x'] as num).toInt(),
  y: (json['y'] as num).toDouble(),
);

Map<String, dynamic> _$CoordinatesToJson(Coordinates instance) =>
    <String, dynamic>{'x': instance.x, 'y': instance.y};

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toInt(),
  z: (json['z'] as num).toInt(),
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'x': instance.x,
  'y': instance.y,
  'z': instance.z,
};

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
  name: json['name'] as String,
  passportID: json['passportID'] as String,
  eyeColor: $enumDecodeNullable(_$EyeColorEnumMap, json['eyeColor']),
  hairColor: $enumDecode(_$HairColorEnumMap, json['hairColor']),
  nationality: $enumDecodeNullable(_$CountryEnumMap, json['nationality']),
  location: Location.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
  'name': instance.name,
  'passportID': instance.passportID,
  'eyeColor': _$EyeColorEnumMap[instance.eyeColor],
  'hairColor': _$HairColorEnumMap[instance.hairColor]!,
  'nationality': _$CountryEnumMap[instance.nationality],
  'location': instance.location,
};

const _$EyeColorEnumMap = {
  EyeColor.green: 'GREEN',
  EyeColor.red: 'RED',
  EyeColor.black: 'BLACK',
  EyeColor.orange: 'ORANGE',
};

const _$HairColorEnumMap = {
  HairColor.green: 'GREEN',
  HairColor.red: 'RED',
  HairColor.black: 'BLACK',
  HairColor.blue: 'BLUE',
};

const _$CountryEnumMap = {
  Country.france: 'FRANCE',
  Country.vatican: 'VATICAN',
  Country.southKorea: 'SOUTH_KOREA',
};

Error _$ErrorFromJson(Map<String, dynamic> json) => Error(
  error: json['error'] as String,
  message: json['message'] as String,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
  path: json['path'] as String?,
);

Map<String, dynamic> _$ErrorToJson(Error instance) => <String, dynamic>{
  'error': instance.error,
  'message': instance.message,
  'timestamp': instance.timestamp?.toIso8601String(),
  'path': instance.path,
};
