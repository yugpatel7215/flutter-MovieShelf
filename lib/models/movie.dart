import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 1)
class Movie {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String? posterPath;

  Movie({required this.id, required this.title, this.posterPath});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
    );
  }
}
