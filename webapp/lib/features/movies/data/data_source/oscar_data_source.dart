import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webapp/features/movies/data/data_source/remote/oscar_remote_data_source_impl.dart';

import '../../../../core/network/network_providers.dart';
import '../../domain/entities/movie_enums.dart';
import '../models/humiliate_by_genre_response.dart';
import '../models/looser_dto.dart';

part 'oscar_data_source.g.dart';

abstract class OscarDataSource {
  Future<List<LooserDto>> getLoosers();

  Future<HumiliateByGenreResponse> humiliateByGenre(MovieGenre genre);
}

@riverpod
OscarDataSource oscarDataSource(Ref ref) {
  return OscarRemoteDataSourceImpl(ref.watch(dioProvider));
}
