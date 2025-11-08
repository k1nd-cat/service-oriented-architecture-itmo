import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webapp/features/movies/presentation/extensions/enums_ui_extensions.dart';

import '../../data/models/filters_request.dart';
import '../../data/models/sort_field.dart';
import '../../domain/entities/movie_enums.dart';
import '../providers/movie_list_provider.dart';

class FiltersDialog extends ConsumerStatefulWidget {
  const FiltersDialog({super.key});

  @override
  ConsumerState<FiltersDialog> createState() => _FiltersDialogState();
}

class _FiltersDialogState extends ConsumerState<FiltersDialog> {
  late TextEditingController _nameController;
  late TextEditingController _minOscarsController;
  late TextEditingController _maxOscarsController;
  late TextEditingController _minLengthController;
  late TextEditingController _maxLengthController;
  late TextEditingController _minBoxOfficeController;
  late TextEditingController _maxBoxOfficeController;
  late TextEditingController _minXController;
  late TextEditingController _maxXController;
  late TextEditingController _minYController;
  late TextEditingController _maxYController;
  late TextEditingController _operatorNameController;

  MovieGenre? _selectedGenre;
  Country? _operatorNationality;
  List<SortField> _selectedSorts = [];

  static const List<String> _availableSortFields = [
    'name',
    'creationDate',
    'oscarsCount',
    'totalBoxOffice',
    'length',
    'genre',
  ];

  static const Map<String, String> _sortFieldDisplayNames = {
    'name': 'Название',
    'creationDate': 'Дата создания',
    'oscarsCount': 'Количество Оскаров',
    'totalBoxOffice': 'Кассовые сборы',
    'length': 'Длительность',
    'genre': 'Жанр',
  };

  @override
  void initState() {
    super.initState();
    final filters = ref.read(moviesFilterProvider);

    _nameController = TextEditingController(text: filters.name);
    _minOscarsController = TextEditingController(
      text: filters.oscarsCount.min?.toString(),
    );
    _maxOscarsController = TextEditingController(
      text: filters.oscarsCount.max?.toString(),
    );
    _minLengthController = TextEditingController(
      text: filters.length.min?.toString(),
    );
    _maxLengthController = TextEditingController(
      text: filters.length.max?.toString(),
    );
    _minBoxOfficeController = TextEditingController(
      text: filters.totalBoxOffice.min?.toString(),
    );
    _maxBoxOfficeController = TextEditingController(
      text: filters.totalBoxOffice.max?.toString(),
    );
    _minXController = TextEditingController(
      text: filters.coordinates.x?.min?.toString(),
    );
    _maxXController = TextEditingController(
      text: filters.coordinates.x?.max?.toString(),
    );
    _minYController = TextEditingController(
      text: filters.coordinates.y?.min?.toString(),
    );
    _maxYController = TextEditingController(
      text: filters.coordinates.y?.max?.toString(),
    );
    _operatorNameController = TextEditingController(
      text: filters.operator.name,
    );

    _selectedGenre = filters.genre;
    _operatorNationality = filters.operator.nationality;

    _parseSortString(filters.sort);
  }

  void _parseSortString(String? sortString) {
    if (sortString == null || sortString.isEmpty) return;

    final sorts = sortString.split(';');
    _selectedSorts = sorts.map((sort) {
      final parts = sort.split(',');
      if (parts.length == 2) {
        return SortField(
          field: parts[0],
          direction: parts[1],
          displayName: _sortFieldDisplayNames[parts[0]] ?? parts[0],
        );
      }
      return null;
    }).whereType<SortField>().toList();
  }

  String _buildSortString() {
    if (_selectedSorts.isEmpty) return '';
    return _selectedSorts.map((s) => s.toSortString()).join(';');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minOscarsController.dispose();
    _maxOscarsController.dispose();
    _minLengthController.dispose();
    _maxLengthController.dispose();
    _minBoxOfficeController.dispose();
    _maxBoxOfficeController.dispose();
    _minXController.dispose();
    _maxXController.dispose();
    _minYController.dispose();
    _maxYController.dispose();
    _operatorNameController.dispose();
    super.dispose();
  }

