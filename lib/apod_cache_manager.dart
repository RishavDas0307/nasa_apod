import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApodCacheManager {
  static const String _apiKey = 'YfMdU7kzIWgdk1OIkGXbmrDfZOJhN3bmlTHOMlnj';
  static const String _baseUrl = 'https://api.nasa.gov/planetary/apod';
  static const String _cacheKeyPrefix = 'apod_data_';
  static const int _cacheDurationDays = 7; // Cache data for 7 days

  /// Fetches APOD data for a specific date from the API.
  Future<Map<String, dynamic>?> _fetchApodData(DateTime date) async {
    final formattedDate = DateFormat("yyyy-MM-dd").format(date);
    try {
      final response = await http.get(Uri.parse('$_baseUrl?api_key=$_apiKey&date=$formattedDate'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to load APOD for $formattedDate: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data for date $formattedDate: $e');
      return null;
    }
  }

  /// Saves a single APOD data entry to SharedPreferences.
  Future<void> _saveToCache(DateTime date, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final formattedDate = DateFormat("yyyy-MM-dd").format(date);
    await prefs.setString('$_cacheKeyPrefix$formattedDate', jsonEncode(data));
  }

  /// Loads a single APOD data entry from SharedPreferences.
  Future<Map<String, dynamic>?> _loadFromCache(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final formattedDate = DateFormat("yyyy-MM-dd").format(date);
    final String? cachedData = prefs.getString('$_cacheKeyPrefix$formattedDate');
    if (cachedData != null) {
      return jsonDecode(cachedData);
    }
    return null;
  }

  /// Fetches and caches the last 7 days of APOD data.
  /// It prioritizes cached data if available and not expired.
  /// Returns a list of fetched data.
  Future<List<Map<String, dynamic>>> fetchAndCacheLast7DaysData() async {
    final List<Map<String, dynamic>> fetchedData = [];
    DateTime today = DateTime.now();

    for (int i = 0; i < _cacheDurationDays; i++) {
      final date = today.subtract(Duration(days: i));
      Map<String, dynamic>? data = await _loadFromCache(date);

      if (data != null) {
        // Check if cached data is still fresh (e.g., within the last 24 hours, or simply use a flag if needed)
        // For simplicity, we'll assume if it's in cache, it's valid for this example's 7-day window.
        // In a real-world scenario, you might want to store a timestamp with the cached data.
        fetchedData.add(data);
      } else {
        // Data not in cache or expired, fetch from API
        data = await _fetchApodData(date);
        if (data != null) {
          await _saveToCache(date, data);
          fetchedData.add(data);
        }
      }
    }
    return fetchedData;
  }

  /// Clears all cached APOD data. (Optional, for debugging or specific scenarios)
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final Set<String> keys = prefs.getKeys();
    for (String key in keys) {
      if (key.startsWith(_cacheKeyPrefix)) {
        await prefs.remove(key);
      }
    }
    print('APOD cache cleared.');
  }
}