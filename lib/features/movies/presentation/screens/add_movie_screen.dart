import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soaweb/features/movies/data/models/common_models.dart';
import 'package:soaweb/features/movies/data/models/movie_dto.dart';
import 'package:soaweb/features/movies/data/models/movie_enums.dart';
import 'package:soaweb/features/movies/presentation/notifiers/movie_list_notifier.dart';
import 'package:soaweb/features/movies/presentation/widgets/dropdown_enum_menu.dart';
import 'package:soaweb/features/movies/presentation/extensions/enums_ui_extensions.dart';

class AddMovieScreen extends ConsumerStatefulWidget {
  const AddMovieScreen({super.key});

  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends ConsumerState<AddMovieScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _oscarsController = TextEditingController();
  final _lengthController = TextEditingController();
  final _totalBoxOfficeController = TextEditingController();
  
  // Координаты фильма
  final _coordinatesXController = TextEditingController();
  final _coordinatesYController = TextEditingController();
  
  // Режиссер
  final _directorNameController = TextEditingController();
  final _directorPassportController = TextEditingController();
  final _directorLocationXController = TextEditingController();
  final _directorLocationYController = TextEditingController();
  final _directorLocationZController = TextEditingController();
  
  // Оператор
  final _operatorNameController = TextEditingController();
  final _operatorPassportController = TextEditingController();
  final _operatorLocationXController = TextEditingController();
  final _operatorLocationYController = TextEditingController();
  final _operatorLocationZController = TextEditingController();

  // Выбранные значения
  MovieGenre? _selectedGenre;
  HairColor _selectedDirectorHairColor = HairColor.black;
  EyeColor? _selectedDirectorEyeColor;
  Country? _selectedDirectorNationality;
  
  HairColor _selectedOperatorHairColor = HairColor.black;
  EyeColor? _selectedOperatorEyeColor;
  Country? _selectedOperatorNationality;

