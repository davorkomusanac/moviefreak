import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../api_key.dart';
import '../models/movie_details/movie_details.dart';
import '../models/movie_search/movie_search_results.dart';

const String _baseSearchMovieUrl = "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=en-US&query=";
const String _baseMovieDetailsUrl = "https://api.themoviedb.org/3/movie/";
const String _basePopularMoviesUrl = "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=";

class MovieRepository {
  final http.Client client;

  MovieRepository(this.client);

  Future<MovieSearchResults> searchMovie(String title, [int page = 1]) async {
    try {
      final response = await client.get(
        Uri.parse(
          _buildSearchUrl(title, page),
        ),
      );
      log(_buildSearchUrl(title, page));

      if (response.statusCode != 200) throw Exception('There was an error searching');

      return MovieSearchResults.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
        page,
      );
    } catch (e) {
      log("Movie Search ERROR: ${e.toString()}");
      throw e.toString();
    }
  }

  String _buildSearchUrl(String title, int page) {
    String returnString = _baseSearchMovieUrl;
    List<String> queryWords = title.split(" ");

    for (int i = 0; i < queryWords.length; i++) {
      if (i != queryWords.length - 1) {
        returnString += "${queryWords[i]}%20";
      } else {
        returnString += queryWords[i];
      }
    }

    if (page != 1) {
      returnString += "&page=$page&include_adult=false";
    } else {
      returnString += "&page=1&include_adult=false";
    }

    return returnString;
  }

  Future<MovieDetails> getMovieDetails(int id) async {
    try {
      final response = await client.get(
        Uri.parse(
          _buildMovieDetailsUrl(id),
        ),
      );
      log(_buildMovieDetailsUrl(id));

      if (response.statusCode != 200) throw Exception('There was an error getting movie details');

      return MovieDetails.fromJson(json.decode(response.body) as Map<String, dynamic>);
    } catch (e) {
      log("Movie Details ERROR: $e");
      throw e.toString();
    }
  }

  String _buildMovieDetailsUrl(int id) {
    String returnString = "$_baseMovieDetailsUrl$id?api_key=$apiKey&append_to_response=credits,recommendations,videos";

    return returnString;
  }

  Future<MovieSearchResults> getPopularMovies([int page = 1]) async {
    try {
      final response = await client.get(
        Uri.parse(
          _basePopularMoviesUrl + page.toString(),
        ),
      );
      log(_basePopularMoviesUrl + page.toString());

      if (response.statusCode != 200) throw Exception('There was an error searching');

      return MovieSearchResults.fromJson(
        json.decode(response.body) as Map<String, dynamic>,
        page,
      );
    } catch (e) {
      log("Popular Movies Search ERROR: $e");
      throw e.toString();
    }
  }
}
