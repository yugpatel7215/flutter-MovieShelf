import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:movieshelf/models/movie.dart';
import 'package:movieshelf/models/movie_details.dart';
import 'package:movieshelf/repository/movie_repository.dart';

final movieProvider = AsyncNotifierProvider<MovieNotifier, List<Movie>>(
  () => MovieNotifier(),
);

final searchMovie = StateProvider<String>((ref) {
  return '';
});

final searchMovieProvider = FutureProvider.family<List<Movie>, String>((
  ref,
  query,
) async {
  final repo = ref.read(movieRepositoryProvider);

  return repo.seachMovie(query);
});

final movieDetailsProvider = FutureProvider.family<MovieDetails, int>((
  ref,
  id,
) {
  final repo = ref.read(movieRepositoryProvider);

  return repo.getMovieDetails(id);
});

class MovieNotifier extends AsyncNotifier<List<Movie>> {
  int _page = 1;

  bool _hasmore = true;
  bool _isloading = false;

  @override
  Future<List<Movie>> build() async {
    final repo = ref.watch(movieRepositoryProvider);
    return repo.getPopularMovies(_page);
  }

  Future<void> loadNextPage() async {
    if (!_hasmore || _isloading) return;

    final currentList = state.value ?? [];

    try {
      _isloading = true;

      final nextPage = _page + 1;

      final repo = ref.read(movieRepositoryProvider);

      final fetched = await repo.getPopularMovies(nextPage);

      if (fetched.isEmpty) {
        _hasmore = false;
        return;
      }

      _page = nextPage;

      state = AsyncData([...currentList, ...fetched]);
    } catch (e) {
      print(e);
    } finally {
      _isloading = false;
    }
  }
}
