import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'authProvider.dart' as custom_auth_provider;
import 'auth.dart';
import 'cosmos_card.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _dateController = TextEditingController();
  Map<String, dynamic>? _searchedData;
  bool _isLoading = false;
  bool _isExpanded = false; // Track expansion state for CosmosCard

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
          _isExpanded = false; // Reset expansion state when new data is loaded
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

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Future<void> _handleFavorite() async {
    final authProvider = Provider.of<custom_auth_provider.AuthProvider>(context, listen: false);

    if (authProvider.user == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    } else {
      if (_searchedData != null) {
        await authProvider.addFavorite(_searchedData!['url']);
        await authProvider.fetchFavorites();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favorites!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
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
                children: [
                  CosmosCard(
                    data: _searchedData!,
                    isExpanded: _isExpanded,
                    onToggleExpand: _toggleExpansion,
                    onFavoritePressed: _handleFavorite,
                  ),
                ],
              )
                  : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 64,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Select a date to explore NASA\'s\nAstronomy Picture of the Day',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}