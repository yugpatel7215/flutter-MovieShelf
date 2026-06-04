import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieshelf/providers/recommended_movie_provider.dart';

class RecommendedMovie extends ConsumerWidget {
  final int movieId;

  const RecommendedMovie({super.key, required this.movieId});

  String _imageUrl(String? path, {String size = 'w185'}) {
    if (path == null || path.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/$size$path';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendedAsyn = ref.watch(recommendedMovieProvider(movieId));

    return recommendedAsyn.when(
      data: (castList) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Reecommended Movies',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: castList.length,
              itemBuilder: (context, index) {
                final member = castList[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12, left: 5),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 66,
                        backgroundImage: member.posterPath != null
                            ? NetworkImage(_imageUrl(member.posterPath))
                            : null,
                        child: member.posterPath == null
                            ? const Icon(Icons.person, size: 36)
                            : null,
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 72,
                        child: Text(
                          member.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Cast unavailable: $e'),
    );
  }
}
