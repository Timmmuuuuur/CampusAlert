import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPost extends StatefulWidget {
  @override
  _AdminPostState createState() => _AdminPostState();
}

class _AdminPostState extends State<AdminPost> {
  List<dynamic> posts = []; // List to store the fetched posts

  // Base URL of your Django backend
  final String baseUrl = 'http://10.31.18.0:8080'; // Adjust the IP address and port as necessary

  @override
  void initState() {
    super.initState();
    fetchPosts(); // Fetch posts when the widget is initialized
  }

  Future<void> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/adminPost/api/posts/'));
    if (response.statusCode == 200) {
      setState(() {
        posts = json.decode(response.body); // Parse the response JSON
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          var post = posts[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post['title'] != null)
                Text(
                  post['title'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              if (post['pub_date'] != null)
                Text('Posted on: ${post['pub_date']}'),
              if (post['content'] != null) Text(post['content']),
              if (post['photo_url'] != null)
                Image.network(
                  '$baseUrl${post['photo_url']}', // Include the base URL
                  fit: BoxFit.cover, // Ensure proper scaling
                ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}