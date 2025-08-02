// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:recipe_book/data/recipe_categories.dart';
import 'package:recipe_book/data/sample_recipes.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/utils/responsive_breakpoints.dart';
import 'package:recipe_book/utils/responsive_category_grid.dart';
import 'package:recipe_book/utils/responsive_recipe_grid.dart';

import 'package:recipe_book/widgets/recipe/recipe_card_list_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _searchResults = [];
  String _searchQuery = '';

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      if (_searchQuery.isNotEmpty) {
        _searchResults = _performSearch(_searchQuery);
      } else {
        _searchResults = [];
      }
    });
  }

  List<Recipe> _performSearch(String query) {
    if (query.isEmpty) return [];
    final lowercaseQuery = query.toLowerCase();
    return sampleRecipes.where((recipe) {
      return recipe.title.toLowerCase().contains(lowercaseQuery) ||
          recipe.description.toLowerCase().contains(lowercaseQuery) ||
          recipe.category.toLowerCase().contains(lowercaseQuery) ||
          recipe.tags.any(
            (tag) => tag.toLowerCase().contains(lowercaseQuery),
          ) ||
          recipe.ingredients.any(
            (ingredient) =>
                ingredient.name.toLowerCase().contains(lowercaseQuery),
          );
    }).toList();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchResults = [];
    });
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isSearching && _searchQuery.isNotEmpty) ...[
              _buildSearchResults(context),
            ] else ...[
              _buildHeroSection(context),
              SizedBox(height: 32),
              _buildFeaturedRecipes(context),
              SizedBox(height: 32),
              _buildQuickCategories(context),
              SizedBox(height: 32),
            ],
            // _buildRecentlyViewed(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: _isSearching ? _buildSearchField(context) : Text('Recipe Book'),
      actions: [
        if (_isSearching) ...[
          IconButton(icon: Icon(Icons.clear), onPressed: _stopSearch),
        ] else ...[
          IconButton(icon: Icon(Icons.search), onPressed: _startSearch),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () => _navigateToShoppingList(context),
          ),
        ],
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search recipes, ingredients...',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 18,
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    if (_searchResults.isEmpty) {
      return _buildNoSearchResults(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            '${_searchResults.length} recipe${_searchResults.length == 1 ? '' : 's'} found for "$_searchQuery"',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _searchResults.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final recipe = _searchResults[index];
            return RecipeCardListView(
              recipe: recipe,
              onTap:
                  () => Navigator.pushNamed(
                    context,
                    '/recipe-detail',
                    arguments: {
                      'recipeId': recipe.id,
                      'recipeName': recipe.title,
                    },
                  ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNoSearchResults(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 64),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No recipes found',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _stopSearch,
              child: Text('Browse All Recipes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: ResponsiveBreakpoints.isMobile(context) ? 200 : 300,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange[400]!, Colors.deepOrange[600]!],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Recipe Book',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Discover amazing recipes for every occasion',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _exploreRecipes(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ResponsiveBreakpoints.isTablet(context) ||
                            ResponsiveBreakpoints.isMobile(context)
                        ? 20
                        : 8,
                  ),
                ),
              ),
              child: Text('Explore Recipes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedRecipes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Recipes',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => _viewAllRecipes(context),
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 16),
        ResponsiveRecipeGrid(
          recipes: featuredRecipes,
          maxItems: ResponsiveBreakpoints.isMobile(context) ? 4 : 6,
        ),
      ],
    );
  }

  Widget _buildQuickCategories(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 16),
        ResponsiveCategoryGrid(
          categories: categories,
          maxItems: ResponsiveBreakpoints.isMobile(context) ? 4 : 6,
        ),
      ],
    );
  }

  // Helper methods
  void _showSearch(BuildContext context) {
    // Implement search functionality
  }

  void _navigateToShoppingList(BuildContext context) {
    // Navigate to shopping list
  }

  void _exploreRecipes(BuildContext context) {
    Navigator.pushNamed(context, "/recipe-list");
  }

  void _viewAllRecipes(BuildContext context) {
    Navigator.pushNamed(context, "/recipe-list");
  }
}