  void _addSortField() {
    showDialog(
      context: context,
      builder: (context) => _SortFieldDialog(
        availableFields: _availableSortFields
            .where((field) => !_selectedSorts.any((s) => s.field == field))
            .toList(),
        onAdd: (field, direction) {
          setState(() {
            _selectedSorts.add(SortField(
              field: field,
              direction: direction,
              displayName: _sortFieldDisplayNames[field] ?? field,
            ));
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Фильтры'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSortSection(),
              const Divider(),
              const SizedBox(height: 16),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название фильма',
                  hintText: 'Введите название',
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<MovieGenre>(
                value: _selectedGenre,
                decoration: const InputDecoration(labelText: 'Жанр'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Все жанры')),
                  ...MovieGenre.values.map((genre) => DropdownMenuItem(
                    value: genre,
                    child: Text(genre.uiString),
                  )),
                ],
                onChanged: (value) => setState(() => _selectedGenre = value),
              ),
              const SizedBox(height: 16),

              _buildRangeSection('Количество Оскаров', _minOscarsController, _maxOscarsController),
              const SizedBox(height: 16),

              _buildRangeSection('Длительность (мин)', _minLengthController, _maxLengthController),
              const SizedBox(height: 16),

              _buildRangeSection('Кассовые сборы', _minBoxOfficeController, _maxBoxOfficeController, isDouble: true),
              const SizedBox(height: 16),

              Text('Координаты', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              _buildRangeSection('X', _minXController, _maxXController),
              const SizedBox(height: 8),
              _buildRangeSection('Y', _minYController, _maxYController, isDouble: true),
              const SizedBox(height: 16),

              Text('Оператор', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _operatorNameController,
                decoration: const InputDecoration(
                  labelText: 'Имя оператора',
                  hintText: 'Введите имя',
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Country>(
                value: _operatorNationality,
                decoration: const InputDecoration(labelText: 'Национальность'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Любая')),
                  ...Country.values.map((country) => DropdownMenuItem(
                    value: country,
                    child: Text(country.uiString),
                  )),
                ],
                onChanged: (value) => setState(() => _operatorNationality = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(moviesFilterProvider.notifier).state = const MoviesFilter(
              sort: null,
              name: null,
              genre: null,
              oscarsCount: IntFilter(min: null, max: null),
              totalBoxOffice: DoubleFilter(min: null, max: null),
              length: IntFilter(min: null, max: null),
              coordinates: CoordinatesFilter(
                x: IntFilter(min: null, max: null),
                y: DoubleFilter(min: null, max: null),
              ),
              operator: PersonFilter(name: null, nationality: null),
            );
            ref.read(moviesListProvider.notifier).refresh();
            Navigator.of(context).pop();
          },
          child: const Text('Сбросить'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            final sortString = _buildSortString();
            final filters = MoviesFilter(
              sort: sortString.isEmpty ? null : sortString,
              name: _nameController.text.isEmpty ? null : _nameController.text,
              genre: _selectedGenre,
              oscarsCount: IntFilter(
                min: int.tryParse(_minOscarsController.text),
                max: int.tryParse(_maxOscarsController.text),
              ),
              totalBoxOffice: DoubleFilter(
                min: double.tryParse(_minBoxOfficeController.text),
                max: double.tryParse(_maxBoxOfficeController.text),
              ),
              length: IntFilter(
                min: int.tryParse(_minLengthController.text),
                max: int.tryParse(_maxLengthController.text),
              ),
              coordinates: CoordinatesFilter(
                x: IntFilter(
                  min: int.tryParse(_minXController.text),
                  max: int.tryParse(_maxXController.text),
                ),
                y: DoubleFilter(
                  min: double.tryParse(_minYController.text),
                  max: double.tryParse(_maxYController.text),
                ),
              ),
              operator: PersonFilter(
                name: _operatorNameController.text.isEmpty ? null : _operatorNameController.text,
                nationality: _operatorNationality,
              ),
            );

            ref.read(moviesFilterProvider.notifier).state = filters;
            ref.read(moviesListProvider.notifier).refresh();
            Navigator.of(context).pop();
          },
          child: const Text('Применить'),
        ),
      ],
    );
  }

  Widget _buildSortSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Сортировка', style: Theme.of(context).textTheme.titleSmall),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _selectedSorts.length < _availableSortFields.length
                  ? _addSortField
                  : null,
              tooltip: 'Добавить сортировку',
            ),
          ],
        ),
        if (_selectedSorts.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Без сортировки', style: TextStyle(color: Colors.grey)),
          )
        else
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final item = _selectedSorts.removeAt(oldIndex);
                _selectedSorts.insert(newIndex, item);
              });
            },
            children: _selectedSorts.asMap().entries.map((entry) {
              final index = entry.key;
              final sort = entry.value;
              return ListTile(
                key: ValueKey(sort),
                dense: true,
                leading: const Icon(Icons.drag_handle),
                title: Text('${sort.displayName} (${sort.direction == 'asc' ? '↑' : '↓'})'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => setState(() => _selectedSorts.removeAt(index)),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildRangeSection(String label, TextEditingController minController, TextEditingController maxController, {bool isDouble = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: minController,
                keyboardType: TextInputType.numberWithOptions(decimal: isDouble),
                decoration: const InputDecoration(
                  labelText: 'От',
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: maxController,
                keyboardType: TextInputType.numberWithOptions(decimal: isDouble),
                decoration: const InputDecoration(
                  labelText: 'До',
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SortFieldDialog extends StatefulWidget {
  final List<String> availableFields;
  final Function(String field, String direction) onAdd;

  const _SortFieldDialog({
    required this.availableFields,
    required this.onAdd,
  });

  @override
  State<_SortFieldDialog> createState() => _SortFieldDialogState();
}

class _SortFieldDialogState extends State<_SortFieldDialog> {
  String? _selectedField;
  String _selectedDirection = 'asc';

  static const Map<String, String> _sortFieldDisplayNames = {
    'name': 'Название',
    'creationDate': 'Дата создания',
    'oscarsCount': 'Количество Оскаров',
    'totalBoxOffice': 'Кассовые сборы',
    'length': 'Длительность',
    'genre': 'Жанр',
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить сортировку'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedField,
            decoration: const InputDecoration(labelText: 'Поле'),
            items: widget.availableFields.map((field) => DropdownMenuItem(
              value: field,
              child: Text(_sortFieldDisplayNames[field] ?? field),
            )).toList(),
            onChanged: (value) => setState(() => _selectedField = value),
          ),
          const SizedBox(height: 16),
          Wrap(
            children: [
              const Text('Направление:'),
              const SizedBox(width: 16),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('По возрастанию'),
                  value: 'asc',
                  groupValue: _selectedDirection,
                  onChanged: (value) => setState(() => _selectedDirection = value!),
                  dense: true,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('По убыванию'),
                  value: 'desc',
                  groupValue: _selectedDirection,
                  onChanged: (value) => setState(() => _selectedDirection = value!),
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _selectedField != null
              ? () {
            widget.onAdd(_selectedField!, _selectedDirection);
            Navigator.of(context).pop();
          }
              : null,
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}