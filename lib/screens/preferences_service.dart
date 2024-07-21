import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  // Method to add a movie ID to a specific category
  Future<void> addMovieToCategory(String category, String movieId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> movies = prefs.getStringList(category) ?? [];
    if (!movies.contains(movieId)) {
      movies.add(movieId);
      await prefs.setStringList(category, movies);
    }
  }

  // Method to retrieve all movie IDs from a specific category
  Future<List<String>> getMoviesFromCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(category) ?? [];
  }

  // Optional: Method to remove a movie from a category
  Future<void> removeMovieFromCategory(String category, String movieId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> movies = prefs.getStringList(category) ?? [];
    movies.remove(movieId);
    await prefs.setStringList(category, movies);
  }

  // Optional: Clear all data from SharedPreferences (useful for debugging or reset functionality)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
