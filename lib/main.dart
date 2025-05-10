import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 190),
            Text(
              'WELCOME',
              style: TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            SizedBox(height: 70),

            Column(
              children: [
                Icon(Icons.comment, size: 40, color: Colors.yellow),
                SizedBox(height: 8),
                Text(
                  'Share your thoughts about movies with others',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            Column(
              children: [
                Icon(Icons.star, size: 40, color: Colors.yellow),
                SizedBox(height: 8),
                Text(
                  'Rate the films and let others benefit from them.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            Column(
              children: [
                Icon(Icons.note, size: 40, color: Colors.yellow),
                SizedBox(height: 8),
                Text(
                  'Take private notes and access them whenever you want',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 60),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: Text(
                'Start Exploring',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 96, 95, 95),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CineNoteSignInPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                backgroundColor: const Color.fromARGB(255, 232, 231, 231),
                foregroundColor: Colors.black,
                minimumSize: Size(200, 60),
              ),
              child: Text('Sign in with CineNote'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoogleSignInPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                backgroundColor: const Color.fromARGB(255, 232, 231, 231),
                foregroundColor: Colors.black,
                minimumSize: Size(200, 60),
              ),
              child: Text('Sign in with Google'),
            ),
            SizedBox(height: 40),
            Text(
              'OR',
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 15,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateAccountPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                minimumSize: Size(200, 60),
              ),
              child: Text('Create an account'),
            ),
            SizedBox(height: 15),
            Text(
              'By signing in, you agree to Condition of Use and Privacy Policy of CineNote.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign in with Google',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),

        backgroundColor: const Color.fromARGB(255, 96, 95, 95),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'G-mail',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.yellow,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.yellow,
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CineNoteSignInPage extends StatefulWidget {
  @override
  _CineNoteSignInPageState createState() => _CineNoteSignInPageState();
}

class _CineNoteSignInPageState extends State<CineNoteSignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  void _signIn() async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signed in successfully!')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Sign in failed.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign in with CineNote',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 96, 95, 95),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'E-mail',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.yellow,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.yellow,
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            ElevatedButton(onPressed: _signIn, child: Text('Sign in')),
          ],
        ),
      ),
    );
  }
}

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  void _createAccount() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords do not match.")));
      return;
    }

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Account created successfully!")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CineNoteSignInPage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "An unknown error occurred!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an Account', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 96, 95, 95),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                hintText: 'First Name',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.yellow,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                hintText: 'Last Name',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.yellow,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'E-mail',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.yellow,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.yellow,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                hintStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.yellow,
              ),
            ),
            SizedBox(height: 80),
            ElevatedButton(
              onPressed: _createAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> itemsFuture;
  List<Map<String, dynamic>> searchResults = [];
  String searchQuery = '';

  void searchMoviesAndTvShows(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    final movieResults = await TMDBService().searchMovies(query);
    final tvResults = await TMDBService().searchTvShows(query);
    final combinedResults = [...movieResults, ...tvResults];
    setState(() {
      searchResults = combinedResults;
    });
  }

  @override
  void initState() {
    super.initState();
    itemsFuture = TMDBService().fetchRandomMoviesAndTVShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Home Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.yellow),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No data found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final items = snapshot.data!;
            final movies = items.sublist(0, 10);
            final tvShows = items.sublist(10, 20);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: TextField(
                      onChanged: (value) {
                        searchMoviesAndTvShows(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search movies...',
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 60, 60, 60),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 202, 201, 201),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),

                  if (searchResults.isNotEmpty)
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 202, 201, 201),
                        border: Border.all(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.separated(
                        itemCount: searchResults.length,
                        separatorBuilder:
                            (context, index) =>
                                Divider(color: Colors.grey, thickness: 1),
                        itemBuilder: (context, index) {
                          final movie = searchResults[index];
                          final title =
                              movie['title'] ?? movie['name'] ?? 'No Title';
                          final posterPath = movie['poster_path'];

                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailsPage(item: movie),
                                ),
                              );
                            },
                            leading:
                                posterPath != null
                                    ? Image.network(
                                      'https://image.tmdb.org/t/p/w200$posterPath',
                                      width: 50,
                                      height: 75,
                                      fit: BoxFit.cover,
                                    )
                                    : Container(
                                      width: 50,
                                      height: 75,
                                      color: Colors.grey,
                                    ),
                            title: Text(
                              title,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        },
                      ),
                    ),

                  SizedBox(height: 40),
                  Text(
                    'Movies',
                    style: TextStyle(color: Colors.yellow, fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            movies.map((movie) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DetailsPage(
                                              item: movie,
                                            ), 
                                      ),
                                    );
                                  },
                                  child:
                                      movie['poster_path'] != null
                                          ? Image.network(
                                            'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                                            width: 94,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          )
                                          : Container(
                                            width: 94,
                                            height: 150,
                                            color: Colors.grey,
                                          ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),
                  Text(
                    'Series',
                    style: TextStyle(color: Colors.yellow, fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            tvShows.map((show) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => DetailsPage(
                                              item: show,
                                            ), 
                                      ),
                                    );
                                  },
                                  child:
                                      show['poster_path'] != null
                                          ? Image.network(
                                            'https://image.tmdb.org/t/p/w200${show['poster_path']}',
                                            width: 94,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          )
                                          : Container(
                                            width: 94,
                                            height: 150,
                                            color: Colors.grey,
                                          ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const DetailsPage({Key? key, required this.item}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Map<String, dynamic>? details;
  Map<int, String> notesByMovieId = {};
  Map<int, int> ratingByMovieId = {};
  List<Map<String, String>> _comments = [];
  final TextEditingController _commentController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  int _selectedRating = 0;

  List<Map<String, String>> comments = [];

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  void fetchDetails() async {
    try {
      final data = await TMDBService().fetchMovieDetails(widget.item['id']);
      setState(() {
        details = data;
      });
    } catch (e) {}
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
      body:
          details == null
              ? Center(child: CircularProgressIndicator(color: Colors.yellow))
              : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (details!['poster_path'] != null)
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w300${details!['poster_path']}',
                            height: 300,
                          ),
                        ),
                      ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        widget.item['title'] ??
                            widget.item['name'] ??
                            'No Title',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _infoCard("Genres", _getGenres(details!)),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _infoCard(
                            "Runtime",
                            "${details!['runtime'] ?? '-'} min",
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _infoCard(
                            "Rating",
                            "${details!['vote_average'] ?? '-'} / 10",
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _infoCard(
                            "Release",
                            "${details!['release_date'] ?? '-'}",
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),
                    Text(
                      "Overview",
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      details!['overview'] ?? '-',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              onPressed: _openNotesDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[700],
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                "Notes",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              onPressed: _openRateDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[700],
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                "Rate",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ElevatedButton(
                              onPressed: _openCommentDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[700],
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                "Add Comment",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Comments",
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    buildCommentsList(comments),
                  ],
                ),
              ),
    );
  }

  void _openNotesDialog() {
    

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text("Notes", style: TextStyle(color: Colors.yellow)),
          content: SizedBox(
            width: 300,
            height: 130,
            child: TextField(
              controller: _notesController,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Write your notes here...",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final note = _notesController.text.trim();
                final movieId = widget.item['id'];

                if (note.isNotEmpty) {
                  setState(() {
                    notesByMovieId[movieId] = note;
                  });
                }
                Navigator.pop(context);
              },
              child: Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _openRateDialog() {
    double _rating = 0.0;
    

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Column(
            children: [
              if (details!['poster_path'] != null)
                Image.network(
                  'https://image.tmdb.org/t/p/w200${details!['poster_path']}',
                  height: 150,
                ),
              SizedBox(height: 10),
              Text(
                widget.item['title'] ?? widget.item['name'] ?? 'No Title',
                style: TextStyle(color: Colors.yellow),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Rate", style: TextStyle(color: Colors.white)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      int ratingValue = index + 1;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedRating = ratingValue;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _selectedRating == ratingValue
                                    ? Colors.yellow
                                    : Colors.grey[700],
                            foregroundColor: Colors.black,
                            minimumSize: Size(32, 32),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            "$ratingValue",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_selectedRating > 0) {
                  final movieId = widget.item['id'];

                  setState(() {
                    ratingByMovieId[movieId] = _selectedRating;
                  });

                  Navigator.pop(context);
                }
              },
              child: Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _openCommentDialog() {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _commentInputController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text("Add Comment", style: TextStyle(color: Colors.yellow)),
          content: SizedBox(
            width: 300,
            height: 180,
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Your name",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: TextField(
                    controller: _commentInputController,
                    maxLines: null,
                    expands: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type your comment here...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final text = _commentInputController.text.trim();
                if (name.isNotEmpty && text.isNotEmpty) {
                  setState(() {
                    comments.add({'name': name, 'comment': text});
                  });
                }
                Navigator.pop(context);
              },
              child: Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  TextStyle _text() => TextStyle(color: Colors.white, fontSize: 16);
  TextStyle _label() => TextStyle(
    color: Colors.yellow,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  String _getGenres(Map<String, dynamic> data) {
    final genres = data['genres'] as List<dynamic>?;
    if (genres == null || genres.isEmpty) return '-';

    final firstTwo = genres.take(2).map((g) => g['name']).toList();
    return firstTwo.join(', ');
  }

  Widget _infoCard(String label, String value) {
    return Container(
      width: 150,
      height: 120,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildCommentsList(List<Map<String, String>> comments) {
  return Column(
    children:
        comments
            .map(
              (comment) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment['name'] ?? 'Anonymous',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        comment['comment']?.isNotEmpty == true
                            ? comment['comment']!
                            : "No comment",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
  );
}
