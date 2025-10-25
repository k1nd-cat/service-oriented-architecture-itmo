import '../../domain/entities/movie_enums.dart';

extension HairColorExtension on HairColor {
  String toJson() => switch (this) {
    HairColor.green => 'GREEN',
    HairColor.red => 'RED',
    HairColor.black => 'BLACK',
    HairColor.blue => 'BLUE',
  };

  static HairColor fromJson(String json) => switch (json) {
    'GREEN' => HairColor.green,
    'RED' => HairColor.red,
    'BLACK' => HairColor.black,
    'BLUE' => HairColor.blue,
    _ => throw ArgumentError('Unknown HairColor value: $json'),
  };
}

extension EyeColorExtension on EyeColor {
  String toJson() => switch (this) {
    EyeColor.green => 'GREEN',
    EyeColor.red => 'RED',
    EyeColor.black => 'BLACK',
    EyeColor.orange => 'ORANGE',
  };

  static EyeColor fromJson(String json) => switch (json) {
    'GREEN' => EyeColor.green,
    'RED' => EyeColor.red,
    'BLACK' => EyeColor.black,
    'ORANGE' => EyeColor.orange,
    _ => throw ArgumentError('Unknown EyeColor value: $json'),
  };
}

extension CountryExtension on Country {
  String toJson() => switch (this) {
    Country.france => 'FRANCE',
    Country.vatican => 'VATICAN',
    Country.southKorea => 'SOUTH_KOREA',
  };

  static Country fromJson(String json) => switch (json) {
    'FRANCE' => Country.france,
    'VATICAN' => Country.vatican,
    'SOUTH_KOREA' => Country.southKorea,
    _ => throw ArgumentError('Unknown Country value: $json'),
  };
}

extension MovieGenreExtension on MovieGenre {
  String toJson() => switch (this) {
    MovieGenre.comedy => 'COMEDY',
    MovieGenre.adventure => 'ADVENTURE',
    MovieGenre.tragedy => 'TRAGEDY',
    MovieGenre.scienceFiction => 'SCIENCE_FICTION',
  };

  static MovieGenre fromJson(String json) => switch (json) {
    'COMEDY' => MovieGenre.comedy,
    'ADVENTURE' => MovieGenre.adventure,
    'TRAGEDY' => MovieGenre.tragedy,
    'SCIENCE_FICTION' => MovieGenre.scienceFiction,
    _ => throw ArgumentError('Unknown MovieGenre value: $json'),
  };
}