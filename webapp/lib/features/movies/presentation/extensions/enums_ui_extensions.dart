import '../../domain/entities/movie_enums.dart';

extension HairColorUiExtension on HairColor {
  String get uiString => switch (this) {
    HairColor.red => 'Красный',
    HairColor.green => 'Зелёный',
    HairColor.black => 'Чёрный',
    HairColor.blue => 'Голубой',
  };
}

extension EyeColorUiExtension on EyeColor {
  String get uiString => switch (this) {
    EyeColor.red => 'Красный',
    EyeColor.green => 'Зелёный',
    EyeColor.black => 'Чёрный',
    EyeColor.orange => 'Оранжевый',
  };
}

extension CountryUiExtension on Country {
  String get uiString => switch (this) {
    Country.vatican => 'Ватикан',
    Country.france => 'Франция',
    Country.southKorea => 'Южная Корея',
  };
}

extension MovieGenreUiExtension on MovieGenre {
  String get uiString => switch (this) {
    MovieGenre.comedy => 'Комедия',
    MovieGenre.adventure => 'Приключения',
    MovieGenre.tragedy => 'Трагедия',
    MovieGenre.scienceFiction => 'Научная фатнастика',
  };
}
