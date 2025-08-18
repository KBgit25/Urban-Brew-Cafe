import 'package:flutter/material.dart';
import 'package:urban_brew_cafe/screen/splash_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urban Brew Cafe',
      theme: ThemeData(
        // Coffee-inspired color scheme
        primarySwatch: Colors.brown,
        primaryColor: const Color(0xFF8B4513), // Saddle Brown - main coffee color
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B4513),
          brightness: Brightness.light,
          primary: const Color(0xFF8B4513), // Saddle Brown
          secondary: const Color(0xFFD2691E), // Chocolate Orange
          surface: const Color(0xFFFAF0E6), // Linen - warm cream
          background: const Color(0xFFF5F5DC), // Beige
        ),
        // Custom app bar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B4513), // Saddle Brown
          foregroundColor: Color(0xFFFAF0E6), // Cream text
          elevation: 2,
          iconTheme: IconThemeData(color: Color(0xFFFAF0E6)),
        ),
        // Elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD2691E), // Chocolate Orange
            foregroundColor: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        // Text theme with coffee-inspired colors
        textTheme: const TextTheme(
          headlineLarge: TextStyle(color: Color(0xFF654321)), // Dark Brown
          headlineMedium: TextStyle(color: Color(0xFF654321)),
          headlineSmall: TextStyle(color: Color(0xFF654321)),
          bodyLarge: TextStyle(color: Color(0xFF8B4513)),
          bodyMedium: TextStyle(color: Color(0xFF8B4513)),
        ),
        // Progress indicator theme
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFFD2691E), // Chocolate Orange
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}