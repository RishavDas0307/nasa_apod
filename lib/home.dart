import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> _last7DaysData = [];
  bool _isLoading = true;
  List<bool> _expandedStates = [];

  @override
  void initState() {
    super.initState();
    _fetchLast7DaysPictures();
  }

  Future<void> _fetchLast7DaysPictures() async {
    final apiKey = 'YfMdU7kzIWgdk1OIkGXbmrDfZOJhN3bmlTHOMlnj';
    final baseUrl = 'https://api.nasa.gov/planetary/apod';
    DateTime today = DateTime.now();

    List<Map<String, dynamic>> fetchedData = [];

    for (int i = 0; i < 7; i++) {
      final date = today.subtract(Duration(days: i));
      final formattedDate = DateFormat("yyyy-MM-dd").format(date);

      try {
        final response = await http.get(Uri.parse('$baseUrl?api_key=$apiKey&date=$formattedDate'));
        if (response.statusCode == 200) {
          fetchedData.add(jsonDecode(response.body));
        }
      } catch (e) {
        print('Error fetching data for date $formattedDate: $e');
      }
    }

    setState(() {
      _last7DaysData = fetchedData;
      _expandedStates = List<bool>.filled(fetchedData.length, false);
      _isLoading = false;
    });
  }

  Widget _buildCard(Map<String, dynamic> data, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              image: data['media_type'] == 'image'
                  ? DecorationImage(
                image: NetworkImage(data['url']),
                fit: BoxFit.cover,
              )
                  : null,
              color: data['media_type'] == 'video' ? Colors.black : null,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _expandedStates[index] = !_expandedStates[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data['title'] ?? 'No Title',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data['date'] ?? '',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          if (_expandedStates[index])
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data['explanation'] ?? '',
                style: TextStyle(fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NASA: APOD - Last 7 Days')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _last7DaysData.length,
        itemBuilder: (context, index) {
          final data = _last7DaysData[index];
          return _buildCard(data, index);
        },
      ),
    );
  }
}
