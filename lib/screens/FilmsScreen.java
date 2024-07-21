import 'package:flutter/material.dart';
import 'package:your_app_name/movie_detail_screen.dart'; // Ensure you have this file for details

class FilmsScreen extends StatelessWidget {
  // Example categories, you should fetch these from your backend or API
  final List<Map<String, dynamic>> categories = [
    {'name': 'Action', 'movies': []},
    {'name': 'Drama', 'movies': []},
    {'name': 'Comedy', 'movies': []},
    {'name': 'Horror', 'movies': []},
    {'name': 'Sci-Fi', 'movies': []},
  ];

  FilmsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    categories[index]['name'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => Navigator.of(context).pushNamed('/search'), // Navigate to the search screen
                  ),
                ],
              ),
            ),
            Container(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories[index]['movies'].length,
                itemBuilder: (context, i) {
                  final movie = categories[index]['movies'][i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MovieDetailScreen(movieId: movie['id'])),
                    ),
                    child: Container(
                      width: 160,
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(movie['imageUrl'], fit: BoxFit.cover),
                          ),
                          Text(movie['title'], style: TextStyle(fontSize: 16)),
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
    );
  }
}
