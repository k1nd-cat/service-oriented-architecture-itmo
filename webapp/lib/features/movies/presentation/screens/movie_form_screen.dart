import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webapp/features/movies/presentation/extensions/enums_ui_extensions.dart';

import '../../domain/entities/coordinates.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_draft.dart';
import '../../domain/entities/movie_enums.dart';
import '../../domain/entities/person.dart';
import '../providers/movie_detail_provider.dart';
import '../providers/movie_form_provider.dart';
import '../providers/movie_list_provider.dart';

class MovieFormScreen extends ConsumerStatefulWidget {
  final Movie? movieToEdit;
  const MovieFormScreen({super.key, this.movieToEdit});

  @override
  ConsumerState<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends ConsumerState<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _oscarCountController;
  late TextEditingController _totalBoxOfficeController;
  late TextEditingController _lengthController;
  MovieGenre? _selectedGenre;

  late TextEditingController _coordXController;
  late TextEditingController _coordYController;

  late TextEditingController _directorNameController;
  late TextEditingController _directorPassportController;
  EyeColor? _directorEyeColor;
  HairColor? _directorHairColor;
  Country? _directorNationality;
  late TextEditingController _directorLocXController;
  late TextEditingController _directorLocYController;
  late TextEditingController _directorLocZController;

  late TextEditingController _operatorNameController;
  late TextEditingController _operatorPassportController;
  EyeColor? _operatorEyeColor;
  HairColor? _operatorHairColor;
  Country? _operatorNationality;
  late TextEditingController _operatorLocXController;
  late TextEditingController _operatorLocYController;
  late TextEditingController _operatorLocZController;

  bool get isEditing => widget.movieToEdit != null;

