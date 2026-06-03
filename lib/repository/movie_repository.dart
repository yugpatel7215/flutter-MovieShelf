import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:movieshelf/models/movie_models.dart';

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
}

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepository();
});
