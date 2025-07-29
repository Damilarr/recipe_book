import 'package:flutter/material.dart';
import 'package:recipe_book/data/recipe_categories.dart';
import 'package:recipe_book/widgets/recipe/recipe_category_card.dart';

class ResponsiveCategoryGrid extends StatelessWidget {
  final List<RecipeCategory> categories;
  final int maxItems;
  const ResponsiveCategoryGrid({
    super.key,
    required this.categories,
    required this.maxItems,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      physics: NeverScrollableScrollPhysics(),
      children:
          categories.map((category) {
            return RecipeCategoryCard(
              name: category.name,
              backgroundColor: category.backgroundColor,
              textColor: category.textColor,
              icon: category.icon,
            );
          }).toList(),
    );
  }
}
