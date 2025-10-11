import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soaweb/features/movies/data/models/movie_dto.dart';
import 'package:soaweb/features/movies/data/models/movie_enums.dart';
import 'package:soaweb/features/movies/data/models/search_models.dart';
import 'package:soaweb/features/movies/presentation/extensions/enums_ui_extensions.dart';
import 'package:soaweb/features/movies/presentation/providers/movie_providers.dart';
import 'package:soaweb/features/movies/presentation/screens/movie_details_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _oscarsMinController = TextEditingController();
  final _oscarsMaxController = TextEditingController();
  final _lengthMinController = TextEditingController();
  final _lengthMaxController = TextEditingController();
  final _boxOfficeMinController = TextEditingController();
  final _boxOfficeMaxController = TextEditingController();
  final _coordinatesXMinController = TextEditingController();
  final _coordinatesXMaxController = TextEditingController();
  final _coordinatesYMinController = TextEditingController();
  final _coordinatesYMaxController = TextEditingController();
  final _operatorNameController = TextEditingController();

  MovieGenre? _selectedGenre;
  Country? _selectedOperatorNationality;
  String? _sortBy;
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  final List<String> _sortOptions = [
    'id',
    'name',
    'creationDate',
    'oscarsCount',
    'totalBoxOffice',
    'length',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _oscarsMinController.dispose();
    _oscarsMaxController.dispose();
    _lengthMinController.dispose();
    _lengthMaxController.dispose();
    _boxOfficeMinController.dispose();
    _boxOfficeMaxController.dispose();
    _coordinatesXMinController.dispose();
    _coordinatesXMaxController.dispose();
    _coordinatesYMinController.dispose();
    _coordinatesYMaxController.dispose();
    _operatorNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск фильмов'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // Форма поиска
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Фильтры поиска',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      
                      // Основные фильтры
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Название фильма',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      DropdownButtonFormField<MovieGenre>(
                        initialValue: _selectedGenre,
                        decoration: const InputDecoration(
                          labelText: 'Жанр',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<MovieGenre>(
                            value: null,
                            child: Text('Любой жанр'),
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
                      
                      DropdownButtonFormField<String>(
                        initialValue: _sortBy,
                        decoration: const InputDecoration(
                          labelText: 'Сортировка',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('Без сортировки'),
                          ),
                          ..._sortOptions.map((option) => DropdownMenuItem<String>(
                            value: option,
                            child: Text(_getSortLabel(option)),
                          )),
                        ],
                        onChanged: (value) {
                          setState(() => _sortBy = value);
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Диапазоны значений
                      const Text('Диапазоны значений:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _oscarsMinController,
                              decoration: const InputDecoration(
                                labelText: 'Оскары (мин)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _oscarsMaxController,
                              decoration: const InputDecoration(
                                labelText: 'Оскары (макс)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _lengthMinController,
                              decoration: const InputDecoration(
                                labelText: 'Длительность (мин)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _lengthMaxController,
                              decoration: const InputDecoration(
                                labelText: 'Длительность (макс)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _boxOfficeMinController,
                              decoration: const InputDecoration(
                                labelText: 'Сборы (мин)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _boxOfficeMaxController,
                              decoration: const InputDecoration(
                                labelText: 'Сборы (макс)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Координаты
                      const Text('Координаты:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _coordinatesXMinController,
                              decoration: const InputDecoration(
                                labelText: 'X (мин)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isNotEmpty == true) {
                                  final x = int.tryParse(value!);
                                  if (x == null) return 'Введите корректное число';
                                  if (x < -650) return 'X должен быть >= -650';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _coordinatesXMaxController,
                              decoration: const InputDecoration(
                                labelText: 'X (макс)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isNotEmpty == true) {
                                  final x = int.tryParse(value!);
                                  if (x == null) return 'Введите корректное число';
                                  if (x < -650) return 'X должен быть >= -650';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _coordinatesYMinController,
                              decoration: const InputDecoration(
                                labelText: 'Y (мин)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isNotEmpty == true) {
                                  final y = double.tryParse(value!);
                                  if (y == null) return 'Введите корректное число';
                                  if (y < -612) return 'Y должен быть >= -612';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _coordinatesYMaxController,
                              decoration: const InputDecoration(
                                labelText: 'Y (макс)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isNotEmpty == true) {
                                  final y = double.tryParse(value!);
                                  if (y == null) return 'Введите корректное число';
                                  if (y < -612) return 'Y должен быть >= -612';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Оператор
                      const Text('Оператор:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      
                      TextFormField(
                        controller: _operatorNameController,
                        decoration: const InputDecoration(
                          labelText: 'Имя оператора',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      DropdownButtonFormField<Country>(
                        initialValue: _selectedOperatorNationality,
                        decoration: const InputDecoration(
                          labelText: 'Национальность оператора',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<Country>(
                            value: null,
                            child: Text('Любая национальность'),
                          ),
                          ...Country.values.map((country) => DropdownMenuItem<Country>(
                            value: country,
                            child: Text(country.uiString),
                          )),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedOperatorNationality = value);
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _performSearch,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Поиск'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Результаты поиска
            if (_hasSearched) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Результаты поиска',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            'Найдено: ${_searchResults.length}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_searchResults.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text(
                              'Фильмы не найдены',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final movie = _searchResults[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
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
                    ],
                  ),
                ),
              ),
            ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getSortLabel(String option) {
    switch (option) {
      case 'id':
        return 'ID';
      case 'name':
        return 'Название';
      case 'creationDate':
        return 'Дата создания';
      case 'oscarsCount':
        return 'Количество Оскаров';
      case 'totalBoxOffice':
        return 'Общие сборы';
      case 'length':
        return 'Длительность';
      default:
        return option;
    }
  }

  Future<void> _performSearch() async {
    setState(() => _isLoading = true);
    
    try {
      final movieCollectionService = ref.read(movieCollectionServiceProvider);
      
      final searchRequest = MovieSearchRequest(
        sort: _sortBy,
        name: _nameController.text.isNotEmpty ? _nameController.text : null,
        genre: _selectedGenre,
        oscarsCount: _buildOscarsCountFilter(),
        totalBoxOffice: _buildTotalBoxOfficeFilter(),
        length: _buildLengthFilter(),
        coordinates: _buildCoordinatesFilter(),
        operator: _buildOperatorFilter(),
      );
      
      final response = await movieCollectionService.getMoviesWithFilters(
        searchRequest: searchRequest,
        page: 1,
        size: 100, // Получаем больше результатов для поиска
      );
      
      if (mounted) {
        setState(() {
          _searchResults = response.content ?? [];
          _hasSearched = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка поиска: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  MovieOscarsCountFilter? _buildOscarsCountFilter() {
    final min = int.tryParse(_oscarsMinController.text);
    final max = int.tryParse(_oscarsMaxController.text);
    
    if (min != null || max != null) {
      return MovieOscarsCountFilter(min: min, max: max);
    }
    return null;
  }

  MovieTotalBoxOfficeFilter? _buildTotalBoxOfficeFilter() {
    final min = double.tryParse(_boxOfficeMinController.text);
    final max = double.tryParse(_boxOfficeMaxController.text);
    
    if (min != null || max != null) {
      return MovieTotalBoxOfficeFilter(min: min, max: max);
    }
    return null;
  }

  MovieLengthFilter? _buildLengthFilter() {
    final min = int.tryParse(_lengthMinController.text);
    final max = int.tryParse(_lengthMaxController.text);
    
    if (min != null || max != null) {
      return MovieLengthFilter(min: min, max: max);
    }
    return null;
  }

  MovieCoordinatesFilter? _buildCoordinatesFilter() {
    final xMin = int.tryParse(_coordinatesXMinController.text);
    final xMax = int.tryParse(_coordinatesXMaxController.text);
    final yMin = double.tryParse(_coordinatesYMinController.text);
    final yMax = double.tryParse(_coordinatesYMaxController.text);
    
    if (xMin != null || xMax != null || yMin != null || yMax != null) {
      return MovieCoordinatesFilter(
        x: (xMin != null || xMax != null) ? CoordinatesXRange(min: xMin, max: xMax) : null,
        y: (yMin != null || yMax != null) ? CoordinatesYRange(min: yMin, max: yMax) : null,
      );
    }
    return null;
  }

  MovieSearchRequestOperator? _buildOperatorFilter() {
    final name = _operatorNameController.text.isNotEmpty ? _operatorNameController.text : null;
    final nationality = _selectedOperatorNationality;
    
    if (name != null || nationality != null) {
      return MovieSearchRequestOperator(name: name, nationality: nationality);
    }
    return null;
  }
}
