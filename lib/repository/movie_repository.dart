import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:movieshelf/models/movie.dart';
import 'package:movieshelf/models/movie_details.dart';

class MovieRepository {
  Future<List<Movie>> getPopularMovies(int page) async {
    print('API Call Started');
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=eab806bfab3d20f65a473bb61851c9c5&page=$page',
      ),
    );
    print('Response Received');
    if (response.statusCode == 200) {
      final decodeddata = jsonDecode(response.body);

      final List<dynamic> moviedata = decodeddata['results'];

      final movielist = moviedata.map((item) => Movie.fromJson(item)).toList();

      return movielist;
    } else {
      throw Exception('Data not found ${response.statusCode}');
    }
  }

  Future<List<Movie>> seachMovie(String query) async {
    final url = Uri.https('api.themoviedb.org', '/3/search/movie', {
      'api_key': 'eab806bfab3d20f65a473bb61851c9c5',
      'query': query,
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodeddata = jsonDecode(response.body);
      final List<dynamic> moviedata = decodeddata['results'];

      final seachedMovieList = moviedata
          .map((item) => Movie.fromJson(item))
          .toList();

      return seachedMovieList;
    } else {
      throw (Exception('Data not found ${response.statusCode}'));
    }
  }

  Future<MovieDetails> getMovieDetails(int movie_id) async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie_id}?api_key=eab806bfab3d20f65a473bb61851c9c5',
      ),
    );
    if (response.statusCode == 200) {
      final decodeddata = jsonDecode(response.body);

      final movie = MovieDetails.fromJson(decodeddata);

      return movie;
    } else {
      throw Exception('Data not found ${response.statusCode}');
    }
  }
}

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepository();
});
