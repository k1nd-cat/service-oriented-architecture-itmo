import 'package:flutter/material.dart';
import 'package:webapp/features/movies/domain/entities/person.dart';
import 'package:webapp/features/movies/presentation/extensions/enums_ui_extensions.dart';
import '../../domain/entities/movie.dart';

class MovieBubble extends StatelessWidget {
  final Movie movie;
  final ValueChanged<Movie> onRemove;
  final VoidCallback? onEdit;

  const MovieBubble({
    required this.movie,
    required this.onRemove,
    this.onEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      elevation: 2,
      shadowColor: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок с кнопками действий
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          children: [
                            if (movie.genre != null)
                              Chip(
                                label: Text(movie.genre!.uiString),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                labelStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  fontSize: 12,
                                ),
                              ),
                            if (movie.oscarsCount != null && movie.oscarsCount! > 0)
                              Chip(
                                avatar: const Icon(Icons.emoji_events, size: 16, color: Colors.amber),
                                label: Text('${movie.oscarsCount} Оскар${_getOscarSuffix(movie.oscarsCount!)}'),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor: Colors.amber.withOpacity(0.2),
                                labelStyle: const TextStyle(fontSize: 12),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null)
                        IconButton(
                          onPressed: onEdit,
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          tooltip: 'Редактировать',
                        ),
                      IconButton(
                        onPressed: () => onRemove(movie),
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        tooltip: 'Удалить',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Основная информация
              if (isSmallScreen)
              // Мобильная версия - вертикальный layout
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoSection(context, 'Информация о фильме', _getMovieInfo()),
                    const SizedBox(height: 16),
                    _buildInfoSection(context, 'Режиссёр', _getDirectorInfo(movie.director)),
                    if (movie.operator != null) ...[
                      const SizedBox(height: 16),
                      _buildInfoSection(context, 'Оператор', _getDirectorInfo(movie.operator!)),
                    ],
                  ],
                )
              else
              // Десктопная версия - горизонтальный layout
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildInfoSection(context, 'Информация о фильме', _getMovieInfo()),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 2,
                      child: _buildInfoSection(context, 'Режиссёр', _getDirectorInfo(movie.director)),
                    ),
                    if (movie.operator != null) ...[
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 2,
                        child: _buildInfoSection(context, 'Оператор', _getDirectorInfo(movie.operator!)),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, List<_InfoItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                child: Icon(
                  item.icon,
                  size: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: '${item.label}: ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                      TextSpan(
                        text: item.value,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  List<_InfoItem> _getMovieInfo() {
    return [
      if (movie.totalBoxOffice != null)
        _InfoItem(Icons.attach_money, 'Сборы', '${movie.totalBoxOffice!.toStringAsFixed(2)}₽'),
      _InfoItem(Icons.timer, 'Длительность', '${movie.length} мин'),
      _InfoItem(Icons.location_on, 'Координаты', '(${movie.coordinates.x}, ${movie.coordinates.y})'),
      _InfoItem(
        Icons.calendar_today,
        'Дата создания',
        '${movie.creationDate.day.toString().padLeft(2, '0')}.'
            '${movie.creationDate.month.toString().padLeft(2, '0')}.'
            '${movie.creationDate.year} '
            '${movie.creationDate.hour.toString().padLeft(2, '0')}:'
            '${movie.creationDate.minute.toString().padLeft(2, '0')}',
      ),
    ];
  }

  List<_InfoItem> _getDirectorInfo(Person person) {
    return [
      _InfoItem(Icons.person, 'Имя', person.name),
      _InfoItem(Icons.badge, 'Паспорт', person.passportID),
      if (person.eyeColor != null)
        _InfoItem(Icons.remove_red_eye, 'Цвет глаз', person.eyeColor!.uiString),
      _InfoItem(Icons.face, 'Цвет волос', person.hairColor.uiString),
      if (person.nationality != null)
        _InfoItem(Icons.flag, 'Национальность', person.nationality!.uiString),
      _InfoItem(
        Icons.explore,
        'Местоположение',
        '(${person.location.x}, ${person.location.y}, ${person.location.z})',
      ),
    ];
  }

  String _getOscarSuffix(int count) {
    if (count % 10 == 1 && count % 100 != 11) return '';
    if ([2, 3, 4].contains(count % 10) && ![12, 13, 14].contains(count % 100)) return 'а';
    return 'ов';
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  _InfoItem(this.icon, this.label, this.value);
}
