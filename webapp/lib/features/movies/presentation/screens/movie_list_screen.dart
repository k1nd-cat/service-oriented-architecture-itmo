import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webapp/features/movies/presentation/extensions/enums_ui_extensions.dart';

import '../../../../shared/widgets/error_display.dart';
import '../../data/repositories/providers.dart';
import '../providers/movie_list_provider.dart';
import '../widgets/movie_filter_drawer.dart';
import 'movie_detail_screen.dart';
import 'movie_form_screen.dart';
import 'oscar_screen.dart';

class MovieListScreen extends ConsumerWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(moviesListProvider());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильмы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OscarScreen()),
              );
            },
          ),

          Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              }
          ),
        ],
      ),
      endDrawer: const MovieFilterDrawer(),
      body: moviesAsync.when(
        data: (paginatedResponse) {
          final movies = paginatedResponse.content;
          final currentPage = ref.watch(currentPageProvider);
          if (movies.isEmpty) {
            return const Center(child: Text('Фильмы не найдены.'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return ListTile(
                      title: Text(movie.name),
                      subtitle: Text('ID: ${movie.id} | Жанр: ${movie.genre?.uiString ?? '-'}'),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            color: Colors.red,
                            onPressed: () => _deleteMovie(context, ref, movie.id, movie.name),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _PaginationControls(
                currentPage: currentPage,
                totalPages: 5,
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorDisplay(
          error: error,
          stack: stack,
          onRetry: () {
            ref.invalidate(moviesListProvider);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const MovieFormScreen(),
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteMovie(BuildContext context, WidgetRef ref, int movieId, String movieName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Подтверждение удаления'),
        content: Text('Вы уверены, что хотите удалить фильм "$movieName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    ) ?? false;

    if (!confirmed) return;

    try {
      final moviesRepo = ref.read(moviesRepositoryProvider);

      final result = await moviesRepo.deleteMovieById(movieId);

      result.fold(
            (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка удаления: ${failure.message}')),
          );
        },
            (_) {
          ref.invalidate(moviesListProvider(size: CurrentPage.pageSize));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Фильм "$movieName" удален.')),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Непредвиденная ошибка: $e')),
      );
    }
  }
}

class _PaginationControls extends ConsumerWidget {
  final int currentPage;
  final int totalPages;

  const _PaginationControls({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(currentPageProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: currentPage > 1 ? controller.previousPage : null,
          ),

          const SizedBox(width: 16),

          Text(
            'Страница $currentPage из $totalPages',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(width: 16),

          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: currentPage < totalPages ? controller.nextPage : null,
          ),
        ],
      ),
    );
  }
}