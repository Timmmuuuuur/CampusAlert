// Service class for fetching data
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:campusalert/api_config.dart';
import 'package:campusalert/emergency_alert_page.dart';
import 'package:provider/provider.dart';


class Alarm {
  final String baseUrl = ApiConfig.baseUrl;

  Future<String> fetchData() async {
    final response = await http.get(Uri.parse('$baseUrl/low_late/api'));
    if (response.statusCode == 200) {
      return response.body; // Return response body
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}


// Provider for managing state
final alarmProvider = Provider<Alarm>((ref) => Alarm());


// Widget listening to API events
class DataListenerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final alarmService = context.read(alarmProvider);
    
    // Initiate data fetching when widget builds
    Future<String> fetchData() async {
      return await alarmService.fetchData(); // Return response data
    }
    
    // Run fetchData() when the widget is built
    final futureData = fetchData(); // Assign the future to a variable
    
    return FutureBuilder<String>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Display loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Display error message if fetching data fails
        } else {
          final responseData = snapshot.data; // Access the fetched data
          return EmergencyAlertPage(responseData: responseData); // Pass the fetched data to the widget tree
        }
      },
    );
  }
}