import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify listeners to update the UI
  }

  // App Color Scheme
  AppColorScheme get colors => _isDarkMode ? _darkColors : _lightColors;

  // Light Theme Colors
  static const AppColorScheme _lightColors = AppColorScheme(
    // Backgrounds
    primary: Colors.white,
    secondary: Color(0xFFFAFAFA), // Colors.grey[50]
    tertiary: Color(0xFFF5F5F5), // Colors.grey[100]

    // Surfaces
    surface: Colors.white,
    surfaceElevated: Colors.white,
    surfaceContainer: Color(0xFFF5F5F5), // Colors.grey[100]

    // Text Colors
    onPrimary: Color(0xFF1A1A1A), // Colors.grey[900]
    onSecondary: Color(0xFF666666), // Colors.grey[600]
    onTertiary: Color(0xFF757575), // Colors.grey[600]
    onSurface: Color(0xFF1A1A1A), // Colors.grey[900]
    onSurfaceVariant: Color(0xFF666666), // Colors.grey[600]

    // Accent Colors
    accent: Color(0xFF2196F3), // Colors.blue[600]
    accentVariant: Color(0xFF1976D2), // Colors.blue[700]

    // Status Colors
    error: Color(0xFFD32F2F), // Colors.red[600]
    errorContainer: Color(0xFFFFEBEE), // Colors.red[50]
    onError: Colors.white,
    onErrorContainer: Color(0xFFD32F2F), // Colors.red[600]

    success: Color(0xFF388E3C), // Colors.green[600]
    successContainer: Color(0xFFE8F5E8), // Colors.green[50]
    onSuccess: Colors.white,
    onSuccessContainer: Color(0xFF388E3C), // Colors.green[600]

    warning: Color(0xFFF57C00), // Colors.orange[600]
    warningContainer: Color(0xFFFFF3E0), // Colors.orange[50]
    onWarning: Colors.white,
    onWarningContainer: Color(0xFFF57C00), // Colors.orange[600]

    // Interactive Elements
    divider: Color(0xFFE0E0E0), // Colors.grey[300]
    outline: Color(0xFFE0E0E0), // Colors.grey[300]
    shadow: Color(0x0F000000), // Black with 6% opacity

    // Button Colors
    buttonPrimary: Color(0xFF2196F3), // Colors.blue[600]
    buttonSecondary: Color(0xFFF5F5F5), // Colors.grey[100]
    onButtonPrimary: Colors.white,
    onButtonSecondary: Color(0xFF1A1A1A), // Colors.grey[900]
  );

  // Dark Theme Colors
  static const AppColorScheme _darkColors = AppColorScheme(
    // Backgrounds
    primary: Color(0xFF121212), // Colors.grey[900]
    secondary: Color(0xFF1E1E1E), // Colors.grey[850]
    tertiary: Color(0xFF2C2C2C), // Colors.grey[800]

    // Surfaces
    surface: Color(0xFF1E1E1E), // Colors.grey[850]
    surfaceElevated: Color(0xFF2C2C2C), // Colors.grey[800]
    surfaceContainer: Color(0xFF2C2C2C), // Colors.grey[800]

    // Text Colors
    onPrimary: Colors.white,
    onSecondary: Color(0xFFB0B0B0), // Colors.grey[400]
    onTertiary: Color(0xFFB0B0B0), // Colors.grey[400]
    onSurface: Colors.white,
    onSurfaceVariant: Color(0xFFB0B0B0), // Colors.grey[400]

    // Accent Colors
    accent: Color(0xFF64B5F6), // Colors.blue[300]
    accentVariant: Color(0xFF42A5F5), // Colors.blue[400]

    // Status Colors
    error: Color(0xFFEF5350), // Colors.red[400]
    errorContainer: Color(0x33B71C1C), // Colors.red[900] with 20% opacity
    onError: Colors.white,
    onErrorContainer: Color(0xFFEF5350), // Colors.red[400]

    success: Color(0xFF66BB6A), // Colors.green[400]
    successContainer: Color(0x332E7D32), // Colors.green[900] with 20% opacity
    onSuccess: Colors.white,
    onSuccessContainer: Color(0xFF66BB6A), // Colors.green[400]

    warning: Color(0xFFFFB74D), // Colors.orange[300]
    warningContainer: Color(0x33E65100), // Colors.orange[900] with 20% opacity
    onWarning: Colors.white,
    onWarningContainer: Color(0xFFFFB74D), // Colors.orange[300]

    // Interactive Elements
    divider: Color(0xFF424242), // Colors.grey[700]
    outline: Color(0xFF424242), // Colors.grey[700]
    shadow: Color(0x4D000000), // Black with 30% opacity

    // Button Colors
    buttonPrimary: Color(0xFF64B5F6), // Colors.blue[300]
    buttonSecondary: Color(0xFF2C2C2C), // Colors.grey[800]
    onButtonPrimary: Colors.white,
    onButtonSecondary: Colors.white,
  );

  // Generate ThemeData for MaterialApp
  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightColors.primary,
    colorScheme: ColorScheme.light(
      primary: _lightColors.accent,
      onPrimary: _lightColors.onButtonPrimary,
      secondary: _lightColors.buttonSecondary,
      onSecondary: _lightColors.onButtonSecondary,
      surface: _lightColors.surface,
      onSurface: _lightColors.onSurface,
      error: _lightColors.error,
      onError: _lightColors.onError,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _lightColors.primary,
      foregroundColor: _lightColors.onPrimary,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: _lightColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightColors.buttonPrimary,
        foregroundColor: _lightColors.onButtonPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkColors.primary,
    colorScheme: ColorScheme.dark(
      primary: _darkColors.accent,
      onPrimary: _darkColors.onButtonPrimary,
      secondary: _darkColors.buttonSecondary,
      onSecondary: _darkColors.onButtonSecondary,
      surface: _darkColors.surface,
      onSurface: _darkColors.onSurface,
      error: _darkColors.error,
      onError: _darkColors.onError,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _darkColors.primary,
      foregroundColor: _darkColors.onPrimary,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: _darkColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkColors.buttonPrimary,
        foregroundColor: _darkColors.onButtonPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

// Custom Color Scheme Class
class AppColorScheme {
  // Backgrounds
  final Color primary;
  final Color secondary;
  final Color tertiary;

  // Surfaces
  final Color surface;
  final Color surfaceElevated;
  final Color surfaceContainer;

  // Text Colors
  final Color onPrimary;
  final Color onSecondary;
  final Color onTertiary;
  final Color onSurface;
  final Color onSurfaceVariant;

  // Accent Colors
  final Color accent;
  final Color accentVariant;

  // Status Colors
  final Color error;
  final Color errorContainer;
  final Color onError;
  final Color onErrorContainer;

  final Color success;
  final Color successContainer;
  final Color onSuccess;
  final Color onSuccessContainer;

  final Color warning;
  final Color warningContainer;
  final Color onWarning;
  final Color onWarningContainer;

  // Interactive Elements
  final Color divider;
  final Color outline;
  final Color shadow;

  // Button Colors
  final Color buttonPrimary;
  final Color buttonSecondary;
  final Color onButtonPrimary;
  final Color onButtonSecondary;

  const AppColorScheme({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.surface,
    required this.surfaceElevated,
    required this.surfaceContainer,
    required this.onPrimary,
    required this.onSecondary,
    required this.onTertiary,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.accent,
    required this.accentVariant,
    required this.error,
    required this.errorContainer,
    required this.onError,
    required this.onErrorContainer,
    required this.success,
    required this.successContainer,
    required this.onSuccess,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarning,
    required this.onWarningContainer,
    required this.divider,
    required this.outline,
    required this.shadow,
    required this.buttonPrimary,
    required this.buttonSecondary,
    required this.onButtonPrimary,
    required this.onButtonSecondary,
  });
}