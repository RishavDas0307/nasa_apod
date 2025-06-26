import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'authProvider.dart' as custom_auth_provider;
import 'auth.dart';
import 'theme_provider.dart';
import 'cosmos_card.dart'; // Import the CosmosCard widget

class Home extends StatefulWidget {
  final String username;
  final ScrollController scrollController;

  const Home({super.key, required this.username, required this.scrollController});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<Map<String, dynamic>> _last7DaysData = [];
  bool _isLoading = true;
  List<bool> _expandedStates = [];
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );
    _fetchLast7DaysPictures();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _fetchLast7DaysPictures() async {
    setState(() => _isLoading = true);

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

    _fadeController.forward();
  }

  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final comparisonDate = DateTime(date.year, date.month, date.day);

    if (comparisonDate == today) {
      return 'Today';
    } else if (comparisonDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd, EEEE').format(date);
    }
  }

  Widget _buildMainHeaderContent() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 48, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '👋 Hello, ${widget.username}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.onPrimary.withOpacity(0.95),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colors.surface.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withOpacity(0.06),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(
                color: colors.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.logout_rounded, size: 20),
              onPressed: () => _showSignOutDialog(),
              color: colors.onSurface.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverCosmosBoxContent() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors.accent.withOpacity(0.08),
              colors.accent.withOpacity(0.12),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colors.accent.withOpacity(0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.accent.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.auto_awesome,
                color: colors.accent,
                size: 18,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                'Discover the cosmos with NASA\'s daily astronomy pictures',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.accent,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final colors = themeProvider.colors;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colors.surface.withOpacity(0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Sign Out',
            style: TextStyle(color: colors.onSurface),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: colors.onSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final authProvider = Provider.of<custom_auth_provider.AuthProvider>(context, listen: false);
                await authProvider.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => SignInPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.error.withOpacity(0.9),
                foregroundColor: colors.onError,
                elevation: 2,
              ),
              child: Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(Map<String, dynamic> data, int index) {
    return CosmosCard(
      data: data,
      isExpanded: _expandedStates[index],
      onToggleExpand: () {
        setState(() {
          _expandedStates[index] = !_expandedStates[index];
        });
      },
      onFavoritePressed: () {
        // Implement your favorite logic here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added to favorites!'),
            duration: Duration(seconds: 2),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors;

    return Scaffold(
      backgroundColor: colors.primary,
      body: _isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: colors.accent,
            ),
            SizedBox(height: 20),
            Text(
              '🌒 Loading the Cosmos 🌖...',
              style: TextStyle(
                color: colors.onSurfaceVariant.withOpacity(0.8),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildMainHeaderContent(),
                  _buildDiscoverCosmosBoxContent(),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return _buildCard(_last7DaysData[index], index);
                },
                childCount: _last7DaysData.length,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: 80),
            ),
          ],
        ),
      ),
    );
  }
}