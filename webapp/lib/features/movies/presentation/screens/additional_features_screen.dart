import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/movie_enums.dart';
import '../providers/additional_features_provider.dart';
import '../extensions/enums_ui_extensions.dart';

class AdditionalFeaturesScreen extends ConsumerStatefulWidget {
  const AdditionalFeaturesScreen({super.key});

  @override
  ConsumerState<AdditionalFeaturesScreen> createState() =>
      _AdditionalFeaturesScreenState();
}

class _AdditionalFeaturesScreenState
    extends ConsumerState<AdditionalFeaturesScreen> {
  MovieGenre? _selectedGenreForHumiliate;
  MovieGenre? _selectedGenreForCount;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(additionalFeaturesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Дополнительные возможности'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              ref.read(additionalFeaturesProvider.notifier).clearResults();
              setState(() {
                _selectedGenreForHumiliate = null;
                _selectedGenreForCount = null;
              });
            },
            tooltip: 'Очистить результаты',
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Ошибка, если есть
                      if (state.errorMessage != null)
                        Card(
                          color: Theme.of(context).colorScheme.errorContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Ошибка: ${state.errorMessage}',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ),

                      // Секция "Проигравшие"
                      _buildSection(
                        title: '🏆 Получить проигравших',
                        description: 'Получить список режиссёров без Оскаров',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                ref
                                    .read(additionalFeaturesProvider.notifier)
                                    .getLoosers();
                              },
                              icon: const Icon(Icons.person_search),
                              label: const Text('Получить проигравших'),
                            ),
                            if (state.loosers != null) ...[
                              const SizedBox(height: 16),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Найдено проигравших: ${state.loosers!.length}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      const Divider(),
                                      ...state.loosers!.map(
                                        (looser) => ListTile(
                                          leading: CircleAvatar(
                                            child: Text('${looser.filmsCount}'),
                                          ),
                                          title: Text(looser.name),
                                          subtitle: Text(
                                            'Паспорт: ${looser.passportID}',
                                          ),
                                          trailing: Text(
                                            '${looser.filmsCount} фильм(ов)',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Секция "Унизить по жанру"
                      _buildSection(
                        title: '😈 Унизить по жанру',
                        description:
                            'Отобрать Оскары у фильмов определенного жанра',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<MovieGenre>(
                              value: _selectedGenreForHumiliate,
                              decoration: const InputDecoration(
                                labelText: 'Выберите жанр',
                                border: OutlineInputBorder(),
                              ),
                              items: MovieGenre.values
                                  .map(
                                    (genre) => DropdownMenuItem(
                                      value: genre,
                                      child: Text(genre.uiString),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(
                                  () => _selectedGenreForHumiliate = value,
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _selectedGenreForHumiliate != null
                                  ? () => _confirmHumiliate(context)
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline),
                              label: const Text('Унизить'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                            ),
                            if (state.humiliateResult != null) ...[
                              const SizedBox(height: 16),
                              Card(
                                color: Theme.of(
                                  context,
                                ).colorScheme.tertiaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '✅ Операция выполнена успешно!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onTertiaryContainer,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      _buildResultRow(
                                        'Затронуто режиссёров:',
                                        '${state.humiliateResult!.affectedDirectors}',
                                      ),
                                      _buildResultRow(
                                        'Затронуто фильмов:',
                                        '${state.humiliateResult!.affectedMovies}',
                                      ),
                                      _buildResultRow(
                                        'Отобрано Оскаров:',
                                        '${state.humiliateResult!.removedOscars}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      _buildSection(
                        title: '📊 Статистика',
                        description:
                            'Различные статистические данные о фильмах',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.timer),
                                title: const Text(
                                  'Общая длительность всех фильмов',
                                ),
                                subtitle: state.totalLength != null
                                    ? Text(
                                        '${state.totalLength} минут '
                                        '(${(state.totalLength! / 60).toStringAsFixed(1)} часов)',
                                      )
                                    : null,
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    ref
                                        .read(
                                          additionalFeaturesProvider.notifier,
                                        )
                                        .calculateTotalLength();
                                  },
                                  child: const Text('Рассчитать'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Количество фильмов по жанрам',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                              DropdownButtonFormField<
                                                MovieGenre
                                              >(
                                                value: _selectedGenreForCount,
                                                decoration:
                                                    const InputDecoration(
                                                      labelText: 'Жанр',
                                                      isDense: true,
                                                    ),
                                                items: MovieGenre.values
                                                    .map(
                                                      (genre) =>
                                                          DropdownMenuItem(
                                                            value: genre,
                                                            child: Text(
                                                              genre.uiString,
                                                            ),
                                                          ),
                                                    )
                                                    .toList(),
                                                onChanged: (value) {
                                                  setState(
                                                    () =>
                                                        _selectedGenreForCount =
                                                            value,
                                                  );
                                                },
                                              ),
                                        ),
                                        const SizedBox(width: 12),
                                        ElevatedButton(
                                          onPressed:
                                              _selectedGenreForCount != null
                                              ? () {
                                                  ref
                                                      .read(
                                                        additionalFeaturesProvider
                                                            .notifier,
                                                      )
                                                      .calculateMoviesCountByGenre(
                                                        _selectedGenreForCount!,
                                                      );
                                                }
                                              : null,
                                          child: const Text('Подсчитать'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        ref
                                            .read(
                                              additionalFeaturesProvider
                                                  .notifier,
                                            )
                                            .calculateAllGenreCounts();
                                      },
                                      icon: const Icon(Icons.analytics),
                                      label: const Text(
                                        'Подсчитать для всех жанров',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(
                                          double.infinity,
                                          40,
                                        ),
                                      ),
                                    ),
                                    if (state.genreCounts.isNotEmpty) ...[
                                      const SizedBox(height: 16),
                                      const Divider(),
                                      ...state.genreCounts.entries.map(
                                        (entry) => ListTile(
                                          dense: true,
                                          leading: CircleAvatar(
                                            radius: 16,
                                            child: Text('${entry.value}'),
                                          ),
                                          title: Text(entry.key.uiString),
                                          trailing: Text(
                                            '${entry.value} фильм(ов)',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  void _confirmHumiliate(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('⚠️ Подтверждение'),
        content: Text(
          'Вы уверены, что хотите отобрать все Оскары у фильмов '
          'жанра "${_selectedGenreForHumiliate!.uiString}"?\n\n'
          'Это действие может быть необратимым!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref
                  .read(additionalFeaturesProvider.notifier)
                  .humiliateByGenre(_selectedGenreForHumiliate!);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Унизить'),
          ),
        ],
      ),
    );
  }
}
