import 'package:campusalert/CrimeHeatMap.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:campusalert/api_config.dart';

class AdminPost extends StatefulWidget {
  @override
  _AdminPostState createState() => _AdminPostState();
}

class _AdminPostState extends State<AdminPost> {
  List<dynamic> posts = []; // List to store the fetched posts
  List<String> filterCriteria = []; // List to store filter criteria options
  List<String> selectedCriteria = []; // Selected filter criteria

  // Base URL of your Django backend
  final String baseUrl = ApiConfig.baseUrl;  // Adjust the IP address and port as necessary


  @override
  void initState() {
    super.initState();
    fetchPosts(); // Fetch posts when the widget is initialized
  }

  Future<void> fetchPosts() async {
  const String baseUrl = ApiConfig.baseUrl; // Assuming cc.apiBaseUrl is a valid base URL

  // Construct the complete URL
  const String url = '$baseUrl/adminPost/api/posts/';

  // Make the HTTP GET request
  final response = await http.get(Uri.parse(url));
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
        title: Text('Campus Crime Count'),
        actions: [
          // Add a button on the top banner to navigate to the CrimeHeatMapPage
    IconButton(
      icon: Icon(Icons.insert_chart),
     
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CrimeHeatMap()),
        );

            },
          ),
        ],
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
              if (post['crime'] != null) Text(post['crime']),
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