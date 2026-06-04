import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieshelf/providers/movie_provider.dart';
import 'package:movieshelf/screens/favourite_movie_screen.dart';
import 'package:movieshelf/screens/movie_details_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      final currentScroll = scrollController.position.pixels;
      final maxScroll = scrollController.position.maxScrollExtent;

      if (ref.read(searchMovie).isEmpty && currentScroll > maxScroll - 300) {
        ref.read(movieProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieAsync = ref.watch(movieProvider);
    final query = ref.watch(searchMovie);
    final provider = query.isEmpty
        ? movieAsync
        : ref.watch(searchMovieProvider(query));

    return Scaffold(
      appBar: AppBar(
        title: const Text('MovieShelf'),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavouriteMovieScreen()),
            ),
            icon: const Icon(Icons.favorite_outline),
            label: const Text('Favourites'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchcontroller,
              decoration: InputDecoration(
                hintText: 'Search movies',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchcontroller.clear();
                    ref.read(searchMovie.notifier).state = '';
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                ref.read(searchMovie.notifier).state = value.trim();
              },
            ),
          ),
          Expanded(
            child: provider.when(
              data: (movies) {
                return GridView.builder(
                  controller: scrollController,
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
                          builder: (context) => MovieDetailsScreen(
                            movieid: movie.id,
                            movie: movie,
                          ),
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.movie,
                                                size: 50,
                                              ),
                                            );
                                          },
                                    )
                                  : const Center(
                                      child: Icon(Icons.movie, size: 50),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                movie.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              error: (error, stackTrace) {
                return Center(child: Text('Error: $error'));
              },
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
