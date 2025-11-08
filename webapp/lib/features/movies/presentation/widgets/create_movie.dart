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

  // Movie controllers
  final _movieNameController = TextEditingController();
  final _oscarCountController = TextEditingController();
  final _coordinateXController = TextEditingController();
  final _coordinateYController = TextEditingController();
  final _totalBoxOfficeController = TextEditingController();
  final _lengthController = TextEditingController();
  MovieGenre _selectedGenre = MovieGenre.comedy;

  // Operator controllers
  bool isOperator = false;
  final _operatorNameController = TextEditingController();
  final _operatorPassportIDController = TextEditingController();
  EyeColor? _selectedOperatorEyeColor;
  var _selectedOperatorHairColor = HairColor.black;
  Country? _selectedOperatorNationality;
  final _operatorXController = TextEditingController();
  final _operatorYController = TextEditingController();
  final _operatorZController = TextEditingController();

  // Director controllers
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
        _selectedOperatorHairColor = movie.operator!.hairColor;
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
    if (!mounted) return;

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
        message: widget.movie == null
            ? 'Фильм успешно создан!'
            : 'Фильм успешно обновлен!',
        buttonText: 'Ок',
        action: () {
          Navigator.of(context).pop(true);
        },
      );
    }
  }

  void _updateFormValid() {
    setState(() {
      _isFormValid = validateAndCreateDraft() != null;
    });
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonCard(bool isDirector) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              isDirector ? 'Режиссёр' : 'Оператор',
              isDirector ? Icons.movie_creation : Icons.videocam,
            ),
            const SizedBox(height: 20),

            // Основная информация
            if (isSmallScreen)
              Column(
                children: [
                  ValidationTestField(
                    width: double.infinity,
                    textEditingController: isDirector
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
                  const SizedBox(height: 16),
                  ValidationTestField(
                    width: double.infinity,
                    textEditingController: isDirector
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
              )
            else
              Row(
                children: [
                  Expanded(
                    child: ValidationTestField(
                      textEditingController: isDirector
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
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ValidationTestField(
                      textEditingController: isDirector
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
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Внешность
            Text(
              'Внешность',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                ValidationDropdownField<EyeColor>(
                  width: isSmallScreen ? double.infinity : 200,
                  selectedValue: isDirector
                      ? _selectedDirectorEyeColor
                      : _selectedOperatorEyeColor,
                  enumValues: EyeColor.values,
                  label: 'Цвет глаз',
                  allowNull: true,
                  itemNameBuilder: (eyeColor) => eyeColor.uiString,
                  onChanged: (EyeColor? g) {
                    setState(() {
                      if (!isDirector) {
                        _selectedOperatorEyeColor = g;
                      } else {
                        _selectedDirectorEyeColor = g;
                      }
                    });
                  },
                ),
                ValidationDropdownField<HairColor>(
                  width: isSmallScreen ? double.infinity : 200,
                  selectedValue: isDirector
                      ? _selectedDirectorHairColor
                      : _selectedOperatorHairColor,
                  enumValues: HairColor.values,
                  label: 'Цвет волос', // Исправлено!
                  allowNull: false,
                  itemNameBuilder: (hairColor) => hairColor.uiString,
                  onChanged: (HairColor? g) {
                    setState(() {
                      if (!isDirector) {
                        _selectedOperatorHairColor = g!;
                      } else {
                        _selectedDirectorHairColor = g!;
                      }
                    });
                  },
                ),
                ValidationDropdownField<Country>(
                  width: isSmallScreen ? double.infinity : 200,
                  selectedValue: isDirector
                      ? _selectedDirectorNationality
                      : _selectedOperatorNationality,
                  enumValues: Country.values,
                  label: 'Национальность',
                  allowNull: true,
                  itemNameBuilder: (nationality) => nationality.uiString,
                  onChanged: (Country? g) {
                    setState(() {
                      if (!isDirector) {
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

            // Местоположение
            Text(
              'Местоположение',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                ValidationTestField(
                  width: isSmallScreen ? double.infinity : 150,
                  textEditingController: isDirector
                      ? _directorXController
                      : _operatorXController,
                  label: "X",
                  maxLength: 24,
                  validations: [
                    ValidationConditions(
                      name: "Вещественное число",
                      condition: (text) =>
                      double.tryParse(text) != null,
                    ),
                  ],
                ),
                ValidationTestField(
                  width: isSmallScreen ? double.infinity : 150,
                  textEditingController: isDirector
                      ? _directorYController
                      : _operatorYController,
                  label: "Y",
                  maxLength: 15,
                  validations: [
                    ValidationConditions(
                      name: "Целое число",
                      condition: (text) =>
                      int.tryParse(text) != null,
                    ),
                  ],
                ),
                ValidationTestField(
                  width: isSmallScreen ? double.infinity : 150,
                  textEditingController: isDirector
                      ? _directorZController
                      : _operatorZController,
                  label: "Z",
                  maxLength: 9,
                  validations: [
                    ValidationConditions(
                      name: "Целое число",
                      condition: (text) =>
                      int.tryParse(text) != null,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createMovieProvider);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Заголовок
              Card(
                elevation: 4,
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Icon(
                        widget.movie == null ? Icons.add_circle : Icons.edit,
                        size: 40,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movie == null ? 'Создание фильма' : 'Редактирование фильма',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.movie == null
                                  ? 'Заполните все поля для создания нового фильма'
                                  : 'Измените необходимые поля',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Основная информация о фильме
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Основная информация', Icons.movie),
                      const SizedBox(height: 20),

                      ValidationTestField(
                        width: double.infinity,
                        textEditingController: _movieNameController,
                        label: "Название фильма",
                        validations: [
                          ValidationConditions(
                            name: "Не может быть пустым",
                            condition: (text) => text.isNotEmpty,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      if (isSmallScreen)
                        Column(
                          children: [
                            ValidationTestField(
                              width: double.infinity,
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
                                    return oscarCount != null && oscarCount > 0;
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ValidationTestField(
                              width: double.infinity,
                              maxLength: 15,
                              textEditingController: _totalBoxOfficeController,
                              label: "Кассовые сборы",
                              validations: [
                                ValidationConditions(
                                  name: "Число",
                                  condition: (text) =>
                                  text.isEmpty || double.tryParse(text) != null,
                                ),
                                ValidationConditions(
                                  name: "Больше нуля",
                                  condition: (text) {
                                    if (text.isEmpty) return true;
                                    var value = double.tryParse(text);
                                    return value != null && value > 0;
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ValidationTestField(
                              width: double.infinity,
                              maxLength: 9,
                              textEditingController: _lengthController,
                              label: "Длина фильма (минуты)",
                              validations: [
                                ValidationConditions(
                                  name: "Целое число",
                                  condition: (text) => int.tryParse(text) != null,
                                ),
                                ValidationConditions(
                                  name: "Больше нуля",
                                  condition: (text) {
                                    var length = int.tryParse(text);
                                    return length != null && length > 0;
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ValidationDropdownField<MovieGenre>(
                              width: double.infinity,
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
                        )
                      else
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            ValidationTestField(
                              width: 220,
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
                                    return oscarCount != null && oscarCount > 0;
                                  },
                                ),
                              ],
                            ),
                            ValidationTestField(
                              maxLength: 15,
                              width: 220,
                              textEditingController: _totalBoxOfficeController,
                              label: "Кассовые сборы",
                              validations: [
                                ValidationConditions(
                                  name: "Число",
                                  condition: (text) =>
                                  text.isEmpty || double.tryParse(text) != null,
                                ),
                                ValidationConditions(
                                  name: "Больше нуля",
                                  condition: (text) {
                                    if (text.isEmpty) return true;
                                    var value = double.tryParse(text);
                                    return value != null && value > 0;
                                  },
                                ),
                              ],
                            ),
                            ValidationTestField(
                              width: 220,
                              maxLength: 9,
                              textEditingController: _lengthController,
                              label: "Длина фильма (минуты)",
                              validations: [
                                ValidationConditions(
                                  name: "Целое число",
                                  condition: (text) => int.tryParse(text) != null,
                                ),
                                ValidationConditions(
                                  name: "Больше нуля",
                                  condition: (text) {
                                    var length = int.tryParse(text);
                                    return length != null && length > 0;
                                  },
                                ),
                              ],
                            ),
                            ValidationDropdownField<MovieGenre>(
                              width: 220,
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

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      Text(
                        'Координаты фильма',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: ValidationTestField(
                              textEditingController: _coordinateXController,
                              label: "X",
                              maxLength: 9,
                              validations: [
                                ValidationConditions(
                                  name: "Целое число",
                                  condition: (text) =>
                                  int.tryParse(text) != null,
                                ),
                                ValidationConditions(
                                  name: "Больше -651",
                                  condition: (text) {
                                    final x = int.tryParse(text);
                                    return x != null && x > -651;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ValidationTestField(
                              textEditingController: _coordinateYController,
                              label: "Y",
                              maxLength: 15,
                              validations: [
                                ValidationConditions(
                                  name: "Вещественное число",
                                  condition: (text) =>
                                  double.tryParse(text) != null,
                                ),
                                ValidationConditions(
                                  name: "Больше -612",
                                  condition: (text) {
                                    final y = double.tryParse(text);
                                    return y != null && y > -612;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Оператор
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isOperator,
                            onChanged: (value) => setState(() {
                              isOperator = value!;
                              _isFormValid = validateAndCreateDraft() != null;
                            }),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Добавить оператора',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(необязательно)',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      if (isOperator) ...[
                        const SizedBox(height: 20),
                        _buildPersonCard(false),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Режиссёр
              _buildPersonCard(true),

              const SizedBox(height: 32),

              // Кнопки действий
              if (isSmallScreen)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: state.isLoading
                          ? null
                          : (_isFormValid ? _onSavePressed : null),
                      icon: state.isLoading
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      )
                          : Icon(widget.movie == null ? Icons.save : Icons.update),
                      label: Text(
                        state.isLoading
                            ? 'Сохранение...'
                            : (widget.movie == null ? 'Создать фильм' : 'Сохранить изменения'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: state.isLoading ? null : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text(
                        'Вернуться назад',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: state.isLoading ? null : () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text(
                          'Вернуться назад',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: state.isLoading
                            ? null
                            : (_isFormValid ? _onSavePressed : null),
                        icon: state.isLoading
                            ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        )
                            : Icon(widget.movie == null ? Icons.save : Icons.update),
                        label: Text(
                          state.isLoading
                              ? 'Сохранение...'
                              : (widget.movie == null ? 'Создать фильм' : 'Сохранить изменения'),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 20),
            ],
          ),
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

    // Длина фильма - ИСПРАВЛЕНО!
    final length = int.tryParse(_lengthController.text);
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
        hairColor: _selectedOperatorHairColor,
        nationality: _selectedOperatorNationality,
        xController: _operatorXController,
        yController: _operatorYController,
        zController: _operatorZController,
      );
      if (operatorPerson == null) return null;
    }

    // Собрать объект
    return MovieDraft(
      id: widget.movie?.id,
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