import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soaweb/features/movies/data/models/movie_dto.dart';
import 'package:soaweb/features/movies/data/models/common_models.dart';
import 'package:soaweb/features/movies/presentation/screens/edit_movie_screen.dart';
import 'package:soaweb/features/movies/presentation/extensions/enums_ui_extensions.dart';

class MovieDetailsScreen extends ConsumerWidget {
  final Movie movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditMovieScreen(movie: movie),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // Основная информация
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Основная информация',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('ID', movie.id.toString()),
                    _buildInfoRow('Название', movie.name),
                    _buildInfoRow('Жанр', movie.genre?.uiString ?? 'Не указан'),
                    _buildInfoRow('Длительность', '${movie.length} мин'),
                    _buildInfoRow('Оскары', movie.oscarsCount?.toString() ?? 'Не указано'),
                    _buildInfoRow('Общие сборы', movie.totalBoxOffice?.toString() ?? 'Не указано'),
                    _buildInfoRow('Дата создания', _formatDate(movie.creationDate)),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Координаты
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Координаты',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('X', movie.coordinates.x.toString()),
                    _buildInfoRow('Y', movie.coordinates.y.toString()),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Режиссер
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Режиссер',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildPersonInfo(movie.director),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Оператор
            if (movie.operator != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Оператор',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildPersonInfo(movie.operator!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Действия
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement delete functionality
                      _showDeleteConfirmation(context, ref);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text('Удалить фильм'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditMovieScreen(movie: movie),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Редактировать'),
                  ),
                ),
              ],
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonInfo(Person person) {
    return Column(
      children: [
        _buildInfoRow('Имя', person.name),
        _buildInfoRow('Паспорт', person.passportID),
        _buildInfoRow('Цвет волос', person.hairColor.uiString),
        if (person.eyeColor != null)
          _buildInfoRow('Цвет глаз', person.eyeColor!.uiString),
        if (person.nationality != null)
          _buildInfoRow('Национальность', person.nationality!.uiString),
        const SizedBox(height: 8),
        const Text(
          'Местоположение:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            children: [
              _buildInfoRow('X', person.location.x.toString()),
              _buildInfoRow('Y', person.location.y.toString()),
              _buildInfoRow('Z', person.location.z.toString()),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
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
              // TODO: Implement delete functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Функция удаления будет добавлена')),
              );
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
