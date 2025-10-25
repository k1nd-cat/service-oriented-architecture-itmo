import 'package:json_annotation/json_annotation.dart';

part 'humiliate_by_genre_response.g.dart';

@JsonSerializable(createToJson: false)
class HumiliateByGenreResponse {
  final int affectedDirectors;
  final int affectedMovies;
  final int removedOscars;

  const HumiliateByGenreResponse({
    required this.affectedDirectors,
    required this.affectedMovies,
    required this.removedOscars,
  });

  factory HumiliateByGenreResponse.fromJson(Map<String, dynamic> json) =>
      _$HumiliateByGenreResponseFromJson(json);
}
