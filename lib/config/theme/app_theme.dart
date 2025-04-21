import 'package:flutter/material.dart';

class AppTheme {
  // Tipografía
  static const TextStyle headline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.deepPurple,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 18,
    color: Colors.black87,
  );

  static const TextStyle subTitle = TextStyle(
    fontSize: 18,
    color: Colors.deepPurple,
  );

  static ThemeData lighttheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255, 182, 85, 199),
    brightness: Brightness.light,
    //colorScheme: lightColorScheme,
    
    //visualDensity: VisualDensity.adaptivePlatformDensity,
    //scaffoldBackgroundColor: lightColorScheme.surface,
    

    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 18.0, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 16.0, color: Colors.black87),
      headlineMedium: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
    ),

    cardTheme: CardTheme(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      //color: Colors.blueGrey,
    ),
    
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.orange[300],
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.grey[300],
    brightness: Brightness.dark,
    //colorScheme: darkColorScheme,
    
    //visualDensity: VisualDensity.adaptivePlatformDensity,
    //scaffoldBackgroundColor: darkColorScheme.surface,
    
    /* appBarTheme: AppBarTheme(
      color: darkColorScheme.primary,
      titleTextStyle: headline1.copyWith(color: darkColorScheme.onPrimary),
    ), */

    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 18.0, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 16.0, color: Colors.white70),
      headlineMedium: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
    ),

    cardTheme: CardTheme(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.blueGrey
    ),

    //iconTheme: IconThemeData(color: darkColorScheme.primary),
 
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.orange,
      textTheme: ButtonTextTheme.primary,
    ),

  );
}
