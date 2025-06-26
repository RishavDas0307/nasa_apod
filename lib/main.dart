import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'ProfilePage.dart';
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
                  theme: themeProvider.lightTheme,
                  darkTheme: themeProvider.darkTheme,
                  themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  home: authProvider.user == null
                      ? SignInPage()
                      : MainPage(
                    username: authProvider.user?.displayName ?? 'User',
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

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final List<Widget> _pages;
  late final List<AnimationController> _controllers;
  late ScrollController _homeScrollController;
  bool _showScrollToTopButton = false;


  @override
  void initState() {
    super.initState();
    _homeScrollController = ScrollController();
    _homeScrollController.addListener(_scrollListener);

    _pages = [
      Home(username: widget.username, scrollController: _homeScrollController),
      Search(),
      FavoritesPage(),
      ProfilePage(),
    ];
    _controllers = List.generate(
      _pages.length,
          (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
        lowerBound: 0.0,
        upperBound: 1.0,
      ),
    );
    _controllers[_currentIndex].forward();
  }

  void _scrollListener() {
    if (_currentIndex == 0) {
      if (_homeScrollController.offset >= 200 && !_showScrollToTopButton) {
        setState(() {
          _showScrollToTopButton = true;
        });
      } else if (_homeScrollController.offset < 200 && _showScrollToTopButton) {
        setState(() {
          _showScrollToTopButton = false;
        });
      }
    } else {
      if (_showScrollToTopButton) {
        setState(() {
          _showScrollToTopButton = false;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index) return;

    // Store the previous index
    int previousIndex = _currentIndex;

    setState(() {
      _currentIndex = index;
      if (_currentIndex != 0) {
        // Reset scroll position and button when leaving home
        if (_homeScrollController.hasClients) {
          _homeScrollController.jumpTo(0);
        }
        _showScrollToTopButton = false;
      }
    });

    // Handle animations
    _controllers[previousIndex].reverse();
    _controllers[index].forward();
  }

  Widget _buildNavIcon(IconData icon, int index, AppColorScheme colors) {
    bool isSelected = index == _currentIndex;

    return AnimatedBuilder(
      animation: _controllers[index],
      builder: (context, child) {
        return Transform.scale(
          scale: 0.9 + (_controllers[index].value * 0.2), // Scale from 0.9 to 1.1
          child: IconButton(
            onPressed: () => _onItemTapped(index),
            icon: Icon(
              icon,
              color: isSelected ? colors.accent : colors.onSurfaceVariant,
              size: 26,
            ),
            splashRadius: 24,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _homeScrollController.removeListener(_scrollListener);
    _homeScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final AppColorScheme colors = themeProvider.colors;

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        extendBody: true,
        body: _pages[_currentIndex],
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: colors.surfaceElevated.withOpacity(0.9),
                borderRadius: BorderRadius.circular(27),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavIcon(Icons.home, 0, colors),
                  _buildNavIcon(Icons.search, 1, colors),
                  _buildNavIcon(Icons.favorite, 2, colors),
                  _buildNavIcon(Icons.person, 3, colors),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (_currentIndex == 0)
              AnimatedOpacity(
                opacity: _showScrollToTopButton ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: FloatingActionButton(
                    heroTag: "scrollToTopBtn",
                    onPressed: () {
                      if (_homeScrollController.hasClients) {
                        _homeScrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    backgroundColor: colors.accent,
                    foregroundColor: colors.onButtonPrimary,
                    child: const Icon(Icons.arrow_upward),
                  ),
                ),
              ),
            FloatingActionButton(
              heroTag: "themeToggleBtn",
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
              tooltip: 'Toggle Theme',
              backgroundColor: colors.accent,
              child: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                color: Colors.white,
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}