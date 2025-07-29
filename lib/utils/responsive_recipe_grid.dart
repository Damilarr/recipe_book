import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/utils/responsive_breakpoints.dart';
import 'package:recipe_book/widgets/recipe/recipe_carousel_card.dart';

class ResponsiveRecipeGrid extends StatelessWidget {
  final List<Recipe> recipes;
  final int maxItems;
  const ResponsiveRecipeGrid({
    super.key,
    required this.recipes,
    required this.maxItems,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: recipes.length,
      options: CarouselOptions(
        aspectRatio: ResponsiveBreakpoints.isMobile(context) ? 16 / 9 : 16 / 9,
        height: ResponsiveBreakpoints.isMobile(context) ? 180 : 270,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        scrollDirection: Axis.horizontal,
      ),
      itemBuilder:
          (BuildContext context, int itemIndex, int pageViewIndex) =>
              RecipeCarouselCard(recipe: recipes[itemIndex]),
    );
  }
}
