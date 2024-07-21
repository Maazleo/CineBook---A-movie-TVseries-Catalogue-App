import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowDetailScreen extends StatefulWidget {
  final String showId;

  ShowDetailScreen({Key? key, required this.showId}) : super(key: key);

  @override
  _ShowDetailScreenState createState() => _ShowDetailScreenState();
}

class _ShowDetailScreenState extends State<ShowDetailScreen> {
  Map<String, dynamic> showDetails = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShowDetails();
  }

  Future<void> fetchShowDetails() async {
    const apiKey = '524e4d69942fdfeda7ab5b3541eeec32';
    final url = 'https://api.themoviedb.org/3/tv/${widget.showId}?api_key=$apiKey&language=en-US';
    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      setState(() {
        showDetails = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching show details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showDetails['name'] ?? 'Show Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                showDetails['name'] ?? 'No title available',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Image.network(
                'https://image.tmdb.org/t/p/w500${showDetails['poster_path']}',
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              const Text(
                'Overview:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(showDetails['overview'] ?? 'No description available'),
              const SizedBox(height: 10),
              Text(
                'First Air Date: ${showDetails['first_air_date']}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
