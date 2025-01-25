import 'package:flutter/material.dart';
import 'home.dart';
import 'search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth.dart';

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
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode
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
      home: MainPage(isDarkMode: _isDarkMode, toggleTheme: _toggleTheme),
    );
  }
}

class MainPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const MainPage({required this.isDarkMode, required this.toggleTheme});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Home(),
    Search(),
    AuthPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.toggleTheme,
        backgroundColor: widget.isDarkMode ? Colors.blueGrey : Colors.blue,
        tooltip: 'Toggle Theme',
        child: Icon(
          widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Search'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Authentication'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 2; // Update index for AuthPage
                });
              },
            ),
          ],
        ),

      ),
    );
  }
}