import 'package:flutter/material.dart';
import 'package:recipe_book/data/sample_recipes.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/utils/favourite_recipe_service.dart';
import 'package:recipe_book/utils/responsive_breakpoints.dart';
import 'package:recipe_book/widgets/recipe/recipe_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Recipe> _favouriteRecipes = [];
  List<String> _favouriteIds = [];
  @override
  void initState() {
    _loadFavourites();
    super.initState();
  }

  Future<void> _loadFavourites() async {
    final favouriteIds = await FavouriteRecipeService().getFavouriteIds();
    setState(() {
      _favouriteIds = favouriteIds;
      _favouriteRecipes =
          sampleRecipes
              .where((recipe) => favouriteIds.contains(recipe.id))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Recipes')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _favouriteRecipes.isEmpty
                ? _buildNoFavorite(context)
                : _buildRecipeGridView(context, _favouriteRecipes),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeGridView(BuildContext context, List<Recipe> recipes) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: ResponsiveBreakpoints.isMobile(context) ? 1.5 : 1,
      ),
      shrinkWrap: true,
      itemCount: recipes.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ResponsiveRecipeCard(
          recipe: recipes[index],
          onTap: () => _viewRecipe(context, recipes[index]),
          isFavorite: _favouriteIds.contains(recipes[index].id),
          onFavorite: () => _toggleFavourites(recipes[index].id),
        );
      },
    );
  }

  void _viewRecipe(BuildContext context, Recipe recipe) {
    Navigator.pushNamed(
      context,
      "/recipe-detail",
      arguments: {"recipeId": recipe.id, "recipeName": recipe.title},
    );
  }

  Future<void> _toggleFavourites(String recipeId) async {
    await FavouriteRecipeService().addToFavourite(recipeId);
    await _loadFavourites();
  }

  Widget _buildNoFavorite(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
            SizedBox(height: 24),
            Text(
              'No favorite recipes yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Start exploring and save your favorite recipes!\nTap the heart icon on any recipe to add it here.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/recipe-list');
              },
              icon: Icon(Icons.explore),
              label: Text('Explore Recipes'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
