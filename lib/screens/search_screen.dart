import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'modal_screen.dart';  // Import the ModalScreen

class SearchScreen extends StatefulWidget {
  final String category;
  final Function(Map<String, dynamic>) onMovieSelected;
  final Function(Map<String, dynamic>) onTVShowSelected;

  const SearchScreen({
    Key? key,
    required this.category,
    required this.onMovieSelected,
    required this.onTVShowSelected,
  }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  List _results = [];
  final String apiKey = '524e4d69942fdfeda7ab5b3541eeec32';  // Replace with your actual TMDB API key
  bool _isLoading = false;
  Map<String, List<String>> _tvShowCategories = {};
  Map<String, List<String>> _filmCategories = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();

    final String? tvShowCategoriesString = prefs.getString('tv_show_categories');
    if (tvShowCategoriesString != null) {
      setState(() {
        _tvShowCategories = Map<String, List<String>>.from(
          json.decode(tvShowCategoriesString).map(
                (key, value) => MapEntry(key, List<String>.from(value)),
          ),
        );
      });
    }

    final String? filmCategoriesString = prefs.getString('film_categories');
    if (filmCategoriesString != null) {
      setState(() {
        _filmCategories = Map<String, List<String>>.from(
          json.decode(filmCategoriesString).map(
                (key, value) => MapEntry(key, List<String>.from(value)),
          ),
        );
      });
    }
  }

  void _search() async {
    setState(() {
      _isLoading = true;
      _results.clear();  // Clear old data
    });
    final url = Uri.parse('https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$_query');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _results = json.decode(response.body)['results'];
          _isLoading = false;
        });
      } else {
        print('Error fetching movies: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showCategoryDialog(Map<String, dynamic> item) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add to Category'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const Text('TV Show Categories'),
                ..._tvShowCategories.keys.map((category) {
                  return ListTile(
                    title: Text(category),
                    onTap: () async {
                      await _addToCategory('tv_show_categories', category, item['poster_path']);
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
                const Text('Film Categories'),
                ..._filmCategories.keys.map((category) {
                  return ListTile(
                    title: Text(category),
                    onTap: () async {
                      await _addToCategory('film_categories', category, item['poster_path']);
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addToCategory(String prefKey, String category, String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    final String? categoriesString = prefs.getString(prefKey);
    Map<String, List<String>> categories = {};

    if (categoriesString != null) {
      categories = Map<String, List<String>>.from(
        json.decode(categoriesString).map(
              (key, value) => MapEntry(key, List<String>.from(value)),
        ),
      );
    }

    if (!categories.containsKey(category)) {
      categories[category] = [];
    }
    categories[category]!.add(imagePath);

    prefs.setString(prefKey, json.encode(categories));
  }

  void _showDetailsModal(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item['title'] ?? 'No Title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(item['overview'] ?? 'No description available'),
              SizedBox(height: 10),
              Text('Release date: ${item['release_date'] ?? 'Unknown'}'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search title for ${widget.category}'),
        backgroundColor: Colors.cyan.shade100,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                _query = value;
              },
              onSubmitted: (value) => _search(),
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final item = _results[index];
                return ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModalScreen(movie: item),
                        ),
                      );
                    },
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${item['poster_path']}',
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModalScreen(movie: item),
                        ),
                      );
                    },
                    child: Text(item['title'] ?? 'No Title'),
                  ),
                  subtitle: Text('Release date: ${item['release_date'] ?? 'Unknown'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showCategoryDialog(item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
