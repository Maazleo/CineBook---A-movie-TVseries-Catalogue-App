import 'package:flutter/material.dart';
import 'modal_screen.dart';  // Ensure this points to your ModalScreen for details
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';  // Import dart:math for shuffling

class TVShowsScreen extends StatefulWidget {
  @override
  _TVShowsScreenState createState() => _TVShowsScreenState();
}

class _TVShowsScreenState extends State<TVShowsScreen> {
  List<dynamic> categories = [];
  final String apiKey = '524e4d69942fdfeda7ab5b3541eeec32';  // Replace with your actual TMDB API key

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  fetchCategories() async {
    var response = await http.get(Uri.parse('https://api.themoviedb.org/3/genre/tv/list?api_key=$apiKey&language=en-US'));
    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body)['genres'];
        categories.shuffle();  // Shuffle categories
      });
      for (var category in categories) {
        fetchMoviesForCategory(category['id']);
      }
    }
  }

  fetchMoviesForCategory(int categoryId) async {
    var response = await http.get(Uri.parse('https://api.themoviedb.org/3/discover/tv?api_key=$apiKey&with_genres=$categoryId'));
    if (response.statusCode == 200) {
      var moviesData = json.decode(response.body)['results'];
      moviesData.shuffle();  // Shuffle movies within the category
      setState(() {
        categories.firstWhere((cat) => cat['id'] == categoryId)['movies'] = moviesData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('TV Shows Categories')),
        backgroundColor: Colors.cyan.shade100,
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          var category = categories[index];
          var movies = category['movies'] ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category['name'],
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, i) {
                    var movie = movies[i];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ModalScreen(movie: movie)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          children: [
                            Container(
                              width: 130,
                              height: 170,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  image: NetworkImage('https://image.tmdb.org/t/p/w500${movie['poster_path']}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: 120,
                              child: Text(
                                movie['name'] ?? 'No Title',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
