import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF1E88E5);
  static const secondaryColor = Color.fromARGB(255, 10, 74, 170);
  static const _darkSurfaceColor = Color(0xFF1E1E1E); // Gris oscuro (no negro)
  static const _darkBackgroundColor = Color(0xFF121212); // Negro suave
  static const _darkPrimaryColor = Color(0xFF64B5F6); // Un azul más claro/brillante
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      )
    );
  }
  static ThemeData get darkTheme {
    return ThemeData.dark(useMaterial3: true).copyWith(
      primaryColor: _darkPrimaryColor, // Usamos el azul brillante
      scaffoldBackgroundColor: _darkBackgroundColor,
      cardColor: _darkSurfaceColor, // <--- Esto arregla el fondo de la Navbar
      
      // Configuración de colores semánticos
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: _darkPrimaryColor, // Iconos activos tomarán este color
        surface: _darkSurfaceColor, // Tarjetas tomarán este color
      ),

      bottomAppBarTheme: const BottomAppBarThemeData(
        color: _darkSurfaceColor,
        elevation: 0, // O quítalo si prefieres plano
      ),

      // Tus inputs corregidos para dark mode
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2C), // Un poco más claro que el fondo
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        // ...
      ),
    );
  }
}


class ThemeManager {
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();
  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);
  void toggleTheme(bool isDark) {
    print("CAMBIANDO TEMA A: ${isDark ? 'OSCURO' : 'CLARO'}");
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}