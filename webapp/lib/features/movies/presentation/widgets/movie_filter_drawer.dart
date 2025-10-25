import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webapp/features/movies/presentation/extensions/enums_ui_extensions.dart';

import '../../data/models/filters_request.dart';
import '../../domain/entities/movie_enums.dart';
import '../providers/movie_list_provider.dart';

class MovieFilterDrawer extends ConsumerWidget {
  const MovieFilterDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(moviesFilterStateProvider);
    final filterNotifier = ref.read(moviesFilterStateProvider.notifier);

    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Фильтры'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Общие'),
              _buildNameField(currentFilter.name, (name) {
                filterNotifier.updateFilter(currentFilter.copyWith(name: name));
              }),
              _buildSortDropdown(currentFilter.sort, (sort) {
                filterNotifier.updateFilter(currentFilter.copyWith(sort: sort));
              }),
              _buildGenreDropdown(currentFilter.genre, (genre) {
                filterNotifier.updateFilter(currentFilter.copyWith(genre: genre));
              }),

              const Divider(height: 32),

              _buildSectionTitle(context, 'Числовые'),
              _buildIntFilter(
                label: 'Длина (мин)',
                current: currentFilter.length,
                onUpdate: (filter) => filterNotifier.updateFilter(
                  currentFilter.copyWith(length: filter),
                ),
              ),
              _buildIntFilter(
                label: 'Касса (\$)',
                current: currentFilter.totalBoxOffice,
                onUpdate: (filter) => filterNotifier.updateFilter(
                  currentFilter.copyWith(totalBoxOffice: filter),
                ),
              ),

              const Divider(height: 32),

              _buildSectionTitle(context, 'Координаты'),
              _buildIntFilter(
                label: 'X Координата',
                current: currentFilter.coordinates.x,
                onUpdate: (filter) => filterNotifier.updateFilter(
                  currentFilter.copyWith(
                    coordinates: currentFilter.coordinates.copyWith(x: filter),
                  ),
                ),
              ),
              _buildDoubleFilter(
                label: 'Y Координата',
                current: currentFilter.coordinates.y,
                onUpdate: (filter) => filterNotifier.updateFilter(
                  currentFilter.copyWith(
                    coordinates: currentFilter.coordinates.copyWith(y: filter),
                  ),
                ),
              ),

              const Divider(height: 32),

              _buildSectionTitle(context, 'Оператор'),
              _buildPersonFilter(
                current: currentFilter.operator,
                onUpdate: (filter) => filterNotifier.updateFilter(
                  currentFilter.copyWith(operator: filter),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: TextButton(
                  onPressed: () {
                    filterNotifier.updateFilter(
                      MoviesFilterState().build(),
                    );
                    Navigator.pop(context);
                    ref.invalidate(moviesListProvider);
                  },
                  child: const Text('Сбросить все фильтры'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildNameField(String? currentName, ValueChanged<String?> onChanged) {
    return StatefulBuilder(
      builder: (context, setState) {
        final controller = TextEditingController(text: currentName);
        controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Название (поиск)',
              ),
              onSubmitted: onChanged,
              onChanged: (value) {
                onChanged(value.isEmpty ? null : value);
              }
          ),
        );
      },
    );
  }

  Widget _buildSortDropdown(String? currentSort, ValueChanged<String?> onChanged) {
    final sortOptions = {
      'id': 'ID (по возрастанию)',
      '-id': 'ID (по убыванию)',
      'name': 'Название',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Сортировка'),
        value: currentSort,
        items: [
          const DropdownMenuItem(value: null, child: Text('Не выбрано')),
          ...sortOptions.entries.map((e) => DropdownMenuItem(
            value: e.key,
            child: Text(e.value),
          )),
        ],
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildGenreDropdown(MovieGenre? currentGenre, ValueChanged<MovieGenre?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<MovieGenre>(
        decoration: const InputDecoration(labelText: 'Жанр'),
        value: currentGenre,
        items: [
          const DropdownMenuItem(value: null, child: Text('Не выбрано')),
          ...MovieGenre.values.map((g) => DropdownMenuItem(
            value: g,
            child: Text(g.uiString),
          )),
        ],
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildIntFilter({
    required String label,
    required IntFilter current,
    required ValueChanged<IntFilter> onUpdate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        Row(
          children: [
            Expanded(
              child: _buildMinMaxField(
                label: 'От',
                value: current.min?.toString(),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  onUpdate(current.copyWith(min: int.tryParse(val ?? '')));
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMinMaxField(
                label: 'До',
                value: current.max?.toString(),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  onUpdate(current.copyWith(max: int.tryParse(val ?? '')));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDoubleFilter({
    required String label,
    required DoubleFilter current,
    required ValueChanged<DoubleFilter> onUpdate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        Row(
          children: [
            Expanded(
              child: _buildMinMaxField(
                label: 'От',
                value: current.min?.toString(),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (val) {
                  onUpdate(current.copyWith(min: double.tryParse(val ?? '')));
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMinMaxField(
                label: 'До',
                value: current.max?.toString(),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (val) {
                  onUpdate(current.copyWith(max: double.tryParse(val ?? '')));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonFilter({
    required PersonFilter current,
    required ValueChanged<PersonFilter> onUpdate,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        final nameController = TextEditingController(text: current.name);
        nameController.selection = TextSelection.fromPosition(TextPosition(offset: nameController.text.length));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Имя Оператора'),
              onSubmitted: (value) => onUpdate(
                current.copyWith(name: value.isEmpty ? null : value),
              ),
              onChanged: (value) => onUpdate(
                current.copyWith(name: value.isEmpty ? null : value),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Country>(
              decoration: const InputDecoration(labelText: 'Национальность'),
              value: current.nationality,
              items: [
                const DropdownMenuItem(value: null, child: Text('Не выбрано')),
                ...Country.values.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c.uiString),
                )),
              ],
              onChanged: (val) {
                onUpdate(current.copyWith(nationality: val));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMinMaxField({
    required String label,
    String? value,
    required TextInputType keyboardType,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }
}
