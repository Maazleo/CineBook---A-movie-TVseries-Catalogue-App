import 'package:flutter/material.dart';

class PopularScreen extends StatelessWidget {
  const PopularScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),backgroundColor: Colors.cyan.shade100,
      ),
      body: const Center(
        child: Text('List of popular movies will be here'),
      ),
    );
  }
}
