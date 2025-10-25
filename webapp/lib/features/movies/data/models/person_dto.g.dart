// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonDto _$PersonDtoFromJson(Map<String, dynamic> json) => PersonDto(
  name: json['name'] as String,
  passportID: json['passportID'] as String,
  eyeColor: $enumDecodeNullable(_$EyeColorEnumMap, json['eyeColor']),
  hairColor: $enumDecode(_$HairColorEnumMap, json['hairColor']),
  nationality: $enumDecodeNullable(_$CountryEnumMap, json['nationality']),
  location: LocationDto.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PersonDtoToJson(PersonDto instance) => <String, dynamic>{
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
