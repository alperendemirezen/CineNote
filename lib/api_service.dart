import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class TMDBService {
  final String apiKey = 'b86f7fb1d525d761a53dc02e17cd1e5e';

  Future<Map<String, dynamic>> fetchMovieDetails(int id) async {
    final url =
        'https://api.themoviedb.org/3/movie/$id?api_key=$apiKey&language=en-US';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Detay verisi çekilemedi');
    }
  }

  Future<List<Map<String, dynamic>>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to search movies');
    }
  }

  Future<List<Map<String, dynamic>>> searchTvShows(String query) async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/search/tv?api_key=$apiKey&query=$query',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to search TV shows');
    }
  }

  Future<List<Map<String, dynamic>>> fetchRandomMoviesAndTVShows() async {
    final random = Random();

    final movieResponse = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=1',
      ),
    );

    final tvResponse = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/tv/popular?api_key=$apiKey&language=en-US&page=1',
      ),
    );

    if (movieResponse.statusCode == 200 && tvResponse.statusCode == 200) {
      final movieData = jsonDecode(movieResponse.body);
      final tvData = jsonDecode(tvResponse.body);

      List movies = movieData['results'];
      List tvShows = tvData['results'];

      movies.shuffle();
      List randomMovies = movies.take(10).toList();

      tvShows.shuffle();
      List randomTVShows = tvShows.take(10).toList();

      List<Map<String, dynamic>> combinedList = [];

      combinedList.addAll(randomMovies.cast<Map<String, dynamic>>());
      combinedList.addAll(randomTVShows.cast<Map<String, dynamic>>());

      return combinedList;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
