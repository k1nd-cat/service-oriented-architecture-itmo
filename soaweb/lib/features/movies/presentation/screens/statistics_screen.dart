import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soaweb/features/movies/data/models/movie_enums.dart';
import 'package:soaweb/features/movies/data/models/search_models.dart';
import 'package:soaweb/features/movies/presentation/extensions/enums_ui_extensions.dart';
import 'package:soaweb/features/movies/presentation/providers/movie_providers.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  MovieGenre? _selectedGenre;
  int? _totalLength;
  List<LooserDirector> _looserDirectors = [];
  bool _isLoading = false;
  bool _hasSearchedLoosers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // Подсчет фильмов по жанру
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Подсчет фильмов по жанру',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        onPressed: _selectedGenre != null ? _countMoviesByGenre : null,
                        child: const Text('Подсчитать'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Общая длительность
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Общая длительность всех фильмов',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _calculateTotalLength,
                        child: const Text('Рассчитать'),
                      ),
                    ),
                    if (_totalLength != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              'Общая длительность: $_totalLength минут',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Режиссеры-неудачники
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Режиссеры-неудачники',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _getLooserDirectors,
                        child: const Text('Получить список'),
                      ),
                    ),
                    if (_looserDirectors.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      ...(_looserDirectors.map((director) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.person, color: Colors.red),
                          title: Text(director.name ?? 'Неизвестно'),
                          subtitle: Text('Паспорт: ${director.passportID ?? 'Не указан'}'),
                          trailing: Text(
                            'Фильмов: ${director.filmsCount ?? 0}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ))),
                    ] else if (_hasSearchedLoosers) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Отлично! Все режиссёры имеют хотя бы один фильм с Оскаром.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

  Future<void> _countMoviesByGenre() async {
    if (_selectedGenre == null) return;
    
    setState(() => _isLoading = true);
    
    try {
      final movieCollectionService = ref.read(movieCollectionServiceProvider);
      final response = await movieCollectionService.countMoviesByGenre(
        MovieCountByGenreRequest(genre: _selectedGenre!),
      );
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Результат подсчета'),
            content: Text(
              'Жанр: ${_selectedGenre!.uiString}\n'
              'Количество фильмов: ${response.count ?? 0}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _calculateTotalLength() async {
    setState(() => _isLoading = true);
    
    try {
      final movieCollectionService = ref.read(movieCollectionServiceProvider);
      final response = await movieCollectionService.calculateTotalLength();
      
      if (mounted) {
        setState(() => _totalLength = response.totalLength);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _getLooserDirectors() async {
    setState(() => _isLoading = true);
    
    try {
      final movieCollectionService = ref.read(movieCollectionServiceProvider);
      final directors = await movieCollectionService.getLooserDirectors();
      
      if (mounted) {
        setState(() {
          _looserDirectors = directors;
          _hasSearchedLoosers = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
