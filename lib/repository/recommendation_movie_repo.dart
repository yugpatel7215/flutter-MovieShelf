import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieshelf/models/movie.dart';
import 'package:http/http.dart' as http;

class RecommendationMovieRepo {
  Future<List<Movie>> getRecommendedMovies(int movieId) async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/recommendations?api_key=eab806bfab3d20f65a473bb61851c9c5',
      ),
    );
    if (response.statusCode == 200) {
      final decodeddata = jsonDecode(response.body);

      final List<dynamic> data = decodeddata['results'];

      final moviedata = data.map((item) => Movie.fromJson(item)).toList();

      return moviedata;
    } else {
      throw Exception('Data not found ${response.statusCode}');
    }
  }
}

final recommendedMovieRepoProvider = Provider((ref) {
  return RecommendationMovieRepo();
});
