import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieshelf/models/cast_model.dart';
import 'package:movieshelf/repository/cast_repository.dart';

final castProvider = FutureProvider.family<List<CastMember>, int>((
  ref,
  movieId,
) async {
  final repo = ref.read(castRepoProvider);

  return repo.getMovieCast(movieId);
});
