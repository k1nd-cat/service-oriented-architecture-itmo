import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webapp/features/movies/presentation/extensions/enums_ui_extensions.dart';
import 'package:webapp/shared/widgets/validation_text_field.dart';

import '../../../../shared/widgets/one_action_dialog.dart';
import '../../../../shared/widgets/validation_dropdown.dart';
import '../../domain/entities/coordinates.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_draft.dart';
import '../../domain/entities/movie_enums.dart';
import '../../domain/entities/person.dart';
import '../providers/create_movie_provider.dart';

class CreateMovie extends ConsumerStatefulWidget {
  final Movie? movie;

  const CreateMovie({this.movie, super.key});

  @override
  ConsumerState<CreateMovie> createState() => _CreateMovieState();
}

class _CreateMovieState extends ConsumerState<CreateMovie> {
  bool _isFormValid = false;

  final _movieNameController = TextEditingController();
  final _oscarCountController = TextEditingController();
  final _coordinateXController = TextEditingController();
  final _coordinateYController = TextEditingController();
  final _totalBoxOfficeController = TextEditingController();
  final _lengthController = TextEditingController();
  MovieGenre _selectedGenre = MovieGenre.comedy;

  bool isOperator = false;
  final _operatorNameController = TextEditingController();
  final _operatorPassportIDController = TextEditingController();
  EyeColor? _selectedOperatorEyeColor;
  var _selectedOperstorHairColor = HairColor.black;
  Country? _selectedOperatorNationality;
  final _operatorXController = TextEditingController();
  final _operatorYController = TextEditingController();
  final _operatorZController = TextEditingController();

