import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/movie.dart';
import '../providers/movie_list_provider.dart';
import 'filters_dialog.dart';
import 'movie_bubble.dart';

class MoviesListScreen extends ConsumerStatefulWidget {
  const MoviesListScreen({super.key});

  @override
  ConsumerState<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends ConsumerState<MoviesListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(moviesListProvider.notifier).loadMovies();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(moviesListProvider);
      if (state.hasMore && !state.isLoadingMore) {
        ref.read(moviesListProvider.notifier).loadMovies(loadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(moviesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильмы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(moviesListProvider.notifier).refresh(),
          ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(MoviesListState state) {
    if (state.isLoading && state.movies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ошибка: ${state.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(moviesListProvider.notifier).loadMovies(),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (state.movies.isEmpty) {
      return const Center(child: Text('Нет фильмов'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(moviesListProvider.notifier).refresh();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Страница ${state.currentPage} из ${state.totalPages} '
                      '(Всего: ${state.totalElements})',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: state.movies.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.movies.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final movie = state.movies[index];
                return Container(
                  width: 900,
                  padding: const EdgeInsets.all(15.0),
                  child: MovieBubble(
                    movie: movie,
                    onRemove: (removedMovie) {
                      _confirmDelete(context, removedMovie);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Movie movie) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Подтверждение удаления'),
        content: Text('Вы уверены, что хотите удалить фильм "${movie.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(moviesListProvider.notifier).deleteMovie(movie.id, context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _showFiltersDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const FiltersDialog(),
    );
  }
}