  bool _hasOperator = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _oscarsController.dispose();
    _lengthController.dispose();
    _totalBoxOfficeController.dispose();
    _coordinatesXController.dispose();
    _coordinatesYController.dispose();
    _directorNameController.dispose();
    _directorPassportController.dispose();
    _directorLocationXController.dispose();
    _directorLocationYController.dispose();
    _directorLocationZController.dispose();
    _operatorNameController.dispose();
    _operatorPassportController.dispose();
    _operatorLocationXController.dispose();
    _operatorLocationYController.dispose();
    _operatorLocationZController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить фильм'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
              // Основная информация о фильме
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Основная информация', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Название фильма'),
                        validator: (value) => value?.isEmpty == true ? 'Введите название фильма' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _lengthController,
                              decoration: const InputDecoration(labelText: 'Длительность (мин)'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isEmpty == true) return 'Введите длительность';
                                final length = int.tryParse(value!);
                                if (length == null) return 'Введите корректное число';
                                if (length < 1) return 'Длительность должна быть >= 1';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _oscarsController,
                              decoration: const InputDecoration(labelText: 'Количество Оскаров'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isNotEmpty == true) {
                                  final oscars = int.tryParse(value!);
                                  if (oscars == null) return 'Введите корректное число';
                                  if (oscars < 1) return 'Количество Оскаров должно быть >= 1';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _totalBoxOfficeController,
                        decoration: const InputDecoration(labelText: 'Общие сборы'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isNotEmpty == true) {
                            final boxOffice = double.tryParse(value!);
                            if (boxOffice == null) return 'Введите корректное число';
                            if (boxOffice < 0) return 'Сборы должны быть >= 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownEnumMenu<MovieGenre>(
                        selected: _selectedGenre,
                        enumValues: MovieGenre.values,
                        onChanged: (value) => setState(() => _selectedGenre = value),
                        emptyLabel: 'Выберите жанр',
                        label: 'Жанр',
                        labelBuilder: (genre) => genre.uiString,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Координаты
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Координаты', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _coordinatesXController,
                              decoration: const InputDecoration(labelText: 'X'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isEmpty == true) return 'Введите X';
                                final x = int.tryParse(value!);
                                if (x == null) return 'Введите корректное число';
                                if (x < -650) return 'X должен быть >= -650';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _coordinatesYController,
                              decoration: const InputDecoration(labelText: 'Y'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isEmpty == true) return 'Введите Y';
                                final y = double.tryParse(value!);
                                if (y == null) return 'Введите корректное число';
                                if (y < -612) return 'Y должен быть >= -612';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Режиссер
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Режиссер', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _directorNameController,
                        decoration: const InputDecoration(labelText: 'Имя режиссера'),
                        validator: (value) => value?.isEmpty == true ? 'Введите имя режиссера' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _directorPassportController,
                        decoration: const InputDecoration(labelText: 'Паспорт режиссера'),
                        validator: (value) {
                          if (value?.isEmpty == true) return 'Введите паспорт режиссера';
                          if (value!.length < 8) return 'Паспорт должен содержать минимум 8 символов';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownEnumMenu<HairColor>(
                              selected: _selectedDirectorHairColor,
                              enumValues: HairColor.values,
                              onChanged: (value) => setState(() => _selectedDirectorHairColor = value!),
                              emptyLabel: 'Выберите цвет волос',
                              label: 'Цвет волос',
                              labelBuilder: (color) => color.uiString,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownEnumMenu<EyeColor>(
                              selected: _selectedDirectorEyeColor,
                              enumValues: EyeColor.values,
                              onChanged: (value) => setState(() => _selectedDirectorEyeColor = value),
                              emptyLabel: 'Выберите цвет глаз',
                              label: 'Цвет глаз',
                              labelBuilder: (color) => color.uiString,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownEnumMenu<Country>(
                        selected: _selectedDirectorNationality,
                        enumValues: Country.values,
                        onChanged: (value) => setState(() => _selectedDirectorNationality = value),
                        emptyLabel: 'Выберите национальность',
                        label: 'Национальность',
                        labelBuilder: (country) => country.uiString,
                      ),
                      const SizedBox(height: 16),
                      const Text('Местоположение режиссера', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _directorLocationXController,
                              decoration: const InputDecoration(labelText: 'X'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isEmpty == true) return 'Введите X';
                                if (double.tryParse(value!) == null) return 'Введите корректное число';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _directorLocationYController,
                              decoration: const InputDecoration(labelText: 'Y'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isEmpty == true) return 'Введите Y';
                                if (int.tryParse(value!) == null) return 'Введите корректное число';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _directorLocationZController,
                              decoration: const InputDecoration(labelText: 'Z'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isEmpty == true) return 'Введите Z';
                                if (int.tryParse(value!) == null) return 'Введите корректное число';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Оператор
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Оператор', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Switch(
                            value: _hasOperator,
                            onChanged: (value) => setState(() => _hasOperator = value),
                          ),
                          const Text('Есть оператор'),
                        ],
                      ),
                      if (_hasOperator) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _operatorNameController,
                          decoration: const InputDecoration(labelText: 'Имя оператора'),
                          validator: _hasOperator ? (value) => value?.isEmpty == true ? 'Введите имя оператора' : null : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _operatorPassportController,
                          decoration: const InputDecoration(labelText: 'Паспорт оператора'),
                          validator: _hasOperator ? (value) {
                            if (value?.isEmpty == true) return 'Введите паспорт оператора';
                            if (value!.length < 8) return 'Паспорт должен содержать минимум 8 символов';
                            return null;
                          } : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownEnumMenu<HairColor>(
                                selected: _selectedOperatorHairColor,
                                enumValues: HairColor.values,
                                onChanged: (value) => setState(() => _selectedOperatorHairColor = value!),
                                emptyLabel: 'Выберите цвет волос',
                                label: 'Цвет волос',
                                labelBuilder: (color) => color.uiString,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownEnumMenu<EyeColor>(
                                selected: _selectedOperatorEyeColor,
                                enumValues: EyeColor.values,
                                onChanged: (value) => setState(() => _selectedOperatorEyeColor = value),
                                emptyLabel: 'Выберите цвет глаз',
                                label: 'Цвет глаз',
                                labelBuilder: (color) => color.uiString,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DropdownEnumMenu<Country>(
                          selected: _selectedOperatorNationality,
                          enumValues: Country.values,
                          onChanged: (value) => setState(() => _selectedOperatorNationality = value),
                          emptyLabel: 'Выберите национальность',
                          label: 'Национальность',
                          labelBuilder: (country) => country.uiString,
                        ),
                        const SizedBox(height: 16),
                        const Text('Местоположение оператора', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _operatorLocationXController,
                                decoration: const InputDecoration(labelText: 'X'),
                                keyboardType: TextInputType.number,
                                validator: _hasOperator ? (value) {
                                  if (value?.isEmpty == true) return 'Введите X';
                                  if (double.tryParse(value!) == null) return 'Введите корректное число';
                                  return null;
                                } : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _operatorLocationYController,
                                decoration: const InputDecoration(labelText: 'Y'),
                                keyboardType: TextInputType.number,
                                validator: _hasOperator ? (value) {
                                  if (value?.isEmpty == true) return 'Введите Y';
                                  if (int.tryParse(value!) == null) return 'Введите корректное число';
                                  return null;
                                } : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _operatorLocationZController,
                                decoration: const InputDecoration(labelText: 'Z'),
                                keyboardType: TextInputType.number,
                                validator: _hasOperator ? (value) {
                                  if (value?.isEmpty == true) return 'Введите Z';
                                  if (int.tryParse(value!) == null) return 'Введите корректное число';
                                  return null;
                                } : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _isLoading = true);
                    
                    try {
                    final movieRequest = MovieRequest(
                      name: _nameController.text,
                        coordinates: Coordinates(
                          x: int.parse(_coordinatesXController.text),
                          y: double.parse(_coordinatesYController.text),
                        ),
                        oscarsCount: _oscarsController.text.isNotEmpty ? int.parse(_oscarsController.text) : null,
                        totalBoxOffice: _totalBoxOfficeController.text.isNotEmpty ? double.parse(_totalBoxOfficeController.text) : null,
                      length: int.parse(_lengthController.text),
                      director: Person(
                          name: _directorNameController.text,
                          passportID: _directorPassportController.text,
                          hairColor: _selectedDirectorHairColor,
                          eyeColor: _selectedDirectorEyeColor,
                          nationality: _selectedDirectorNationality,
                          location: Location(
                            x: double.parse(_directorLocationXController.text),
                            y: int.parse(_directorLocationYController.text),
                            z: int.parse(_directorLocationZController.text),
                          ),
                        ),
                        genre: _selectedGenre,
                        operator: _hasOperator ? Person(
                          name: _operatorNameController.text,
                          passportID: _operatorPassportController.text,
                          hairColor: _selectedOperatorHairColor,
                          eyeColor: _selectedOperatorEyeColor,
                          nationality: _selectedOperatorNationality,
                          location: Location(
                            x: double.parse(_operatorLocationXController.text),
                            y: int.parse(_operatorLocationYController.text),
                            z: int.parse(_operatorLocationZController.text),
                          ),
                        ) : null,
                      );
                      
                      await ref.read(movieListNotifierProvider.notifier).addMovie(movieRequest);
                      
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Фильм успешно добавлен')),
                        );
                    Navigator.of(context).pop();
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ошибка добавления: $e')),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() => _isLoading = false);
                      }
                    }
                  }
                },
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Добавить фильм'),
              ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