  final _directorNameController = TextEditingController();
  final _directorPassportIDController = TextEditingController();
  EyeColor? _selectedDirectorEyeColor;
  var _selectedDirectorHairColor = HairColor.black;
  Country? _selectedDirectorNationality;
  final _directorXController = TextEditingController();
  final _directorYController = TextEditingController();
  final _directorZController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.movie != null) {
      final movie = widget.movie!;
      _movieNameController.text = movie.name;
      _coordinateXController.text = movie.coordinates.x.toString();
      _coordinateYController.text = movie.coordinates.y.toString();
      _oscarCountController.text = movie.oscarsCount?.toString() ?? '';
      _totalBoxOfficeController.text = movie.totalBoxOffice?.toString() ?? '';
      _lengthController.text = movie.length.toString();

      _selectedGenre = movie.genre ?? MovieGenre.comedy;

      // Заполнение режиссёра
      _directorNameController.text = movie.director.name;
      _directorPassportIDController.text = movie.director.passportID;
      _selectedDirectorEyeColor = movie.director.eyeColor;
      _selectedDirectorHairColor = movie.director.hairColor;
      _selectedDirectorNationality = movie.director.nationality;
      _directorXController.text = movie.director.location.x.toString();
      _directorYController.text = movie.director.location.y.toString();
      _directorZController.text = movie.director.location.z.toString();

      // Заполнение оператора, если он есть
      if (movie.operator != null) {
        isOperator = true;
        _operatorNameController.text = movie.operator!.name;
        _operatorPassportIDController.text = movie.operator!.passportID;
        _selectedOperatorEyeColor = movie.operator!.eyeColor;
        _selectedOperstorHairColor = movie.operator!.hairColor;
        _selectedOperatorNationality = movie.operator!.nationality;
        _operatorXController.text = movie.operator!.location.x.toString();
        _operatorYController.text = movie.operator!.location.y.toString();
        _operatorZController.text = movie.operator!.location.z.toString();
      } else {
        isOperator = false;
      }
    }

    List<TextEditingController> allControllers = [
      _movieNameController,
      _oscarCountController,
      _coordinateXController,
      _coordinateYController,
      _totalBoxOfficeController,
      _operatorNameController,
      _operatorPassportIDController,
      _operatorXController,
      _operatorYController,
      _operatorZController,
      _directorNameController,
      _directorPassportIDController,
      _directorXController,
      _directorYController,
      _directorZController,
      _lengthController,
    ];

    for (var c in allControllers) {
      c.addListener(_updateFormValid);
    }
  }

  void _onSavePressed() async {
    final draft = validateAndCreateDraft();
    final notifier = ref.read(createMovieProvider.notifier);
    await notifier.createOrUpdate(draft!, movieId: widget.movie?.id);

    final state = ref.read(createMovieProvider);
    if (state.errorMessage != null) {
      await showOneActionDialog(
        context,
        message: 'Ошибка: ${state.errorMessage}',
        buttonText: 'Ок',
        action: () {},
      );
    } else {
      await showOneActionDialog(
        context,
        message: 'Фильм успешно сохранён!',
        buttonText: 'Ок',
        action: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  void _updateFormValid() {
    setState(() {
      _isFormValid = validateAndCreateDraft() != null;
    });
  }

  Widget createPerson(bool director) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 20,
          runSpacing: 10,
          children: [
            ValidationTestField(
              width: 400,
              textEditingController: director
                  ? _directorNameController
                  : _operatorNameController,
              label: "Имя",
              validations: [
                ValidationConditions(
                  name: "Не может быть пустым",
                  condition: (text) => text.isNotEmpty,
                ),
              ],
            ),
            const SizedBox(height: 15),
            ValidationTestField(
              width: 400,
              textEditingController: director
                  ? _directorPassportIDController
                  : _operatorPassportIDController,
              label: "ID паспорта",
              validations: [
                ValidationConditions(
                  name: "Минимальная длина: 8",
                  condition: (text) => text.isNotEmpty && text.length >= 8,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 20,
          runSpacing: 10,
          children: [
            ValidationDropdownField<EyeColor>(
              width: 250,
              selectedValue: director
                  ? _selectedDirectorEyeColor
                  : _selectedOperatorEyeColor,
              enumValues: EyeColor.values,
              label: 'Цвет глаз',
              allowNull: true,
              itemNameBuilder: (eyeColor) => eyeColor.uiString,
              onChanged: (EyeColor? g) {
                setState(() {
                  if (!director) {
                    _selectedOperatorEyeColor = g;
                  } else {
                    _selectedDirectorEyeColor = g;
                  }
                });
              },
            ),
            ValidationDropdownField<HairColor>(
              width: 250,
              selectedValue: director
                  ? _selectedDirectorHairColor
                  : _selectedOperstorHairColor,
              enumValues: HairColor.values,
              label: 'Цвет глаз',
              allowNull: false,
              itemNameBuilder: (hairColor) => hairColor.uiString,
              onChanged: (HairColor? g) {
                setState(() {
                  if (!director) {
                    _selectedOperstorHairColor = g!;
                  } else {
                    _selectedDirectorHairColor = g!;
                  }
                });
              },
            ),
            ValidationDropdownField<Country>(
              width: 250,
              selectedValue: director
                  ? _selectedDirectorNationality
                  : _selectedOperatorNationality,
              enumValues: Country.values,
              label: 'Национальность',
              allowNull: true,
              itemNameBuilder: (nationality) => nationality.uiString,
              onChanged: (Country? g) {
                setState(() {
                  if (!director) {
                    _selectedOperatorNationality = g;
                  } else {
                    _selectedDirectorNationality = g;
                  }
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text("Местоположение", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 20,
          runSpacing: 10,
          children: [
            ValidationTestField(
              textEditingController: director
                  ? _directorXController
                  : _operatorXController,
              label: "X",
              maxLength: 24,
              validations: [
                ValidationConditions(
                  name: "Вещественное число",
                  condition: (text) =>
                      double.tryParse(text) != null ? true : false,
                ),
              ],
            ),
            ValidationTestField(
              textEditingController: director
                  ? _directorYController
                  : _operatorYController,
              label: "Y",
              maxLength: 15,
              validations: [
                ValidationConditions(
                  name: "Целое число",
                  condition: (text) =>
                      int.tryParse(text) != null ? true : false,
                ),
              ],
            ),
            ValidationTestField(
              textEditingController: director
                  ? _directorZController
                  : _operatorZController,
              label: "Z",
              maxLength: 9,
              validations: [
                ValidationConditions(
                  name: "Целое число",
                  condition: (text) =>
                      int.tryParse(text) != null ? true : false,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createMovieProvider);

    return SingleChildScrollView(
      reverse: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              widget.movie == null ? 'Создать фильм' : 'Обновить фильм',
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 10),
            ValidationTestField(
              width: 400,
              textEditingController: _movieNameController,
              label: "Название фильма",
              validations: [
                ValidationConditions(
                  name: "Не может быть пустым",
                  condition: (text) => text.isNotEmpty,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                ValidationTestField(
                  width: 210,
                  maxLength: 9,
                  textEditingController: _oscarCountController,
                  label: "Количество оскаров",
                  validations: [
                    ValidationConditions(
                      name: "Целое число",
                      condition: (text) => int.tryParse(text) != null,
                    ),
                    ValidationConditions(
                      name: "Больше нуля",
                      condition: (text) {
                        var oscarCount = int.tryParse(text);
                        if (oscarCount == null || oscarCount <= 0) return false;
                        return true;
                      },
                    ),
                  ],
                ),
                ValidationTestField(
                  maxLength: 15,
                  width: 210,
                  textEditingController: _totalBoxOfficeController,
                  label: "Кассовые сборы",
                  validations: [
                    ValidationConditions(
                      name: "Вещественное число",
                      condition: (text) =>
                          text.isEmpty || double.tryParse(text) != null,
                    ),
                    ValidationConditions(
                      name: "Больше нуля",
                      condition: (text) {
                        if (text.isEmpty) return true;
                        var oscarCount = double.tryParse(text);
                        if (oscarCount == null || oscarCount <= 0) return false;
                        return true;
                      },
                    ),
                  ],
                ),
                ValidationTestField(
                  width: 210,
                  maxLength: 9,
                  textEditingController: _lengthController,
                  label: "Длина фильма",
                  validations: [
                    ValidationConditions(
                      name: "Целое число",
                      condition: (text) => int.tryParse(text) != null,
                    ),
                    ValidationConditions(
                      name: "Больше нуля",
                      condition: (text) {
                        var oscarCount = int.tryParse(text);
                        if (oscarCount == null || oscarCount <= 0) return false;
                        return true;
                      },
                    ),
                  ],
                ),
                ValidationDropdownField<MovieGenre>(
                  width: 210,
                  selectedValue: _selectedGenre,
                  enumValues: MovieGenre.values,
                  label: 'Жанр',
                  allowNull: false,
                  itemNameBuilder: (genre) => genre.uiString,
                  onChanged: (MovieGenre? g) {
                    setState(() {
                      _selectedGenre = g!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Координаты", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                ValidationTestField(
                  textEditingController: _coordinateXController,
                  label: "X",
                  maxLength: 9,
                  validations: [
                    ValidationConditions(
                      name: "Целое число",
                      condition: (text) =>
                          int.tryParse(text) != null ? true : false,
                    ),
                    ValidationConditions(
                      name: "Больше -651",
                      condition: (text) {
                        final x = int.tryParse(text);
                        if (x == null) return false;
                        if (x <= -651) return false;
                        return true;
                      },
                    ),
                  ],
                ),
                ValidationTestField(
                  textEditingController: _coordinateYController,
                  label: "Y",
                  maxLength: 15,
                  validations: [
                    ValidationConditions(
                      name: "Целое число",
                      condition: (text) =>
                          int.tryParse(text) != null ? true : false,
                    ),
                    ValidationConditions(
                      name: "Не меньше -612",
                      condition: (text) {
                        final y = int.tryParse(text);
                        if (y == null) return false;
                        if (y <= -612) return false;
                        return true;
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Оператор", style: TextStyle(fontSize: 30)),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: isOperator,
                  onChanged: (value) => setState(() {
                    isOperator = value!;
                    _isFormValid = validateAndCreateDraft() != null;
                  }),
                ),
                Text('Добавить оператора'),
              ],
            ),
            if (isOperator)
              Column(
                children: [const SizedBox(height: 10), createPerson(false)],
              ),

            const SizedBox(height: 20),
            const Text("Режиссёр", style: TextStyle(fontSize: 30)),
            const SizedBox(height: 10),
            createPerson(true),

            const SizedBox(height: 15),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(400, 65),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Вернуться назад'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(400, 65),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: state.isLoading
                      ? null
                      : (_isFormValid ? _onSavePressed : null),
                  child: state.isLoading
                      ? CircularProgressIndicator()
                      : Text('Сохранить'),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  MovieDraft? validateAndCreateDraft() {
    // ======== Movie-level проверки ========
    // Название фильма
    final name = _movieNameController.text;
    if (name.isEmpty) return null;

    // Координаты фильма
    final coordinateX = int.tryParse(_coordinateXController.text);
    final coordinateY = double.tryParse(_coordinateYController.text);
    if (coordinateX == null || coordinateY == null) return null;
    if (coordinateX <= -651) return null;
    if (coordinateY <= -612) return null;

    // Оскары
    final oscarsCount = int.tryParse(_oscarCountController.text);
    if (oscarsCount == null || oscarsCount <= 0) return null;

    // Кассовые сборы
    double? totalBoxOffice;
    if (_totalBoxOfficeController.text.isNotEmpty) {
      totalBoxOffice = double.tryParse(_totalBoxOfficeController.text);
      if (totalBoxOffice == null || totalBoxOffice <= 0) return null;
    }

    // Длина фильма
    final length = int.tryParse(_oscarCountController.text);
    if (length == null || length <= 0) return null;

    final genre = _selectedGenre;

    Person? validatePerson({
      required TextEditingController nameController,
      required TextEditingController passportController,
      required EyeColor? eyeColor,
      required HairColor hairColor,
      required Country? nationality,
      required TextEditingController xController,
      required TextEditingController yController,
      required TextEditingController zController,
    }) {
      final personName = nameController.text;
      if (personName.isEmpty) return null;
      final passportID = passportController.text;
      if (passportID.isEmpty || passportID.length < 8) return null;
      final locationX = double.tryParse(xController.text);
      final locationY = int.tryParse(yController.text);
      final locationZ = int.tryParse(zController.text);
      if (locationX == null) return null;
      if (locationY == null) return null;
      if (locationZ == null) return null;
      return Person(
        name: personName,
        passportID: passportID,
        eyeColor: eyeColor,
        hairColor: hairColor,
        nationality: nationality,
        location: Location(x: locationX, y: locationY, z: locationZ),
      );
    }

    final director = validatePerson(
      nameController: _directorNameController,
      passportController: _directorPassportIDController,
      eyeColor: _selectedDirectorEyeColor,
      hairColor: _selectedDirectorHairColor,
      nationality: _selectedDirectorNationality,
      xController: _directorXController,
      yController: _directorYController,
      zController: _directorZController,
    );
    if (director == null) return null;

    Person? operatorPerson;
    if (isOperator) {
      operatorPerson = validatePerson(
        nameController: _operatorNameController,
        passportController: _operatorPassportIDController,
        eyeColor: _selectedOperatorEyeColor,
        hairColor: _selectedOperstorHairColor,
        nationality: _selectedOperatorNationality,
        xController: _operatorXController,
        yController: _operatorYController,
        zController: _operatorZController,
      );
      if (operatorPerson == null) return null;
    }

    // Собрать объект
    return MovieDraft(
      name: name,
      coordinates: Coordinates(x: coordinateX, y: coordinateY),
      oscarsCount: oscarsCount,
      totalBoxOffice: totalBoxOffice,
      length: length,
      director: director,
      genre: genre,
      operator: operatorPerson,
    );
  }

  @override
  void dispose() {
    List<TextEditingController> allControllers = [
      _movieNameController,
      _oscarCountController,
      _coordinateXController,
      _coordinateYController,
      _totalBoxOfficeController,
      _operatorNameController,
      _operatorPassportIDController,
      _operatorXController,
      _operatorYController,
      _operatorZController,
      _directorNameController,
      _directorPassportIDController,
      _directorXController,
      _directorYController,
      _directorZController,
      _lengthController,
    ];
    for (var c in allControllers) {
      c.removeListener(_updateFormValid);
    }
    super.dispose();
  }
}
