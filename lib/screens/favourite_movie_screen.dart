import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieshelf/providers/favorites_provider.dart';
import 'package:movieshelf/screens/movie_details_screen.dart';

class FavouriteMovieScreen extends ConsumerWidget {
  const FavouriteMovieScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMovies = ref.watch(favouriteProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favourite Movies'), centerTitle: true),
      body: favoriteMovies.when(
        data: (movies) {
          if (movies.isEmpty) {
            return const Center(child: Text('No favourite movies yet'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              final imageUrl = movie.posterPath != null
                  ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                  : null;

              return InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MovieDetailsScreen(movieid: movie.id, movie: movie),
                  ),
                ),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Expanded(
                        child: imageUrl != null
                            ? Image.network(
                                imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.movie, size: 50),
                                  );
                                },
                              )
                            : const Center(child: Icon(Icons.movie, size: 50)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
