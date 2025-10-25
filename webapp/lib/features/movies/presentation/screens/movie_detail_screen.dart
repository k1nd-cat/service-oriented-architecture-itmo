import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webapp/features/movies/presentation/extensions/enums_ui_extensions.dart';

import '../../data/repositories/providers.dart';
import '../../domain/entities/person.dart';
import '../providers/movie_detail_provider.dart';
import '../providers/movie_list_provider.dart';
import 'movie_form_screen.dart';

class MovieDetailScreen extends ConsumerWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieDetailProvider(movieId));

    return Scaffold(
      appBar: AppBar(
        actions: [
          movieAsync.maybeWhen(
            data: (movie) => IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieFormScreen(movieToEdit: movie),
                  ),
                );
              },
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteMovie(context, ref, movieId),
          ),
        ],
      ),
      body: movieAsync.when(
        data: (movie) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.name, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text('Жанр: ${movie.genre?.uiString ?? '-'}'),
                Text('Оскары: ${movie.oscarsCount ?? 0}'),
                Text('Касса: ${movie.totalBoxOffice ?? 0}'),
                Text('Длина: ${movie.length} мин.'),
                Text('Дата создания: ${movie.creationDate.toIso8601String().substring(0, 10)}'),

                const Divider(height: 32),

                Text('Координаты', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('X: ${movie.coordinates.x}'),
                Text('Y: ${movie.coordinates.y.toStringAsFixed(2)}'),

                const Divider(height: 32),

                Text('Режиссер', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                _PersonDetails(person: movie.director),

                const Divider(height: 32),

                Text('Оператор', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                if (movie.operator != null)
                  _PersonDetails(person: movie.operator!)
                else
                  const Text('Оператор не указан'),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }

  void _deleteMovie(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить фильм?'),
        content: const Text('Это действие нельзя будет отменить.'),
        actions: [
          TextButton(
            child: const Text('Отмена'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.pop(context);
              final repo = ref.read(moviesRepositoryProvider);
              final result = await repo.deleteMovieById(id);
              if (result.isRight() && context.mounted) {
                Navigator.pop(context);
                ref.invalidate(moviesListProvider);
              } else if (result.isLeft() && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка удаления: ${result.fold((f) => f, (_) => '')}')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _PersonDetails extends StatelessWidget {
  final Person person;

  const _PersonDetails({required this.person});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(person.name, style: Theme.of(context).textTheme.titleMedium),
            Text('ID Паспорта: ${person.passportID}'),

            const SizedBox(height: 8),

            Text('Цвет волос: ${person.hairColor.uiString}'),
            Text('Цвет глаз: ${person.eyeColor?.uiString ?? '-'}'),

            Text('Национальность: ${person.nationality?.uiString ?? '-'}'),

            const Divider(),

            Text('Локация:', style: Theme.of(context).textTheme.titleSmall),
            Text('X: ${person.location.x.toStringAsFixed(2)}'),
            Text('Y: ${person.location.y}'),
            Text('Z: ${person.location.z}'),
          ],
        ),
      ),
    );
  }
}