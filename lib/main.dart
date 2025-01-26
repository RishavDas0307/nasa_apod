import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'auth.dart';
import 'home.dart';
import 'search.dart';
import 'authProvider.dart' as custom_auth_provider;
import 'theme_provider.dart';
import 'favorites.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return ChangeNotifierProvider(
            create: (_) => custom_auth_provider.AuthProvider(),
            child: Consumer<custom_auth_provider.AuthProvider>(
              builder: (context, authProvider, _) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: themeProvider.isDarkMode
                      ? ThemeData.dark().copyWith(
                    primaryColor: Colors.blueGrey,
                    scaffoldBackgroundColor: Colors.black,
                    appBarTheme: AppBarTheme(color: Colors.blueGrey),
                  )
                      : ThemeData.light().copyWith(
                    primaryColor: Colors.blue,
                    scaffoldBackgroundColor: Colors.white,
                    appBarTheme: AppBarTheme(color: Colors.blue),
                  ),
                  home: authProvider.user == null
                      ? SignInPage()
                      : MainPage(
                    username: authProvider.user?.displayName ?? 'Human',
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final String username;

  const MainPage({required this.username});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Home(),
    Search(),
    FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('👋🏼 Hello, ${widget.username}'),
              IconButton(
                icon: Icon(Icons.account_circle_sharp),
                onPressed: () async {
                  await Provider.of<custom_auth_provider.AuthProvider>(context, listen: false).logoutUser();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
          backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          tooltip: 'Toggle Theme',
          child: Icon(
            Theme.of(context).brightness == Brightness.dark
                ? Icons.dark_mode
                : Icons.light_mode,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}