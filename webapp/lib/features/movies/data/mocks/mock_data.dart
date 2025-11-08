import 'dart:math';

import 'package:webapp/features/movies/data/models/coordinates_dto.dart';
import 'package:webapp/features/movies/data/models/location_dto.dart';
import 'package:webapp/features/movies/data/models/movie_dto.dart';
import 'package:webapp/features/movies/domain/entities/movie_draft.dart';

import '../../domain/entities/coordinates.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_enums.dart';
import '../../domain/entities/person.dart';
import '../models/person_dto.dart';

final random = Random();

final List<String> _personNames = [
  'Emma Johnson', 'Liam Smith', 'Olivia Brown', 'Noah Davis', 'Ava Wilson',
  'William Moore', 'Sophia Taylor', 'James Anderson', 'Isabella Thomas', 'Benjamin Jackson',
  'Mia White', 'Lucas Harris', 'Charlotte Martin', 'Henry Thompson', 'Amelia Garcia',
  'Alexander Martinez', 'Harper Robinson', 'Michael Clark', 'Evelyn Rodriguez', 'Daniel Lewis',
  'Abigail Lee', 'Matthew Walker', 'Emily Hall', 'David Allen', 'Elizabeth Young',
  'Joseph King', 'Sofia Wright', 'Samuel Lopez', 'Avery Hill', 'Gabriel Scott'
];

final List<String> _movieNames = [
  'Shadows of Tomorrow', 'Echoes in the Rain', 'The Last Horizon', 'Whispers of the Wind',
  'Beyond the Stars', 'Silent Revolution', 'Fragments of Memory', 'Crimson Skies',
  'The Forgotten Path', 'Eternal Dawn', 'Veil of Secrets', 'Midnight Symphony',
  'Ashes of Hope', 'Parallel Dreams', 'Frozen Echoes', 'The Crimson Code',
  'Labyrinth of Time', 'Beneath Silent Waters', 'Rise of the Phoenix', 'Shattered Illusions',
  'The Quantum Paradox', 'Wings of Destiny', 'Legacy of Shadows', 'Chronicles of Solitude',
  'The Neon Mirage', 'Fractured Reality', 'Embers of Eternity', 'The Obsidian Gate',
  'Whispers from the Void', 'Celestial Drift', 'The Iron Covenant', 'Mirrors of Deception',
  'Sands of Oblivion', 'The Velvet Conspiracy', 'Orchids in the Storm', 'The Phantom Protocol',
  'Eclipse of Reason', 'Voyage of the Forgotten', 'The Sapphire Enigma', 'Threads of Fate',
  'The Obsidian Labyrinth', 'Requiem for a Dreamer', 'The Crimson Horizon', 'Ashes and Stardust',
  'The Silent Uprising', 'Veil of the Ancients', 'The Quantum Mirage', 'Eternal Crossroads',
  'Shadows Beneath', 'The Last Ember'
];

final List<EyeColor?> _eyeColors = [EyeColor.green, EyeColor.red, EyeColor.black, EyeColor.orange, null];
final List<HairColor> _hairColors = [HairColor.green, HairColor.red, HairColor.black, HairColor.blue];
final List<Country?> _countries = [Country.france, Country.vatican, Country.southKorea, null];
final List<MovieGenre?> _genres = [MovieGenre.comedy, MovieGenre.adventure, MovieGenre.tragedy, MovieGenre.scienceFiction, null];

final Random _random = Random();

// Генерация случайной даты между 1990 и 2024 годами
DateTime _randomDate() {
  final year = 1990 + _random.nextInt(35);
  final month = 1 + _random.nextInt(12);
  final day = 1 + _random.nextInt(28); // Упрощаем, избегая проблем с днями в месяце
  return DateTime(year, month, day);
}

// Генерация случайного паспортного ID (формат: XXX-XXXX)
String _generatePassportID() {
  final part1 = _random.nextInt(900) + 100; // 100-999
  final part2 = _random.nextInt(9000) + 1000; // 1000-9999
  return '$part1-$part2';
}

// --- Основные списки ---

List<String> get personNames => List.unmodifiable(_personNames);

List<String> get movieNames => List.unmodifiable(_movieNames);

List<PersonDto> get persons {
  return List.generate(30, (index) {
    return PersonDto(
      name: _personNames[index],
      passportID: _generatePassportID(),
      eyeColor: _eyeColors[_random.nextInt(_eyeColors.length)],
      hairColor: _hairColors[_random.nextInt(_hairColors.length)],
      nationality: _countries[_random.nextInt(_countries.length)],
      location: LocationDto(
        x: _random.nextDouble() * 1000,
        y: _random.nextInt(1000),
        z: _random.nextInt(1000),
      ),
    );
  });
}

List<MovieDto> get moviesBuilder {
  final personsList = persons; // Генерируем один раз, чтобы избежать повторной генерации
  return List.generate(50, (index) {
    // Случайный выбор режиссёра и оператора из списка persons
    final director = personsList[_random.nextInt(personsList.length)];
    final operator = _random.nextBool()
        ? personsList[_random.nextInt(personsList.length)]
        : null;

    return MovieDto(
      id: index + 1,
      name: _movieNames[index],
      coordinates: CoordinatesDto(
        x: _random.nextInt(1000),
        y: _random.nextDouble() * 1000,
      ),
      creationDate: _randomDate(),
      oscarsCount: _random.nextBool() ? _random.nextInt(10) : null,
      totalBoxOffice: _random.nextBool() ? (_random.nextDouble() * 2000).round() / 10 : null,
      length: 60 + _random.nextInt(180), // от 60 до 240 минут
      director: director,
      genre: _genres[_random.nextInt(_genres.length)],
      operator: operator,
    );
  });
}

class MockData {
  final List<MovieDto> movies;
  static final MockData _instance = MockData._internal();

  MockData._internal() : movies = moviesBuilder;

  factory MockData() => _instance;
}