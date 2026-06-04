import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:movieshelf/models/cast_model.dart';

class CastRepository {
  Future<List<CastMember>> getMovieCast(int movieId) async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/${movieId}/credits?api_key=eab806bfab3d20f65a473bb61851c9c5',
      ),
    );
    if (response.statusCode == 200) {
      final decodedata = jsonDecode(response.body);

      final List<dynamic> castdata = decodedata['cast'];

      final castmembers = castdata
          .map((item) => CastMember.fromJson(item))
          .toList();

      return castmembers;
    } else {
      throw ('Data not found ${response.statusCode}');
    }
  }
}

final castRepoProvider = Provider<CastRepository>((ref) {
  return CastRepository();
});
