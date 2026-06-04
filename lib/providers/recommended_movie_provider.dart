import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieshelf/models/movie.dart';
import 'package:movieshelf/repository/recommendation_movie_repo.dart';

final recommendedMovieProvider = FutureProvider.family<List<Movie>, int>((
  ref,
  movieId,
) {
  final repo = ref.read(recommendedMovieRepoProvider);

  return repo.getRecommendedMovies(movieId);
});
