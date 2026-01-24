import 'package:flutter/material.dart';
import 'package:student_app/signup_page.dart';
import 'theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: mode,

          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
            ),
            cardColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
              secondary: Color(0xFF7C3AED),
              error: Color(0xFFEF4444),
              tertiary: Color(0xFF06B6D4),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Color(0xFF1E293B)),
              bodyMedium: TextStyle(color: Color(0xFF1E293B)),
              bodySmall: TextStyle(color: Color(0xFF64748B)),
            ),
            useMaterial3: true,
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF020617),
              foregroundColor: Colors.white,
            ),
            cardColor: const Color(0xFF1E293B),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF2563EB),
              secondary: Color(0xFF7C3AED),
              error: Color(0xFFEF4444),
              tertiary: Color(0xFF06B6D4),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Color(0xFFF1F5F9)),
              bodyMedium: TextStyle(color: Color(0xFFF1F5F9)),
              bodySmall: TextStyle(color: Color(0xFF94A3B8)),
            ),
            useMaterial3: true,
          ),

          home: const SignUpPage(),
        );
      },
    );
  }
}
