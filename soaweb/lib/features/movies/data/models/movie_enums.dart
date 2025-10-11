import 'package:json_annotation/json_annotation.dart';

enum EyeColor {
  @JsonValue('GREEN')
  green,
  @JsonValue('RED')
  red,
  @JsonValue('BLACK')
  black,
  @JsonValue('ORANGE')
  orange;
}

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

  String get value {
    switch (this) {
      case MovieGenre.comedy:
        return 'COMEDY';
      case MovieGenre.adventure:
        return 'ADVENTURE';
      case MovieGenre.tragedy:
        return 'TRAGEDY';
      case MovieGenre.scienceFiction:
        return 'SCIENCE_FICTION';
    }
  }
}