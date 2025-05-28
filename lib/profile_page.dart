import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'details_page.dart';
import 'theme.dart';
import 'main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String username = '', bio = '', imageUrl = '', email = '', joinedDate = '';
  List<Map<String, dynamic>> userRatings = [];
  List<Map<String, dynamic>> userFavorites = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadUserRatings();
    _loadFavorites();
  }

  Future<void> _loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    setState(() {
      username = data['username'] ?? '';
      bio = data['bio'] ?? '';
      imageUrl = data['imageUrl'] ?? '';
      email = user.email ?? '';
      joinedDate = user.metadata.creationTime?.toLocal().toString().split(' ').first ?? '';
    });
  }

  Future<void> _loadUserRatings() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('ratings')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      userRatings = snapshot.docs.map((doc) {
        final data = doc.data();
        data['movieId'] = doc.id;
        return data;
      }).toList();
    });
  }

  Widget buildUserRatingsList() {
    if (userRatings.isEmpty) {
      return Text("No ratings yet.", style: TextStyle(color: Colors.grey[400]));
    }

    return Column(
      children: userRatings.map((rating) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailsPage(item: {
                  'id': rating['movieId'],
                  'title': rating['movieTitle'] ?? 'Untitled',
                }),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Color.fromARGB(50, 255, 235, 59),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rating['movieTitle'] ?? 'Untitled',
                  style: TextStyle(color: isDarkMode ? Colors.yellow : Colors.black, fontWeight: FontWeight.bold),
                ),
                if ((rating['comment'] ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(rating['comment'], style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                  ),
                if ((rating['note'] ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text("Note: ${rating['note']}", style: TextStyle(color: isDarkMode ? Colors.white70: Colors.grey[850])),
                  ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(Icons.star, size: 16, color: index < rating['rating'] ? Colors.yellow : Colors.grey);
                  }),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      userFavorites = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Widget buildFavoritesList() {
    if (userFavorites.isEmpty) {
      return Text("No favorites yet.", style: TextStyle(color: Colors.grey[400]));
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: userFavorites.length,
        itemBuilder: (context, index) {
          final item = userFavorites[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailsPage(item: {
                    'id': item['id'],
                    'title': item['title'],
                    'poster_path': item['poster_path'],
                  }),
                ),
              );
            },
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: item['poster_path'] != null && item['poster_path'].isNotEmpty
                        ? Image.network(
                      'https://image.tmdb.org/t/p/w200${item['poster_path']}',
                      width: 100,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 100,
                      height: 150,
                      color: Colors.grey,
                      child: Icon(Icons.movie, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['title'] ?? 'Untitled',
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatar = imageUrl.isNotEmpty
        ? NetworkImage(imageUrl)
        : const AssetImage("assets/default_avatar.png") as ImageProvider;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.yellow,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 40, backgroundImage: avatar),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(username, style: TextStyle(fontSize: 20, color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                        Text("Joined: $joinedDate", style: const TextStyle(color: Colors.grey)),
                        if (bio.isNotEmpty) Text(bio, style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.yellow),
                    onPressed: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfilePage()),
                      );
                      if (updated == true) {
                        _loadProfile();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Profile updated successfully!")),
                        );
                      }
                    },
                  ),

                ],
              ),
              const SizedBox(height: 30),
              Divider(color: isDarkMode ? Colors.white24 : Colors.grey),
              Text("Your Ratings", style: TextStyle(color: isDarkMode ? Colors.yellow : Colors.black)),
              const SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: buildUserRatingsList(),
                ),
              ),
              const SizedBox(height: 20),

              Divider(color: isDarkMode ? Colors.white24 : Colors.grey),
              Text("Your Favorites", style: TextStyle(color: isDarkMode ? Colors.yellow : Colors.black)),
              const SizedBox(height: 10),
              buildFavoritesList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _existingImageUrl;

  final List<String> avatarUrls = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREMoAJNQpNQ2_VPXj3OBSq9z65XJTTk9GMWQ&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFjH5Jcu1OE0y0bGEG4wyRRdKpkgQn4n5PeQ&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGdR6DmPQmnd2gaFTh4dgujlS_y6L1X2Th3A&s',
    'https://kb.rspca.org.au/wp-content/uploads/2024/01/ferret-close-up.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _emailController.text = user.email ?? '';
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      _usernameController.text = data['username'] ?? '';
      _bioController.text = data['bio'] ?? '';
      _existingImageUrl = data['imageUrl'];
    }
  }

  Future<void> _saveChanges() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      if (_emailController.text.trim() != user.email) {
        await user.verifyBeforeUpdateEmail(_emailController.text.trim());
      }

      if (_newPasswordController.text.isNotEmpty) {
        if (_newPasswordController.text != _confirmPasswordController.text) {
          _showSnackBar("Passwords do not match.");
          return;
        }
        await user.updatePassword(_newPasswordController.text.trim());
      }

      await _firestore.collection('users').doc(user.uid).set({
        'username': _usernameController.text.trim(),
        'bio': _bioController.text.trim(),
        'imageUrl': _existingImageUrl,
        'email': _emailController.text.trim(),
      }, SetOptions(merge: true));

      Navigator.pop(context, true);
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? "Error.");
    }
  }

  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color.fromARGB(255, 30, 30, 30) : Colors.white,
        title: Text("Select Avatar", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        content: SingleChildScrollView(
          child: Column(
            children: avatarUrls.map((url) => GestureDetector(
              onTap: () {
                _saveSelectedAvatar(url);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(url),
                  child: _existingImageUrl == url
                      ? const Icon(Icons.check_circle, color: Colors.yellow, size: 20)
                      : null,
                ),
              ),
            )).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _saveSelectedAvatar(String avatarUrl) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({'imageUrl': avatarUrl}, SetOptions(merge: true));
    setState(() => _existingImageUrl = avatarUrl);
    _showSnackBar("Profile picture updated!");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _existingImageUrl != null
        ? NetworkImage(_existingImageUrl!)
        : const AssetImage("assets/default_avatar.png") as ImageProvider;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(color: isDarkMode ? Colors.white: Colors.black)),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.yellow,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showAvatarSelectionDialog,
              child: CircleAvatar(radius: 50, backgroundImage: imageProvider),
            ),
            TextButton(
              onPressed: _showAvatarSelectionDialog,
              child: Text("Change Image", style: TextStyle(color: isDarkMode? Colors.yellow: Colors.black)),
            ),
            ...[
              _buildInput("Username", _usernameController),
              _buildInput("Bio", _bioController),
              _buildInput("Email", _emailController),
              const Divider(color: Colors.white24, height: 40),
              Text("Change Password", style: TextStyle(color: isDarkMode? Colors.yellow : Colors.black, fontWeight: FontWeight.bold)),
              _buildInput("New Password", _newPasswordController, obscure: true),
              _buildInput("Confirm Password", _confirmPasswordController, obscure: true),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dark Mode",
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
                Switch(
                  value: isDarkMode,
                  activeColor: Colors.yellow,
                  onChanged: (bool value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDarkMode ? Colors.grey : Colors.black),
          filled: true,
          fillColor: isDarkMode ? const Color.fromARGB(255, 35, 35, 35) : Color.fromARGB(50, 255, 235, 59),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}