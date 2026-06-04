import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieshelf/models/movie.dart';
import 'package:movieshelf/providers/favorites_provider.dart';
import 'package:movieshelf/providers/movie_provider.dart';
import 'package:movieshelf/widgets/details_widget.dart';

class MovieDetailsScreen extends ConsumerStatefulWidget {
  final Movie movie;
  final int movieid;
  const MovieDetailsScreen({
    super.key,
    required this.movieid,
    required this.movie,
  });

  @override
  ConsumerState<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends ConsumerState<MovieDetailsScreen> {
  String _imageUrl(String? path, {String size = 'w500'}) {
    if (path == null || path.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/$size$path';
  }

  String _formatDate(DateTime date) {
    if (date.year == 1970) return 'Not available';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final detailsprovider = ref.watch(movieDetailsProvider(widget.movieid));
    final favoritesAsync = ref.watch(favouriteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
        elevation: 0,
        actions: [
          favoritesAsync.when(
            data: (favorites) {
              final isFavorite = favorites.any(
                (item) => item.id == widget.movieid,
              );

              return IconButton(
                tooltip: isFavorite
                    ? 'Remove from favorites'
                    : 'Add to favorites',
                onPressed: () async {
                  await ref
                      .read(favouriteProvider.notifier)
                      .toggleFavorite(
                        Movie(
                          id: widget.movieid,
                          title: widget.movie.title,
                          posterPath: widget.movie.posterPath,
                        ),
                      );
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.redAccent : Colors.white,
                ),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (error, stackTrace) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: detailsprovider.when(
        data: (movie) {
          final posterUrl = _imageUrl(movie.posterPath);
          final backdropUrl = _imageUrl(movie.backdropPath, size: 'w780');

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Backdrop
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: backdropUrl.isNotEmpty
                      ? Image.network(
                          backdropUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Icon(Icons.movie, size: 60)),
                        )
                      : const Center(child: Icon(Icons.movie, size: 60)),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster + Title + Rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              width: 110,
                              height: 165,
                              child: posterUrl.isNotEmpty
                                  ? Image.network(
                                      posterUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Center(
                                                child: Icon(
                                                  Icons.movie,
                                                  size: 50,
                                                ),
                                              ),
                                    )
                                  : const Center(
                                      child: Icon(Icons.movie, size: 50),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _formatDate(movie.releaseDate),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Rating chip
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.amber.shade700,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 16,
                                        color: Colors.amber[700],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${movie.rating.toStringAsFixed(1)} / 10',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Colors.amber[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Overview
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview.isEmpty
                            ? 'Not available'
                            : movie.overview,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Details
                      Text(
                        'Details',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      DetailRow(label: 'Title', value: movie.title),
                      DetailRow(
                        label: 'Rating',
                        value: '${movie.rating.toStringAsFixed(1)} / 10',
                      ),
                      DetailRow(
                        label: 'Release Date',
                        value: _formatDate(movie.releaseDate),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stack) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
