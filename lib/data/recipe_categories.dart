import 'package:flutter/material.dart';

class RecipeCategory {
  final String name;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;

  const RecipeCategory({
    required this.name,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  });
}

final List<RecipeCategory> categories = [
  RecipeCategory(
    name: "Breakfast",
    icon: Icons.coffee,
    backgroundColor: Colors.orange.shade100,
    textColor: Colors.orange.shade600,
  ),
  RecipeCategory(
    name: "Main Course",
    icon: Icons.restaurant,
    backgroundColor: Colors.red.shade100,
    textColor: Colors.red.shade600,
  ),
  RecipeCategory(
    name: "Desserts",
    icon: Icons.cake,
    backgroundColor: Colors.pink.shade100,
    textColor: Colors.pink.shade600,
  ),
  RecipeCategory(
    name: "Quick Meals",
    icon: Icons.timer,
    backgroundColor: Colors.green.shade100,
    textColor: Colors.green.shade600,
  ),
  RecipeCategory(
    name: "Healthy",
    icon: Icons.eco,
    backgroundColor: Colors.blue.shade100,
    textColor: Colors.blue.shade600,
  ),
  RecipeCategory(
    name: "Party Food",
    icon: Icons.group,
    backgroundColor: Colors.purple.shade100,
    textColor: Colors.purple.shade600,
  ),
];
