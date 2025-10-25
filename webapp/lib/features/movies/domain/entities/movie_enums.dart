import 'package:json_annotation/json_annotation.dart';

enum HairColor {
  @JsonValue('GREEN')
  green,
  @JsonValue('RED')
  red,
  @JsonValue('BLACK')
  black,
  @JsonValue('BLUE')
  blue;
}

enum EyeColor {
  @JsonValue('GREEN')
  green,
  @JsonValue('RED')
  red,
  @JsonValue('BLACK')
  black,
  @JsonValue('ORANGE')
  orange,
}

enum Country {
  @JsonValue('FRANCE')
  france,
  @JsonValue('VATICAN')
  vatican,
  @JsonValue('SOUTH_KOREA')
  southKorea;
}

enum MovieGenre {
  @JsonValue('COMEDY')
  comedy,
  @JsonValue('ADVENTURE')
  adventure,
  @JsonValue('TRAGEDY')
  tragedy,
  @JsonValue('SCIENCE_FICTION')
  scienceFiction;
}