import 'package:flutter/cupertino.dart';

import '../../domain/entities/movie.dart';
import 'movie_bubble.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final ValueChanged<int> onRemove;

  const MovieList({super.key, required this.movies, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 900,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: MovieBubble(
              movie: movie,
              onRemove: (removedMovie) => onRemove(removedMovie.id),
            ),
          );
        },
      ),
    );
  }
}
