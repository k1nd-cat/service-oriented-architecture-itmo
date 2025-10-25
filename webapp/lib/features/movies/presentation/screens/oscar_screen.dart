import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webapp/features/movies/presentation/extensions/enums_ui_extensions.dart';

import '../../domain/entities/movie_enums.dart';
import '../providers/oscar_provider.dart';

class OscarScreen extends ConsumerStatefulWidget {
  const OscarScreen({super.key});

  @override
  ConsumerState<OscarScreen> createState() => _OscarScreenState();
}

class _OscarScreenState extends ConsumerState<OscarScreen> {
  MovieGenre? _selectedGenre;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(oscarScreenControllerProvider);
    final controller = ref.read(oscarScreenControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Управление Оскарами')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Лузеры', style: Theme.of(context).textTheme.headlineMedium),
            state.loosers.when(
              data: (loosers) => Column(
                children: loosers
                    .map((l) => ListTile(
                  title: Text(l.name),
                  subtitle: Text('ID: ${l.passportID}'),
                  trailing: Text('${l.filmsCount} фильмов'),
                ))
                    .toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, s) => Text('Ошибка загрузки лузеров: $e'),
            ),
            const Divider(height: 32),
            Text('Унизить по жанру', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            DropdownButtonFormField<MovieGenre>(
              value: _selectedGenre,
              decoration: const InputDecoration(labelText: 'Выберите жанр'),
              items: MovieGenre.values
                  .map((g) => DropdownMenuItem(
                value: g,
                child: Text(g.uiString),
              ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedGenre = val),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectedGenre == null
                  ? null
                  : () => controller.humiliate(_selectedGenre!),
              child: const Text('Унизить'),
            ),
            const SizedBox(height: 16),
            // Результат унижения
            state.humiliationResult.when(
              data: (result) {
                if (result == null) return const SizedBox.shrink();
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Результат:'),
                        Text('Затронуто режиссеров: ${result.affectedDirectors}'),
                        Text('Затронуто фильмов: ${result.affectedMovies}'),
                        Text('Удалено Оскаров: ${result.removedOscars}'),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, s) => Text('Ошибка: $e', style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}