  @override
  void initState() {
    super.initState();
    final movie = widget.movieToEdit;

    _nameController = TextEditingController(text: movie?.name);
    _oscarCountController = TextEditingController(text: movie?.oscarCount?.toString());
    _totalBoxOfficeController = TextEditingController(text: movie?.totalBoxOffice?.toString());
    _lengthController = TextEditingController(text: movie?.length.toString());
    _selectedGenre = movie?.genre;

    _coordXController = TextEditingController(text: movie?.coordinates.x.toString());
    _coordYController = TextEditingController(text: movie?.coordinates.y.toString());

    _directorNameController = TextEditingController(text: movie?.director.name);
    _directorPassportController = TextEditingController(text: movie?.director.passportID);
    _directorEyeColor = movie?.director.eyeColor;
    _directorHairColor = movie?.director.hairColor ?? HairColor.black; // Default
    _directorNationality = movie?.director.nationality;
    _directorLocXController = TextEditingController(text: movie?.director.location.x.toString());
    _directorLocYController = TextEditingController(text: movie?.director.location.y.toString());
    _directorLocZController = TextEditingController(text: movie?.director.location.z.toString());

    _operatorNameController = TextEditingController(text: movie?.operator?.name);
    _operatorPassportController = TextEditingController(text: movie?.operator?.passportID);
    _operatorEyeColor = movie?.operator?.eyeColor;
    _operatorHairColor = movie?.operator?.hairColor;
    _operatorNationality = movie?.operator?.nationality;
    _operatorLocXController = TextEditingController(text: movie?.operator?.location.x.toString());
    _operatorLocYController = TextEditingController(text: movie?.operator?.location.y.toString());
    _operatorLocZController = TextEditingController(text: movie?.operator?.location.z.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _oscarCountController.dispose();
    _totalBoxOfficeController.dispose();
    _lengthController.dispose();
    _coordXController.dispose();
    _coordYController.dispose();
    _directorNameController.dispose();
    _directorPassportController.dispose();
    _directorLocXController.dispose();
    _directorLocYController.dispose();
    _directorLocZController.dispose();
    _operatorNameController.dispose();
    _operatorPassportController.dispose();
    _operatorLocXController.dispose();
    _operatorLocYController.dispose();
    _operatorLocZController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final opName = _operatorNameController.text;
    final opPassport = _operatorPassportController.text;
    final opLocY = int.tryParse(_operatorLocYController.text);
    final opLocZ = int.tryParse(_operatorLocZController.text);

    Person? operator;
    if (opName.isNotEmpty && opPassport.isNotEmpty) {
      operator = Person(
        name: opName,
        passportID: opPassport,
        eyeColor: _operatorEyeColor,
        hairColor: _operatorHairColor!,
        nationality: _operatorNationality,
        location: Location(
          x: double.parse(_operatorLocXController.text),
          y: opLocY!,
          z: opLocZ!,
        ),
      );
    }

    final draft = MovieDraft(
      id: widget.movieToEdit?.id,
      name: _nameController.text,
      oscarCount: int.tryParse(_oscarCountController.text),
      totalBoxOffice: double.tryParse(_totalBoxOfficeController.text),
      length: int.parse(_lengthController.text),
      genre: _selectedGenre,
      coordinates: Coordinates(
        x: int.parse(_coordXController.text),
        y: double.parse(_coordYController.text),
      ),
      director: Person(
        name: _directorNameController.text,
        passportID: _directorPassportController.text,
        eyeColor: _directorEyeColor,
        hairColor: _directorHairColor!,
        nationality: _directorNationality,
        location: Location(
          x: double.parse(_directorLocXController.text),
          y: int.parse(_directorLocYController.text),
          z: int.parse(_directorLocZController.text),
        ),
      ),
      operator: operator,
    );

    final success = await ref
        .read(movieFormProvider.notifier)
        .submitMovie(draft: draft, movieId: widget.movieToEdit?.id);

    if (success && mounted) {
      ref.invalidate(moviesListProvider);
      ref.invalidate(movieDetailProvider(widget.movieToEdit!.id));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(movieFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать' : 'Создать фильм'),
        actions: [
          if (formState.isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _submit,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('О фильме', style: Theme.of(context).textTheme.titleLarge),
              _gap(),
              _buildTextFormField(
                controller: _nameController,
                label: 'Название',
                validator: _validateRequired,
              ),
              _gap(),
              _buildTextFormField(
                controller: _oscarCountController,
                label: 'Кол-во Оскаров ( > 0 )',
                keyboardType: TextInputType.number,
                validator: (val) => _validateInt(val, min: 1, nullable: true),
              ),
              _gap(),
              _buildTextFormField(
                controller: _totalBoxOfficeController,
                label: 'Кассовые сборы ( > 0 )',
                keyboardType: TextInputType.number,
                validator: (val) => _validateDouble(val, min: 0.001, nullable: true),
              ),
              _gap(),
              _buildTextFormField(
                controller: _lengthController,
                label: 'Длина ( > 0 )',
                keyboardType: TextInputType.number,
                validator: (val) => _validateInt(val, min: 1, nullable: false),
              ),
              _gap(),
              _buildDropdown<MovieGenre>(
                value: _selectedGenre,
                label: 'Жанр (необязательно)',
                items: MovieGenre.values,
                onChanged: (val) => setState(() => _selectedGenre = val),
                itemToString: (g) => g.uiString,
                isNullable: true,
              ),
              _gap(),

              Text('Координаты', style: Theme.of(context).textTheme.titleLarge),
              _gap(),
              _buildTextFormField(
                controller: _coordXController,
                label: 'X ( > -651 )',
                keyboardType: TextInputType.number,
                validator: (val) => _validateInt(val, min: -650, nullable: false),
              ),
              _gap(),
              _buildTextFormField(
                controller: _coordYController,
                label: 'Y ( > -613 )',
                keyboardType: TextInputType.number,
                validator: (val) => _validateDouble(val, min: -612.99, nullable: false),
              ),
              _gap(),

              Text('Режиссер (Обязательно)', style: Theme.of(context).textTheme.titleLarge),
              _buildPersonForm(
                isOperator: false,
                nameController: _directorNameController,
                passportController: _directorPassportController,
                eyeColor: _directorEyeColor,
                onEyeColorChanged: (val) => setState(() => _directorEyeColor = val),
                hairColor: _directorHairColor,
                onHairColorChanged: (val) => setState(() => _directorHairColor = val),
                nationality: _directorNationality,
                onNationalityChanged: (val) => setState(() => _directorNationality = val),
                locXController: _directorLocXController,
                locYController: _directorLocYController,
                locZController: _directorLocZController,
              ),
              _gap(),

              Text('Оператор (Необязательно)', style: Theme.of(context).textTheme.titleLarge),
              _buildPersonForm(
                isOperator: true,
                nameController: _operatorNameController,
                passportController: _operatorPassportController,
                eyeColor: _operatorEyeColor,
                onEyeColorChanged: (val) => setState(() => _operatorEyeColor = val),
                hairColor: _operatorHairColor,
                onHairColorChanged: (val) => setState(() => _operatorHairColor = val),
                nationality: _operatorNationality,
                onNationalityChanged: (val) => setState(() => _operatorNationality = val),
                locXController: _operatorLocXController,
                locYController: _operatorLocYController,
                locZController: _operatorLocZController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonForm({
    required bool isOperator,
    required TextEditingController nameController,
    required TextEditingController passportController,
    required EyeColor? eyeColor,
    required ValueChanged<EyeColor?> onEyeColorChanged,
    required HairColor? hairColor,
    required ValueChanged<HairColor?> onHairColorChanged,
    required Country? nationality,
    required ValueChanged<Country?> onNationalityChanged,
    required TextEditingController locXController,
    required TextEditingController locYController,
    required TextEditingController locZController,
  }) {

    bool isPersonPartiallyFilled() {
      return nameController.text.isNotEmpty || passportController.text.isNotEmpty;
    }

    return Column(
      children: [
        _gap(),
        _buildTextFormField(
          controller: nameController,
          label: 'Имя',
          validator: (val) => isOperator && !isPersonPartiallyFilled() ? null : _validateRequired(val),
        ),
        _gap(),
        _buildTextFormField(
          controller: passportController,
          label: 'Паспорт (мин. 8 символов)',
          validator: (val) {
            if (isOperator && !isPersonPartiallyFilled()) return null;
            final requiredError = _validateRequired(val);
            if (requiredError != null) return requiredError;
            if (val!.length < 8) return 'Минимум 8 символов';
            return null;
          },
        ),
        _gap(),
        _buildDropdown<EyeColor>(
          value: eyeColor,
          label: 'Цвет глаз (необязательно)',
          items: EyeColor.values,
          onChanged: onEyeColorChanged,
          itemToString: (c) => c.uiString,
          isNullable: true,
        ),
        _gap(),
        _buildDropdown<HairColor>(
          value: hairColor,
          label: 'Цвет волос',
          items: HairColor.values,
          onChanged: onHairColorChanged,
          itemToString: (c) => c.uiString,
          isNullable: false,
          validator: (val) {
            if (isOperator && !isPersonPartiallyFilled()) return null;
            if (val == null) return 'Обязательное поле';
            return null;
          },
        ),
        _gap(),
        _buildDropdown<Country>(
          value: nationality,
          label: 'Национальность (необязательно)',
          items: Country.values,
          onChanged: onNationalityChanged,
          itemToString: (c) => c.uiString,
          isNullable: true,
        ),
        _gap(),
        Text('Локация', style: Theme.of(context).textTheme.titleMedium),
        _gap(),
        _buildTextFormField(
            controller: locXController,
            label: 'Location X (double)',
            keyboardType: TextInputType.number,
            validator: (val) {
              if (isOperator && !isPersonPartiallyFilled()) return null;
              return _validateDouble(val, nullable: false);
            }
        ),
        _gap(),
        _buildTextFormField(
            controller: locYController,
            label: 'Location Y (int)',
            keyboardType: TextInputType.number,
            validator: (val) {
              if (isOperator && !isPersonPartiallyFilled()) return null;
              return _validateInt(val, nullable: false);
            }
        ),
        _gap(),
        _buildTextFormField(
            controller: locZController,
            label: 'Location Z (int)',
            keyboardType: TextInputType.number,
            validator: (val) {
              if (isOperator && !isPersonPartiallyFilled()) return null;
              return _validateInt(val, nullable: false);
            }
        ),
      ],
    );
  }

  TextFormField _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildDropdown<T extends Enum>({
    required T? value,
    required String label,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    required String Function(T) itemToString,
    bool isNullable = false,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
      ),
      items: [
        if (isNullable)
          const DropdownMenuItem(
            value: null,
            child: Text('Не выбрано'),
          ),
        ...items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(itemToString(item)),
        )),
      ],
      onChanged: onChanged,
      validator: validator ?? (val) {
        if (!isNullable && val == null) {
          return 'Обязательное поле';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _gap() => const SizedBox(height: 16);

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Обязательное поле';
    }
    return null;
  }

  String? _validateInt(String? value, {int? min, int? max, bool nullable = false}) {
    if (value == null || value.isEmpty) {
      return nullable ? null : 'Обязательное поле';
    }
    final intValue = int.tryParse(value);
    if (intValue == null) {
      return 'Должно быть целым числом';
    }
    if (min != null && intValue < min) {
      return 'Должно быть $min или больше';
    }
    if (max != null && intValue > max) {
      return 'Должно быть $max или меньше';
    }
    return null;
  }

  String? _validateDouble(String? value, {double? min, double? max, bool nullable = false}) {
    if (value == null || value.isEmpty) {
      return nullable ? null : 'Обязательное поле';
    }
    final doubleValue = double.tryParse(value);
    if (doubleValue == null) {
      return 'Должно быть числом';
    }
    if (min != null && doubleValue <= min) {
      return 'Должно быть больше $min';
    }
    if (max != null && doubleValue >= max) {
      return 'Должно быть меньше $max';
    }
    return null;
  }
}
