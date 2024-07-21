import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ModalScreen extends StatefulWidget {
  final Map<String, dynamic> movie;

  ModalScreen({super.key, required this.movie});

  @override
  _ModalScreenState createState() => _ModalScreenState();
}

class _ModalScreenState extends State<ModalScreen> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();

    // Load film categories
    final filmCategoriesString = prefs.getString('film_categories');
    final filmCategories = filmCategoriesString != null
        ? Map<String, List<String>>.from(json.decode(filmCategoriesString))
        : {};

    // Load TV show categories
    final tvShowCategoriesString = prefs.getString('tv_show_categories');
    final tvShowCategories = tvShowCategoriesString != null
        ? Map<String, List<String>>.from(json.decode(tvShowCategoriesString))
        : {};

    setState(() {
      categories = [...filmCategories.keys, ...tvShowCategories.keys];
      print('Loaded categories: $categories'); // Debugging line
    });
  }

  void _showCategorySelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: categories.isNotEmpty
              ? Container(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(categories[index]),
                  onTap: () {
                    _addMovieToCategory(categories[index]);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          )
              : const Text('No categories available.'),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addMovieToCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();

    // Load film categories
    final filmCategoriesString = prefs.getString('film_categories');
    Map<String, List<String>> filmCategories = filmCategoriesString != null
        ? Map<String, List<String>>.from(json.decode(filmCategoriesString))
        : {};

    // Load TV show categories
    final tvShowCategoriesString = prefs.getString('tv_show_categories');
    Map<String, List<String>> tvShowCategories = tvShowCategoriesString != null
        ? Map<String, List<String>>.from(json.decode(tvShowCategoriesString))
        : {};

    // Check if the category exists in film categories or TV show categories
    if (filmCategories.containsKey(category)) {
      filmCategories[category]!.add(widget.movie['title']);
      prefs.setString('film_categories', json.encode(filmCategories));
    } else if (tvShowCategories.containsKey(category)) {
      tvShowCategories[category]!.add(widget.movie['title']);
      prefs.setString('tv_show_categories', json.encode(tvShowCategories));
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Movie added to $category')));
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> castList = widget.movie['cast'] ?? [];

    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      appBar: AppBar(
        title: Text(widget.movie['title']),
        backgroundColor: Colors.teal.shade200,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              _showCategorySelectionDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 500,
              width: double.infinity,
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'IMDb Rating: ${widget.movie['vote_average']}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Released: ${widget.movie['release_date']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Starring: ${castList.isNotEmpty ? castList.join(", ") : 'No cast information available'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Overview',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.movie['overview'],
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCategorySelectionDialog(context);
        },
        child: const Icon(Icons.add),
        tooltip: 'Add to My List',
      ),
    );
  }
}
