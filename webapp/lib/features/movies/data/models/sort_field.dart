class SortField {
  final String field;
  final String direction;
  final String displayName;

  const SortField({
    required this.field,
    required this.direction,
    required this.displayName,
  });

  String toSortString() => '$field,$direction';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SortField &&
              runtimeType == other.runtimeType &&
              field == other.field &&
              direction == other.direction;

  @override
  int get hashCode => field.hashCode ^ direction.hashCode;
}
