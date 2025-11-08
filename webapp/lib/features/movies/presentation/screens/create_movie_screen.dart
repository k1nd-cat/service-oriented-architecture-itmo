import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';
import '../widgets/create_movie.dart';

class CreateMovieScreen extends StatelessWidget {
  final Movie? movie;

  const CreateMovieScreen({this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(movie == null ? 'Создать фильм' : 'Обновить фильм')),
      body: Center(child: CreateMovie(movie: movie)),
    );
  }
}
