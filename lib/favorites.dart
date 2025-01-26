import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authProvider.dart' as custom_auth_provider;

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
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
    final authProvider =
    Provider.of<custom_auth_provider.AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: authProvider.favorites.isEmpty
          ? Center(child: Text('No favorites added yet.'))
          : ListView.builder(
        itemCount: authProvider.favorites.length,
        itemBuilder: (context, index) {
          final favorite = authProvider.favorites[index];
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            margin: EdgeInsets.all(8),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16)),
                    image: DecorationImage(
                      image: NetworkImage(favorite),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Favorite Image',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await authProvider.removeFavorite(favorite);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
