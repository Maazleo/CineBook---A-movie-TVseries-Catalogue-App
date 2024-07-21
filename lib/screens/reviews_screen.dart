import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewsScreen extends StatefulWidget {
  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<Map<String, dynamic>> reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  void _loadReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedReviews = prefs.getString('reviews');
    if (savedReviews != null) {
      setState(() {
        reviews = List<Map<String, dynamic>>.from(json.decode(savedReviews));
      });
    }
  }

  void _saveReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('reviews', json.encode(reviews));
  }

  void _addReview() async {
    final movie = await _searchMovie();
    if (movie != null) {
      setState(() {
        reviews.add(movie);
      });
      _saveReviews();
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

  void _addReviewDetails(int index) async {
    final reviewDetails = await _showReviewDetailsDialog();
    if (reviewDetails != null) {
      setState(() {
        reviews[index]['review'] = reviewDetails['review'];
        reviews[index]['rating'] = reviewDetails['rating'];
      });
      _saveReviews();
    }
  }

  Future<Map<String, dynamic>?> _showReviewDetailsDialog() async {
    TextEditingController controller = TextEditingController();
    double rating = 0;
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: 'Review'),
              ),
              SizedBox(height: 20),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () => Navigator.pop(context, {'review': controller.text, 'rating': rating}),
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
        title: Text('Popular Reviews'),
        backgroundColor: Colors.cyan.shade100,
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 150,
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${review['poster_path']}',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['title'] ?? 'No Title',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        review['release_date'] ?? '',
                        style: TextStyle(color: Colors.white54),
                      ),
                      if (review['review'] != null) ...[
                        SizedBox(height: 10),
                        Text(
                          review['review'],
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                      if (review['rating'] != null) ...[
                        SizedBox(height: 10),
                        RatingBar.builder(
                          initialRating: review['rating'].toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (_) {},
                          ignoreGestures: true,
                          itemSize: 20.0,
                        ),
                      ],
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    child: Text('Edit Review', style: TextStyle(color: Colors.cyan)),
                    onPressed: () => _addReviewDetails(index),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReview,
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan.shade100,
      ),
    );
  }
}
