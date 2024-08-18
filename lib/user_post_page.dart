import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserPostsPage extends StatefulWidget {
  const UserPostsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserPostsPageState createState() => _UserPostsPageState();
}

class _UserPostsPageState extends State<UserPostsPage> {
  List posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=e332b11c23d64f4d93d86aff90eb1442'));
    if (response.statusCode == 200) {
      setState(() {
        // Access the 'articles' list from the response
        posts = json.decode(response.body)['articles'];
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Posts'),
      ),
      body: posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: ListTile(
                    title: Text(posts[index]['author'] ?? "Unknown Author"),
                    subtitle: Text(posts[index]['title'] ?? "No Title"),
                  ),
                );
              },
            ),
    );
  }
}
