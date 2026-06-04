import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:movieshelf/models/movie.dart';

class FavouriteRepository {
  final Box<Movie> _favoritesBox = Hive.box<Movie>('favorites');

  Future<void> toggleFavourite(Movie movie) async {
    final favouritevalue = _favoritesBox.containsKey(movie.id);

    if (favouritevalue) {
      await _favoritesBox.delete(movie.id);
    } else {
      await _favoritesBox.put(movie.id, movie);
    }
  }

  List<Movie> getFavourite() {
    return _favoritesBox.values.toList();
  }
}

final favouriteRepoProvider = Provider<FavouriteRepository>((ref) {
  return FavouriteRepository();
});
