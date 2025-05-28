import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'api_service.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const DetailsPage({Key? key, required this.item}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Map<String, dynamic>? details;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  int _selectedRating = 0;
  List<Map<String, dynamic>> comments = [];
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchDetails();
    fetchComments();
    checkIfFavorite();
  }

  Future<void> fetchDetails() async {
    try {
      final int movieId = int.parse(widget.item['id']);
      final data = await TMDBService().fetchMovieDetails(movieId);
      setState(() {
        details = data;
      });
    } catch (e) {
      print('Error fetching details: $e');
    }
  }

  Future<void> fetchComments() async {
    final movieId = widget.item['id'].toString();
    final snapshot = await _firestore
        .collection('movies')
        .doc(movieId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      comments = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> submitRatingAndComment({
    required int rating,
    required String username,
    String? comment,
    String? note,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final movieId = widget.item['id'].toString();
    final data = {
      'userId': user.uid,
      'username': username,
      'rating': rating,
      'comment': comment ?? '',
      'note': note ?? '',
      'timestamp': FieldValue.serverTimestamp(),
      'movieTitle': widget.item['title'] ?? widget.item['name'] ?? 'Untitled',
    };

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('ratings')
        .doc(movieId)
        .set(data);

    if ((comment ?? '').isNotEmpty) {
      await _firestore
          .collection('movies')
          .doc(movieId)
          .collection('comments')
          .add(data);
    }

    fetchComments();
  }

  void _openRateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        int localRating = _selectedRating;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.black,
              title: Text("Rate & Comment", style: TextStyle(color: Colors.yellow)),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Your Rating", style: TextStyle(color: Colors.white)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final value = index + 1;
                        return IconButton(
                          icon: Icon(
                            Icons.star,
                            color: localRating >= value ? Colors.yellow : Colors.grey,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              localRating = value;
                              _selectedRating = value;
                            });
                          },
                        );
                      }),
                    ),
                    TextField(
                      controller: _nameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter your name (optional)",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextField(
                      controller: _commentController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Leave a comment (optional)",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextField(
                      controller: _notesController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Personal note (optional)",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (_selectedRating > 0) {
                      await submitRatingAndComment(
                        rating: _selectedRating,
                        username: _nameController.text.trim().isEmpty
                            ? 'Anonymous'
                            : _nameController.text.trim(),
                        comment: _commentController.text.trim(),
                        note: _notesController.text.trim(),
                      );
                      _nameController.clear();
                      _commentController.clear();
                      _notesController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Submit", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getGenres(Map<String, dynamic> data) {
    final genres = data['genres'] as List<dynamic>?;
    if (genres == null || genres.isEmpty) return '-';
    final firstTwo = genres.take(2).map((g) => g['name']).toList();
    return firstTwo.join(', ');
  }

  Widget _infoCard(String label, String value) {
    return Expanded(
      child: Container(
        height: 100,
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
            SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget buildCommentsList() {
    if (comments.isEmpty) {
      return Text("No comments yet.",
          style: TextStyle(color: Colors.grey[400], fontSize: 14));
    }

    return Column(
      children: comments.map((comment) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(comment['username'] ?? 'Anonymous',
                  style: TextStyle(
                      color: Colors.yellow, fontWeight: FontWeight.bold)),
              if ((comment['comment'] ?? '').isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(comment['comment'],
                      style: TextStyle(color: Colors.white)),
                ),
              if (comment['rating'] != null)
                Row(
                  children: List.generate(5, (index) {
                    return Icon(Icons.star,
                        size: 16,
                        color: index < comment['rating']
                            ? Colors.yellow
                            : Colors.grey);
                  }),
                )
            ],
          ),
        );
      }).toList(),
    );
  }

  Future<void> addToFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final movieId = widget.item['id'].toString();
    final favoritesRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(movieId);

    final snapshot = await favoritesRef.get();
    if (snapshot.exists) {
      await favoritesRef.delete();
      setState(() => isFavorite = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from favorites')),
      );
    } else {
      await favoritesRef.set({
        'id': movieId,
        'title': widget.item['title'] ?? widget.item['name'] ?? 'Untitled',
        'poster_path': widget.item['poster_path'] ?? '',
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() => isFavorite = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to favorites')),
      );
    }
  }

  Future<void> checkIfFavorite() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final movieId = widget.item['id'].toString();
    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(movieId)
        .get();

    setState(() {
      isFavorite = doc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.item['title'] ?? widget.item['name'] ?? 'No Title';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[850],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: details == null
          ? Center(child: CircularProgressIndicator(color: Colors.yellow))
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (details!['poster_path'] != null)
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w300${details!['poster_path']}',
                        height: 300,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: addToFavorites,
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.yellow : Colors.white,
                      ),
                      label: Text(
                        isFavorite ? "Added to Favorites" : "Add to Favorites",
                        style: TextStyle(color: isFavorite ? Colors.yellow : Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            Center(
              child: Text(title,
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                _infoCard("Genres", _getGenres(details!)),
                _infoCard("Runtime", "${details!['runtime'] ?? '-'} min"),
                _infoCard("Rating", "${details!['vote_average'] ?? '-'} / 10"),
              ],
            ),
            SizedBox(height: 20),
            Text("Overview",
                style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(details!['overview'] ?? '',
                style: TextStyle(color: Colors.white)),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _openRateDialog,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black),
                child: Text("Rate / Comment"),
              ),
            ),
            SizedBox(height: 30),
            Text("Comments",
                style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            buildCommentsList(),
          ],
        ),
      ),
    );
  }
}