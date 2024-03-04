import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CrimeHeatMap extends StatefulWidget {
  @override
  _CrimeHeatMapState createState() => _CrimeHeatMapState();
}

class _CrimeHeatMapState extends State<CrimeHeatMap> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://10.31.18.0:8080/adminPost/api/building_crime/'));

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Color getColor(int crimeCount) {
    double opacity = 0.9;
    if (crimeCount == 0) {
      return const Color.fromARGB(255, 155, 211, 157).withOpacity(opacity);
    } else if (crimeCount <= 2) {
      return const Color.fromARGB(255, 240, 234, 176).withOpacity(opacity);
    } else {
      return const Color.fromARGB(255, 255, 139, 131).withOpacity(opacity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crime Heat Map'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // or 3
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          var item = data[index];
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
              color: getColor(item['crime_count_30_days']),
            ),
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item['building_name']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text('Crime in 30 Days: ${item['crime_count_30_days']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CrimeHeatMap(),
  ));
}
