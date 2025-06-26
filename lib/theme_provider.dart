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
    primary: Color(0xFFFDFDFD), // Slightly off-white for better comfort
    secondary: Color(0xFFF8F9FA), // Softer gray
    tertiary: Color(0xFFF1F3F4), // Warmer gray

    // Surfaces
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFFFFFF),
    surfaceContainer: Color(0xFFF8F9FA),

    // Text Colors - Much stronger contrast
    onPrimary: Color(0xFF0D1117), // Almost black for maximum readability
    onSecondary: Color(0xFF24292F), // Very dark gray
    onTertiary: Color(0xFF57606A), // Medium dark gray
    onSurface: Color(0xFF0D1117), // Almost black
    onSurfaceVariant: Color(0xFF656D76), // Readable medium gray

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
      onSurfaceVariant: _lightColors.onSurfaceVariant,
      error: _lightColors.error,
      onError: _lightColors.onError,
      outline: _lightColors.outline,
      shadow: _lightColors.shadow,
      // Fix for proper text contrast on primary background
      onBackground: _lightColors.onPrimary,
      background: _lightColors.primary,
    ),
    // Add text theme for better text color control
    textTheme: TextTheme(
      displayLarge: TextStyle(color: _lightColors.onPrimary),
      displayMedium: TextStyle(color: _lightColors.onPrimary),
      displaySmall: TextStyle(color: _lightColors.onPrimary),
      headlineLarge: TextStyle(color: _lightColors.onPrimary),
      headlineMedium: TextStyle(color: _lightColors.onPrimary),
      headlineSmall: TextStyle(color: _lightColors.onPrimary),
      titleLarge: TextStyle(color: _lightColors.onPrimary),
      titleMedium: TextStyle(color: _lightColors.onPrimary),
      titleSmall: TextStyle(color: _lightColors.onSecondary),
      bodyLarge: TextStyle(color: _lightColors.onPrimary),
      bodyMedium: TextStyle(color: _lightColors.onPrimary),
      bodySmall: TextStyle(color: _lightColors.onSecondary),
      labelLarge: TextStyle(color: _lightColors.onPrimary),
      labelMedium: TextStyle(color: _lightColors.onSecondary),
      labelSmall: TextStyle(color: _lightColors.onSecondary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _lightColors.primary,
      foregroundColor: _lightColors.onPrimary,
      titleTextStyle: TextStyle(
        color: _lightColors.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(color: _lightColors.onPrimary),
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
    // Fix icon colors
    iconTheme: IconThemeData(color: _lightColors.onPrimary),
    primaryIconTheme: IconThemeData(color: _lightColors.onPrimary),
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
      onSurfaceVariant: _darkColors.onSurfaceVariant,
      error: _darkColors.error,
      onError: _darkColors.onError,
      outline: _darkColors.outline,
      shadow: _darkColors.shadow,
      onBackground: _darkColors.onPrimary,
      background: _darkColors.primary,
    ),
    // Enhanced dark theme with better visual comfort
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: _darkColors.onPrimary,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        color: _darkColors.onPrimary,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
      ),
      displaySmall: TextStyle(
        color: _darkColors.onPrimary,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        color: _darkColors.onPrimary,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
      ),
      headlineMedium: TextStyle(
        color: _darkColors.onPrimary,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: _darkColors.onPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: _darkColors.onPrimary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      titleMedium: TextStyle(
        color: _darkColors.onPrimary,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        color: _darkColors.onSecondary,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        color: _darkColors.onPrimary,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: _darkColors.onPrimary,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        color: _darkColors.onSecondary,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.3,
      ),
      labelLarge: TextStyle(
        color: _darkColors.onPrimary,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
      ),
      labelMedium: TextStyle(
        color: _darkColors.onSecondary,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
      ),
      labelSmall: TextStyle(
        color: _darkColors.onSecondary,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _darkColors.primary,
      foregroundColor: _darkColors.onPrimary,
      titleTextStyle: TextStyle(
        color: _darkColors.onPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(
        color: _darkColors.onPrimary,
        size: 24,
      ),
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardTheme(
      color: _darkColors.surface,
      elevation: 1,
      shadowColor: _darkColors.shadow,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _darkColors.outline.withOpacity(0.3),
          width: 0.5,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkColors.buttonPrimary,
        foregroundColor: _darkColors.onButtonPrimary,
        elevation: 2,
        shadowColor: _darkColors.shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    iconTheme: IconThemeData(
      color: _darkColors.onPrimary,
      size: 24,
    ),
    primaryIconTheme: IconThemeData(
      color: _darkColors.onPrimary,
      size: 24,
    ),
    listTileTheme: ListTileThemeData(
      textColor: _darkColors.onPrimary,
      iconColor: _darkColors.onPrimary,
      titleTextStyle: TextStyle(
        color: _darkColors.onPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      subtitleTextStyle: TextStyle(
        color: _darkColors.onSecondary,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
    ),
    dividerTheme: DividerThemeData(
      color: _darkColors.divider,
      thickness: 0.5,
      space: 1,
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