import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/filters_request.dart';
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
  MovieGenre? _selectedGenre;
  String? _selectedSort;

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
    _selectedGenre = filters.genre;
    _selectedSort = filters.sort;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minOscarsController.dispose();
    _maxOscarsController.dispose();
    _minLengthController.dispose();
    _maxLengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Фильтры'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Сортировка
            DropdownButtonFormField<String>(
              value: _selectedSort,
              decoration: const InputDecoration(labelText: 'Сортировка'),
              items: const [
                DropdownMenuItem(value: null, child: Text('Без сортировки')),
                DropdownMenuItem(value: 'name', child: Text('По названию')),
                DropdownMenuItem(value: '-name', child: Text('По названию (убыв.)')),
                DropdownMenuItem(value: 'oscarsCount', child: Text('По Оскарам')),
                DropdownMenuItem(value: '-oscarsCount', child: Text('По Оскарам (убыв.)')),
              ],
              onChanged: (value) => setState(() => _selectedSort = value),
            ),
            const SizedBox(height: 16),

            // Название
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Название фильма',
                hintText: 'Введите название',
              ),
            ),
            const SizedBox(height: 16),

            // Жанр
            DropdownButtonFormField<MovieGenre>(
              value: _selectedGenre,
              decoration: const InputDecoration(labelText: 'Жанр'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Все жанры')),
                ...MovieGenre.values.map((genre) => DropdownMenuItem(
                  value: genre,
                  child: Text(genre.toString().split('.').last),
                )),
              ],
              onChanged: (value) => setState(() => _selectedGenre = value),
            ),
            const SizedBox(height: 16),

            // Оскары
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minOscarsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Оскары от',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxOscarsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Оскары до',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Длительность
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minLengthController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Длина от',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxLengthController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Длина до',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Сброс фильтров
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
            // Применение фильтров
            final filters = MoviesFilter(
              sort: _selectedSort,
              name: _nameController.text.isEmpty ? null : _nameController.text,
              genre: _selectedGenre,
              oscarsCount: IntFilter(
                min: int.tryParse(_minOscarsController.text),
                max: int.tryParse(_maxOscarsController.text),
              ),
              totalBoxOffice: const DoubleFilter(min: null, max: null),
              length: IntFilter(
                min: int.tryParse(_minLengthController.text),
                max: int.tryParse(_maxLengthController.text),
              ),
              coordinates: const CoordinatesFilter(
                x: IntFilter(min: null, max: null),
                y: DoubleFilter(min: null, max: null),
              ),
              operator: const PersonFilter(name: null, nationality: null),
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
}