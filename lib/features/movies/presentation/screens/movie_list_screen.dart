import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soaweb/features/movies/presentation/notifiers/movie_list_notifier.dart';
import 'package:soaweb/features/movies/presentation/screens/add_movie_screen.dart';
import 'package:soaweb/features/movies/presentation/screens/movie_details_screen.dart';
import 'package:soaweb/features/movies/presentation/screens/statistics_screen.dart';
import 'package:soaweb/features/movies/presentation/screens/oscar_management_screen.dart';
import 'package:soaweb/features/movies/presentation/screens/search_screen.dart';
import 'package:soaweb/features/movies/presentation/screens/edit_movie_screen.dart';
import 'package:soaweb/features/movies/presentation/extensions/enums_ui_extensions.dart';

class MovieListScreen extends ConsumerWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesState = ref.watch(movieListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Коллекция фильмов'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(movieListNotifierProvider.notifier).refreshMovies();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddMovieScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'statistics':
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const StatisticsScreen()),
                  );
                  break;
                case 'oscar_management':
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const OscarManagementScreen()),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'statistics',
                child: Row(
                  children: [
                    Icon(Icons.analytics),
                    SizedBox(width: 8),
                    Text('Статистика'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'oscar_management',
                child: Row(
                  children: [
                    Icon(Icons.emoji_events),
                    SizedBox(width: 8),
                    Text('Управление Оскарами'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: moviesState.when(
        data: (movies) => movies.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.movie, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Нет фильмов в коллекции',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Нажмите + чтобы добавить первый фильм',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          movie.name.isNotEmpty ? movie.name[0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        movie.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (movie.genre != null)
                            Text('Жанр: ${movie.genre!.uiString}'),
                          Text('Длительность: ${movie.length} мин'),
                          if (movie.oscarsCount != null)
                            Text('Оскары: ${movie.oscarsCount}'),
                          Text('Режиссер: ${movie.director.name}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditMovieScreen(movie: movie),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteConfirmation(context, ref, movie);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsScreen(movie: movie),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Ошибка загрузки фильмов',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('$error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(movieListNotifierProvider.notifier).refreshMovies();
                },
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddMovieScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, movie) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить фильм'),
        content: Text('Вы уверены, что хотите удалить фильм "${movie.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(movieListNotifierProvider.notifier).deleteMovie(movie.id);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
