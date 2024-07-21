import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  List<Map<String, dynamic>> diaryEntries = [];

  @override
  void initState() {
    super.initState();
    _loadDiaryEntries();
  }

  void _loadDiaryEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEntries = prefs.getString('diaryEntries');
    if (savedEntries != null) {
      setState(() {
        diaryEntries = List<Map<String, dynamic>>.from(json.decode(savedEntries));
      });
    }
  }

  void _saveDiaryEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('diaryEntries', json.encode(diaryEntries));
  }

  void _addDiaryEntry() async {
    final newEntry = await _showDiaryEntryDialog();
    if (newEntry != null) {
      setState(() {
        diaryEntries.add(newEntry);
      });
      _saveDiaryEntries();
    }
  }

  void _editDiaryEntry(int index) async {
    final updatedEntry = await _showDiaryEntryDialog(entry: diaryEntries[index]);
    if (updatedEntry != null) {
      setState(() {
        diaryEntries[index] = updatedEntry;
      });
      _saveDiaryEntries();
    }
  }

  Future<Map<String, dynamic>?> _showDiaryEntryDialog({Map<String, dynamic>? entry}) async {
    TextEditingController titleController = TextEditingController(text: entry?['title'] ?? '');
    TextEditingController notesController = TextEditingController(text: entry?['notes'] ?? '');
    double rating = entry?['rating'] ?? 0.0;
    DateTime dateWatched = entry != null ? DateTime.parse(entry['dateWatched']) : DateTime.now();

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(entry == null ? 'Add Diary Entry' : 'Edit Diary Entry'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Movie Title'),
                ),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                RatingBar.builder(
                  initialRating: rating,
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date Watched:',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      child: Text(
                        "${dateWatched.toLocal()}".split(' ')[0],
                        style: TextStyle(fontSize: 16,color: Colors.white),
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: dateWatched,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != dateWatched) {
                          setState(() {
                            dateWatched = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel',style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Save',style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.pop(context, {
                'title': titleController.text,
                'notes': notesController.text,
                'rating': rating,
                'dateWatched': dateWatched.toIso8601String(),
              }),
            ),
          ],
        );
      },
    );
  }

  void _deleteDiaryEntry(int index) {
    setState(() {
      diaryEntries.removeAt(index);
    });
    _saveDiaryEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Diary'),
        backgroundColor: Colors.cyan.shade100,
      ),
      body: ListView.builder(
        itemCount: diaryEntries.length,
        itemBuilder: (context, index) {
          final entry = diaryEntries[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            color: Colors.grey.shade900,
            child: ListTile(
              contentPadding: EdgeInsets.all(10.0),
              title: Text(
                entry['title'] ?? 'No Title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Watched on: ${entry['dateWatched'].split('T')[0]}',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  if (entry['notes'] != null)
                    Text(
                      entry['notes'],
                      style: TextStyle(color: Colors.white70),
                    ),
                  SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: entry['rating'].toDouble(),
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
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.cyan),
                    onPressed: () => _editDiaryEntry(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteDiaryEntry(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDiaryEntry,
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan.shade100,
      ),
    );
  }
}
