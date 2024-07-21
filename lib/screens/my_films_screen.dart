import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'search_screen.dart';

class MyFilmsScreen extends StatefulWidget {
  @override
  _MyFilmsScreenState createState() => _MyFilmsScreenState();
}

class _MyFilmsScreenState extends State<MyFilmsScreen> {
  Map<String, List<String>> _categories = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? categoriesString = prefs.getString('film_categories');
    if (categoriesString != null) {
      setState(() {
        _categories = Map<String, List<String>>.from(
          json.decode(categoriesString).map(
                (key, value) => MapEntry(key, List<String>.from(value)),
          ),
        );
      });
    }
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('film_categories', json.encode(_categories));
  }

  Future<void> _addCategory(String category) async {
    if (!_categories.containsKey(category)) {
      setState(() {
        _categories[category] = [];
      });
      await _saveCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Films'),
        backgroundColor: Colors.cyan.shade200,
      ),
      body: ListView.builder(
        itemCount: _categories.keys.length,
        itemBuilder: (context, index) {
          final category = _categories.keys.elementAt(index);
          final films = _categories[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: films.length,
                  itemBuilder: (context, filmIndex) {
                    final film = films[filmIndex];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1.0),
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500$film',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: 120,

                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String? newCategory = await _showCategoryDialog();
          if (newCategory != null && newCategory.isNotEmpty) {
            _addCategory(newCategory);
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Category',
      ),
    );
  }

  Future<String?> _showCategoryDialog({String? currentCategory}) async {
    final TextEditingController controller = TextEditingController(
      text: currentCategory,
    );
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(currentCategory == null ? 'Add New Category' : 'Edit Category',style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Category Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text(currentCategory == null ? 'Add' : 'Save',style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }
}
