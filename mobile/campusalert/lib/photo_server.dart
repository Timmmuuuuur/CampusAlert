import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhotoServer {
  static const String baseUrl = 'https://your-photo-server.com/api/photos';

  // Function to fetch photos from the server
  Future<List<String>> fetchPhotos() async {
    List<String> photoUrls = [];

    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Assuming the response contains a list of photo URLs
        if (data is List) {
          photoUrls = List<String>.from(data);
        }
      } else {
        // Handle error if the request fails
        throw Exception('Failed to load photos');
      }
    } catch (error) {
      // Handle any exceptions that occur during the HTTP request
      print('Error fetching photos: $error');
    }

    return photoUrls;
  }

  // Function to display photos fetched from the server
  Widget displayPhotos(List<String> photoUrls) {
    return ListView.builder(
      itemCount: photoUrls.length,
      itemBuilder: (context, index) {
        return Image.network(
          photoUrls[index],
          fit: BoxFit.cover, // Adjust the image fit as needed
        );
      },
    );
  }
}
