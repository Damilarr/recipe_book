import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/utils/responsive_breakpoints.dart';

class RecipeCarouselCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCarouselCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/recipe-detail",
          arguments: {'recipeId': recipe.id, 'recipeName': recipe.title},
        );
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: recipe.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Container(
                      color: colorScheme.surface,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      color: colorScheme.surface,
                      child: Icon(Icons.error),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),

                child: Padding(
                  padding: EdgeInsets.all(
                    ResponsiveBreakpoints.isMobile(context) ? 8 : 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.0,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        recipe.title,
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.timer, color: Colors.white70),
                              Text(
                                recipe.cookTimeMinutes.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Text(
                            recipe.difficulty.toUpperCase(),
                            style: TextStyle(color: Colors.white70),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.star, color: Colors.amber.shade700),
                              Text(
                                recipe.rating.toString(),
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    recipe.category,
                    style: TextStyle(
                      backgroundColor: colorScheme.primary,
                      color: colorScheme.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
