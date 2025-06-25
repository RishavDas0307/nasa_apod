import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authProvider.dart' as custom_auth_provider;

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<custom_auth_provider.AuthProvider>(context, listen: false)
          .fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<custom_auth_provider.AuthProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Cleaner header with better spacing
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Favorites',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode ? Colors.white : Colors.grey[900],
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${authProvider.favorites.length} images',
                        style: TextStyle(
                          fontSize: 15,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // Cleaner toggle button
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _isGridView = !_isGridView;
                        });
                      },
                      tooltip: _isGridView ? 'List View' : 'Grid View',
                    ),
                  ),
                ],
              ),
            ),

            // Content section
            Expanded(
              child: authProvider.favorites.isEmpty
                  ? _buildEmptyState()
                  : _isGridView
                  ? _buildImprovedGrid(authProvider)
                  : _buildImprovedList(authProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border_rounded,
              size: 50,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start saving your favorite images\nto see them here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImprovedGrid(custom_auth_provider.AuthProvider authProvider) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        padding: EdgeInsets.only(bottom: 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85, // Better aspect ratio
        ),
        itemCount: authProvider.favorites.length,
        itemBuilder: (context, index) {
          final favorite = authProvider.favorites[index];
          return _buildGridItem(favorite, authProvider, isDarkMode);
        },
      ),
    );
  }

  Widget _buildGridItem(String favorite, custom_auth_provider.AuthProvider authProvider, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? Colors.black : Colors.black).withOpacity(isDarkMode ? 0.3 : 0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image with better proportions
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  favorite,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDarkMode ? Colors.blue[400]! : Colors.blue[600]!,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                      child: Icon(
                        Icons.broken_image_rounded,
                        size: 32,
                        color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Action buttons only - cleaner design
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.share_rounded,
                    color: isDarkMode ? Colors.grey[300]! : Colors.grey[700]!,
                    backgroundColor: isDarkMode ? Colors.grey[800]! : Colors.grey[100]!,
                    onTap: () {
                      // Add share functionality
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.delete_outline_rounded,
                    color: isDarkMode ? Colors.red[400]! : Colors.red[600]!,
                    backgroundColor: isDarkMode ? Colors.red[900]!.withOpacity(0.2) : Colors.red[50]!,
                    onTap: () async {
                      await _showDeleteConfirmation(context, authProvider, favorite);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: color,
        ),
      ),
    );
  }

  Widget _buildImprovedList(custom_auth_provider.AuthProvider authProvider) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 20),
        itemCount: authProvider.favorites.length,
        itemBuilder: (context, index) {
          final favorite = authProvider.favorites[index];
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDarkMode ? Colors.black : Colors.black).withOpacity(isDarkMode ? 0.3 : 0.06),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Image with better proportions
                Container(
                  height: 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    child: Image.network(
                      favorite,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDarkMode ? Colors.blue[400]! : Colors.blue[600]!,
                              ),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                          child: Icon(
                            Icons.broken_image_rounded,
                            size: 50,
                            color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Bottom section with cleaner layout
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Favorite Image',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode ? Colors.white : Colors.grey[900],
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Saved on ${_formatDate(DateTime.now())}',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Action buttons with better spacing
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.share_rounded,
                                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                                size: 20,
                              ),
                              onPressed: () {
                                // Add share functionality
                              },
                              tooltip: 'Share',
                            ),
                          ),
                          SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.red[900]?.withOpacity(0.2) : Colors.red[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: isDarkMode ? Colors.red[400] : Colors.red[600],
                                size: 20,
                              ),
                              onPressed: () async {
                                await _showDeleteConfirmation(context, authProvider, favorite);
                              },
                              tooltip: 'Remove from favorites',
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
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _showDeleteConfirmation(
      BuildContext context,
      custom_auth_provider.AuthProvider authProvider,
      String favorite,
      ) async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Remove from Favorites?',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            'This image will be removed from your favorites list.',
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.red[600] : Colors.red[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                'Remove',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                await authProvider.removeFavorite(favorite);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}