import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soaweb/features/movies/data/models/movie_enums.dart';
import 'package:soaweb/features/movies/data/models/search_models.dart';
import 'package:soaweb/features/movies/presentation/extensions/enums_ui_extensions.dart';
import 'package:soaweb/features/movies/presentation/providers/movie_providers.dart';

class OscarManagementScreen extends ConsumerStatefulWidget {
  const OscarManagementScreen({super.key});

  @override
  _OscarManagementScreenState createState() => _OscarManagementScreenState();
}

class _OscarManagementScreenState extends ConsumerState<OscarManagementScreen> {
  MovieGenre? _selectedGenre;
  OscarHumiliationResponse? _lastHumiliationResult;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление Оскарами'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // Отобрать Оскары у режиссеров по жанру
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Отобрать Оскары у режиссеров по жанру',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Эта операция отберет Оскары у всех режиссеров фильмов указанного жанра',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<MovieGenre>(
                      initialValue: _selectedGenre,
                      decoration: const InputDecoration(
                        labelText: 'Выберите жанр',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<MovieGenre>(
                          value: null,
                          child: Text('Выберите жанр'),
                        ),
                        ...MovieGenre.values.map((genre) => DropdownMenuItem<MovieGenre>(
                          value: genre,
                          child: Text(genre.uiString),
                        )),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedGenre = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectedGenre != null ? _humiliateDirectorsByGenre : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Отобрать Оскары'),
                      ),
                    ),
                    if (_lastHumiliationResult != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Результат операции:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text('Затронуто режиссеров: ${_lastHumiliationResult!.affectedDirectors ?? 0}'),
                            Text('Затронуто фильмов: ${_lastHumiliationResult!.affectedMovies ?? 0}'),
                            Text('Удалено Оскаров: ${_lastHumiliationResult!.removedOscars ?? 0}'),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Информация
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Информация',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Операция отбора Оскаров необратима\n'
                      '• Будет затронут жанр: ${_selectedGenre?.uiString ?? 'не выбран'}\n'
                      '• У всех режиссеров фильмов этого жанра будет установлено количество Оскаров в null',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            
            if (_isLoading) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _humiliateDirectorsByGenre() async {
    if (_selectedGenre == null) return;
    
    // Показать диалог подтверждения
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение'),
        content: Text(
          'Вы уверены, что хотите отобрать Оскары у всех режиссеров фильмов жанра "${_selectedGenre!.uiString}"?\n\n'
          'Эта операция необратима!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Отобрать Оскары'),
          ),
        ],
      ),
    );
    
    if (confirmed != true) return;
    
    setState(() => _isLoading = true);
    
    try {
      final movieCollectionService = ref.read(movieCollectionServiceProvider);
      final response = await movieCollectionService.humiliateDirectorsByGenre(_selectedGenre!);
      
      if (mounted) {
        setState(() => _lastHumiliationResult = response);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Операция завершена. Удалено Оскаров: ${response.removedOscars ?? 0}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
