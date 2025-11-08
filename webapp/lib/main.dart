import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webapp/features/movies/data/mappers/movie_mapper.dart';
import 'package:webapp/features/movies/data/mocks/mock_data.dart';
import 'package:webapp/features/movies/presentation/widgets/movie_bubble.dart';

import 'features/movies/presentation/screens/create_movie_screen.dart';
import 'features/movies/presentation/widgets/movie_list.dart';
import 'features/movies/presentation/widgets/movie_list_with_filters.dart';

void main() {
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  final _controller = TextEditingController();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(),
      home: MoviesListScreen(),
      // Scaffold(
      //   body: Center(
      //     // child: CreateMovieScreen(),
      //     child: MovieList(
      //       movies: MovieMapper.toEntityList(MockData().movies),
      //       onRemove: (id) => {},
      //     ),
      //   ),
      // ),
      // home: const MovieListScreen(),
    );
  }
}
