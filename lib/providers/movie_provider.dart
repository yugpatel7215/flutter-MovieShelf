import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieshelf/models/movie_models.dart';
import 'package:movieshelf/repository/movie_repository.dart';

final movieProvider = AsyncNotifierProvider<MovieNotifier, List<Movie>>(
  () => MovieNotifier(),
);

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
