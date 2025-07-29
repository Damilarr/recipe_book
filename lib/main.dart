import 'package:flutter/material.dart';
import 'package:recipe_book/screens/favorites_screen.dart';
import 'package:recipe_book/screens/page_not_found.dart';
import 'package:recipe_book/screens/profile_screen.dart';
import 'package:recipe_book/screens/recipe_detail_screen.dart';
import 'package:recipe_book/screens/recipe_list_screen.dart';
import 'package:recipe_book/widgets/common/responsive_navigation.dart';

void main() {
  runApp(const MyApp());
}

class AppColors {
  static const primary = Color(0xFFFF6B35);
  static const primaryVariant = Color(0xFFE55100);
  static const secondary = Color(0xFFFFAB91);
  static const background = Color(0xFFFAFAFA);
  static const surface = Colors.white;
  static const error = Color(0xFFD32F2F);
  static const onPrimary = Colors.white;
  static const onSecondary = Colors.white;
  static const onBackground = Color(0xFF212121);
  static const onSurface = Color(0xFF212121);
  static const onError = Colors.white;
  static const brightness = Brightness.light;
}

class AppTextStyles {
  static const heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static const body = TextStyle(fontSize: 16, height: 1.5);

  static const caption = TextStyle(fontSize: 12, color: Colors.grey);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Book',
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          brightness: AppColors.brightness,
          onError: AppColors.onError,
          onSurface: AppColors.onSurface,
          onSecondary: AppColors.onSecondary,
          secondary: AppColors.secondary,
          error: AppColors.error,
          background: AppColors.background,
          onBackground: AppColors.onBackground,
          surface: AppColors.surface,
        ),
        textTheme: TextTheme(
          headlineLarge: AppTextStyles.heading1,
          headlineMedium: AppTextStyles.heading2,
          bodyMedium: AppTextStyles.body,
          labelMedium: AppTextStyles.caption,
        ),
      ),
      routes: {
        '/': (context) => ResponsiveNavigation(),
        '/profile': (context) => ProfileScreen(),
        '/favorites': (context) => FavoritesScreen(),
        '/recipe-list': (context) => RecipeListScreen(),
        '/recipe-detail': (context) => RecipeDetailScreen(),
      },
      initialRoute: '/',
      onUnknownRoute:
          (settings) => MaterialPageRoute(builder: (context) => PageNotFound()),
    );
  }
}
