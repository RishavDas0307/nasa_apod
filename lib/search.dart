import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'authProvider.dart' as custom_auth_provider;
import 'auth.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _dateController = TextEditingController();
  Map<String, dynamic>? _searchedData;
  bool _isLoading = false;

  Future<void> _fetchNasaData(String date) async {
    setState(() {
      _isLoading = true;
    });

    final apiKey = 'YfMdU7kzIWgdk1OIkGXbmrDfZOJhN3bmlTHOMlnj';
    final url = 'https://api.nasa.gov/planetary/apod?api_key=$apiKey&date=$date';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _searchedData = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching data: ${response.statusCode}')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data.')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1995, 6, 16),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      _dateController.text = formattedDate;
      _fetchNasaData(formattedDate);
    }
  }

  Widget _buildCard(Map<String, dynamic> data) {
    final authProvider = Provider.of<custom_auth_provider.AuthProvider>(context, listen: false);

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data['title'] ?? 'No Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              data['date'] ?? '',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['explanation']?.substring(0, 50) ?? '',
                  style: TextStyle(fontSize: 14),
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.red),
                  onPressed: () async {
                    if (authProvider.user == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    } else {
                      await authProvider.addFavorite(data['url']);
                      await authProvider.fetchFavorites(); // Ensure the favorites are updated
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added to favorites!')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32), // Space for status bar
            Text(
              'Search',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                hintText: 'Tap to select a date',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _searchedData != null
                  ? ListView(
                children: [_buildCard(_searchedData!)],
              )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
