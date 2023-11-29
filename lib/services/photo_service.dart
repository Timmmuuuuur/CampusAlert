import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchPhotos(String latitude, String longitude, String buildingId, String floorId) async {
  // Construct the URL with query parameters
  //*     ##########   replace field below   ########         *//
  final Uri uri = Uri.parse('https://your-django-backend.com/get_all_photos') //replace with the actual URL of your Django backend endpoint for get_all_photos
      .replace(queryParameters: {
    'latitude': latitude,
    'longitude': longitude,
    'building_id': buildingId,
    'floor_id': floorId,
  });

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON response
      // Assuming the response is in JSON format
      return jsonDecode(response.body);
    } else {
      // If the server returns an error response, throw an exception or handle it accordingly
      throw Exception('Failed to fetch photos: ${response.statusCode}');
    }
  } catch (error) {
    // Handle network or other errors here
    print('Error fetching photos: $error');
    return [];
  }
}

void main() {
  // Example usage:
  fetchPhotos('12.34', '56.78', '1', '2')
      .then((photos) {
    // Handle retrieved photos here
    print('Retrieved photos: $photos');
  })
      .catchError((error) {
    // Handle errors here
    print('Error: $error');
  });
  // Other app setup and code
}
