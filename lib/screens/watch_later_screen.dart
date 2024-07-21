import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class WatchLaterScreen extends StatefulWidget {
  @override
  _WatchLaterScreenState createState() => _WatchLaterScreenState();
}

class _WatchLaterScreenState extends State<WatchLaterScreen> {
  List<Map<String, dynamic>> watchLaterMovies = [];

  @override
  void initState() {
    super.initState();
    _loadWatchLaterMovies();
  }

  void _loadWatchLaterMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMovies = prefs.getString('watchLaterMovies');
    if (savedMovies != null) {
      setState(() {
        watchLaterMovies = List<Map<String, dynamic>>.from(json.decode(savedMovies));
      });
    }
  }

  void _saveWatchLaterMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('watchLaterMovies', json.encode(watchLaterMovies));
  }

  void _addWatchLaterMovie() async {
    final movie = await _searchMovie();
    if (movie != null) {
      final dateAdded = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateAdded);
      setState(() {
        movie['date_added'] = formattedDate;
        watchLaterMovies.add(movie);
      });
      _saveWatchLaterMovies();
    }
  }

  Future<Map<String, dynamic>?> _searchMovie() async {
    String? query = await _showMovieSearchDialog();
    if (query != null && query.isNotEmpty) {
      final url = Uri.parse('https://api.themoviedb.org/3/search/movie?api_key=524e4d69942fdfeda7ab5b3541eeec32&query=$query');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final results = json.decode(response.body)['results'];
        if (results.isNotEmpty) {
          return results.first;
        }
      }
    }
    return null;
  }

  Future<String?> _showMovieSearchDialog() async {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search Movie',style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Movie Name'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel',style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Search',style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pop(context, controller.text),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watch Later'),
        backgroundColor: Colors.cyan.shade100,
      ),
      body: ListView.builder(
        itemCount: watchLaterMovies.length,
        itemBuilder: (context, index) {
          final movie = watchLaterMovies[index];
          return Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                  'Added on: ${movie['date_added']}',
                  style: TextStyle(color: Colors.green, fontSize: 19),
                ),),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 150,
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie['title'] ?? 'No Title',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            movie['release_date'] ?? '',
                            style: TextStyle(color: Colors.white54),
                          ),
                          if (movie['overview'] != null) ...[
                            SizedBox(height: 10),
                            Text(
                              movie['overview'],
                              style: TextStyle(color: Colors.white70),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addWatchLaterMovie,
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan.shade100,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
