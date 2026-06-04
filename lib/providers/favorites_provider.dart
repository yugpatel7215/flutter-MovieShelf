import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieshelf/models/movie.dart';
import 'package:movieshelf/repository/favourite_repository.dart';

final favouriteProvider = AsyncNotifierProvider<FavoriteNotifier, List<Movie>>(
  () => FavoriteNotifier(),
);

class FavoriteNotifier extends AsyncNotifier<List<Movie>> {
  @override
  Future<List<Movie>> build() async {
    final favRepo = ref.read(favouriteRepoProvider);
    return favRepo.getFavourite();
  }

  Future<void> toggleFavorite(Movie movie) async {
    final favRepo = ref.read(favouriteRepoProvider);
    await favRepo.toggleFavourite(movie);
    ref.invalidateSelf();
  }
}
