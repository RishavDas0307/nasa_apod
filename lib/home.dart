import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'authProvider.dart' as custom_auth_provider;
import 'auth.dart';
import 'theme_provider.dart'; // Import ThemeProvider

class Home extends StatefulWidget {
  final String username;

  const Home({super.key, required this.username});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<Map<String, dynamic>> _last7DaysData = [];
  bool _isLoading = true;
  List<bool> _expandedStates = [];
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late ScrollController _scrollController; // Declare ScrollController
  bool _showScrollToTopButton = false; // State for button visibility

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );
    _fetchLast7DaysPictures();

    _scrollController = ScrollController(); // Initialize ScrollController
    _scrollController.addListener(_scrollListener); // Add listener
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.removeListener(_scrollListener); // Remove listener
    _scrollController.dispose(); // Dispose controller
    super.dispose();
  }

  // Listener for scroll events
  void _scrollListener() {
    // Determine when to show/hide the scroll-to-top button
    if (_scrollController.offset >= 200 && !_showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = true;
      });
    } else if (_scrollController.offset < 200 && _showScrollToTopButton) {
      setState(() {
        _showScrollToTopButton = false;
      });
    }
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
      return DateFormat('MMM dd, EEEE').format(date); // Adjusted format
    }
  }

  // This widget builds the "Hello, user" row for the top header
  Widget _buildMainHeaderContent() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 48, 20, 0), // Adjust top padding for status bar and spacing
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

  // This widget builds the "Discover the cosmos..." box for SliverToBoxAdapter
  Widget _buildDiscoverCosmosBoxContent() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 24), // Padding around the box for spacing
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors;

    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.08),
            blurRadius: 16,
            offset: Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: colors.shadow.withOpacity(0.04),
            blurRadius: 6,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: colors.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(
                tag: 'image_${data['date']}',
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  child: data['media_type'] == 'image'
                      ? Image.network(
                    data['url'],
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 260,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.secondary.withOpacity(0.3),
                              colors.secondary.withOpacity(0.5),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                            color: colors.accent,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 260,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.errorContainer.withOpacity(0.4),
                              colors.errorContainer.withOpacity(0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: colors.onErrorContainer.withOpacity(0.8),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Failed to load image',
                                style: TextStyle(
                                  color: colors.onSurfaceVariant.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                      : Container(
                    height: 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colors.accent.withOpacity(0.8),
                          colors.accentVariant.withOpacity(0.8),
                          colors.accent.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colors.surfaceElevated.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.play_circle_outline, size: 64, color: colors.onSurface.withOpacity(0.9)),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Video Content',
                            style: TextStyle(
                              color: colors.onSurface.withOpacity(0.95),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Positioned for title and date (no gradient)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'] ?? 'No Title',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: colors.onPrimary.withOpacity(0.95),
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              color: colors.shadow.withOpacity(0.6),
                            ),
                          ],
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.surfaceElevated.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: colors.onPrimary.withOpacity(0.9)),
                            SizedBox(width: 6),
                            Text(
                              _formatDate(data['date'] ?? ''),
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.onPrimary.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Content below the image (only Read More/Less and favorite)
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Explanation Text with AnimatedSize for smooth expansion
                AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  child: Column(
                    children: [
                      if (_expandedStates[index]) // Only show explanation if expanded
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colors.outline.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            data['explanation'] ?? '',
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.7,
                              color: colors.onSurfaceVariant.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _expandedStates[index] = !_expandedStates[index];
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.buttonSecondary.withOpacity(0.08),
                              colors.buttonSecondary.withOpacity(0.12),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: colors.outline.withOpacity(0.25),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadow.withOpacity(0.08),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _expandedStates[index] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              size: 20,
                              color: colors.onSecondary.withOpacity(0.9),
                            ),
                            SizedBox(width: 8),
                            Text(
                              _expandedStates[index] ? 'Show Less' : 'Read More',
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.onSecondary.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
                        icon: Icon(Icons.favorite_border, size: 20),
                        onPressed: () {
                          // Implement favorite logic here
                        },
                        color: colors.onSurface.withOpacity(0.85),
                      ),
                    ),
                  ],
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = themeProvider.colors;

    return Scaffold(
      backgroundColor: colors.primary,
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: colors.accent,
        ),
      )
          : FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          controller: _scrollController, // Attach the scroll controller
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildMainHeaderContent(), // "Hello, username" row
                  _buildDiscoverCosmosBoxContent(), // "Discover the cosmos" box
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
      // Floating Action Button for "Scroll to Top"
      floatingActionButton: Padding( // Added Padding widget
        padding: const EdgeInsets.only(bottom: 70.0), // Adjust this value to move it up
        child: AnimatedOpacity(
          opacity: _showScrollToTopButton ? 1.0 : 0.0, // Control visibility with opacity
          duration: const Duration(milliseconds: 300), // Smooth transition
          child: FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                0, // Scroll to the top
                duration: const Duration(milliseconds: 500), // Animation duration
                curve: Curves.easeInOut, // Smooth curve
              );
            },
            backgroundColor: colors.accent, // Use accent color for button background
            foregroundColor: colors.onButtonPrimary, // Use onButtonPrimary for icon color
            child: const Icon(Icons.arrow_upward),
          ),
        ),
      ),
    );
  }
}
