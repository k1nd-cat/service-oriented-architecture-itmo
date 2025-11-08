import 'package:flutter/material.dart';
import 'package:webapp/features/movies/presentation/extensions/enums_ui_extensions.dart';

import '../../domain/entities/movie.dart';
import '../screens/create_movie_screen.dart';

class MovieBubble extends StatelessWidget {
  final Movie movie;
  final ValueChanged<Movie> onRemove;

  const MovieBubble({
    required this.movie,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black.withValues(alpha: 0.05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.name, style: TextStyle(fontSize: 25)),
                if (movie.totalBoxOffice != null)
                  Text('Сборы: ${movie.totalBoxOffice}₽'),
                Text('Оскары: ${movie.oscarsCount ?? 0}'),
                Text('Продолжительность: ${movie.length} минут'),
                if (movie.genre != null) Text('Жанр: ${movie.genre!.uiString}'),
                Text(
                  'Координаты: (${movie.coordinates.x}, ${movie.coordinates.y})',
                ),
                Text(
                  'Создан: ${movie.creationDate.day}.${movie.creationDate.month}.${movie.creationDate.year}, ${movie.creationDate.hour}:${movie.creationDate.minute}',
                ),
              ],
            ),
          ),
          SizedBox(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (movie.operator != null)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Оператор', style: TextStyle(fontSize: 23)),
                      Text('Имя: ${movie.operator!.name}'),
                      Text('Паспорт: ${movie.operator!.passportID}'),
                      if (movie.operator!.eyeColor != null)
                        Text('Цвет глаз: ${movie.operator!.eyeColor!.uiString}'),
                      Text('Цвет волос: ${movie.operator!.hairColor.uiString}'),
                      if (movie.operator!.nationality != null)
                        Text('Национальность: ${movie.operator!.nationality!.uiString}'),
                      Text(
                        'Местоположение: (${movie.operator!.location.x}, ${movie.operator!.location.y}, ${movie.operator!.location.z})',
                      ),
                    ],
                  ),
                if (movie.operator == null) Text('У фильма нет оператора'),
              ],
            ),
          ),
          SizedBox(
            width: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Оператор', style: TextStyle(fontSize: 23)),
                Text('Имя: ${movie.director.name}'),
                Text('Паспорт: ${movie.director.passportID}'),
                if (movie.director.eyeColor != null)
                  Text('Цвет глаз: ${movie.director.eyeColor!.uiString}'),
                Text('Цвет волос: ${movie.director.hairColor.uiString}'),
                if (movie.director.nationality != null)
                  Text('Национальность: ${movie.director.nationality!.uiString}'),
                Text(
                  'Местоположение: (${movie.director.location.x}, ${movie.director.location.y}, ${movie.director.location.z})',
                ),
              ],
            ),
          ),
          SizedBox(
            width: 50,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateMovieScreen(movie: movie),
                    ),
                  ),
                  icon: Icon(Icons.edit, color: Color.fromRGBO(56, 142, 60, 1)),
                ),
                IconButton(
                  onPressed: () => onRemove(movie),
                  icon: Icon(
                    Icons.delete,
                    color: Color.fromRGBO(211, 47, 47, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
