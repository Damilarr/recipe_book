import 'package:flutter/material.dart';
import 'package:recipe_book/data/sample_recipes.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/utils/favourite_recipe_service.dart';
import 'package:recipe_book/utils/responsive_breakpoints.dart';
import 'package:recipe_book/widgets/recipe/recipe_card.dart';
import 'package:recipe_book/widgets/recipe/recipe_card_list_view.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  bool gridStyle = true;
  String _selectedCategory = 'All';
  Set<String> _favouriteIds = {};
  bool _hasProcessedArguements = false;
  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final favouriteIds = await FavouriteRecipeService().getFavouriteIds();
    setState(() {
      _favouriteIds = favouriteIds.toSet();
    });
  }

  Future<void> _toggleFavourites(String recipeId) async {
    await FavouriteRecipeService().addToFavourite(recipeId);
    await _loadFavourites();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasProcessedArguements) {
      //arguements from home screen.
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (arguments != null && arguments['category'] != null) {
        _selectedCategory = arguments['category'] as String;
      }
      _hasProcessedArguements = true;
    }

    final recipeCategories =
        sampleRecipes.map((recipe) => recipe.category).toSet().toList();
    recipeCategories.insert(0, "All");
    final recipeList =
        _selectedCategory == "All"
            ? sampleRecipes
            : sampleRecipes
                .where((recipe) => recipe.category == _selectedCategory)
                .toList();
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterAndDisplay(context, recipeCategories),
            SizedBox(height: 32),
            gridStyle
                ? _buildRecipeGridView(context, recipeList)
                : _buildRecipeListView(context, recipeList),
            SizedBox(height: 32),
            // _buildQuickCategories(context),
            // _buildRecentlyViewed(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(title: Text('Recipe Collection'));
  }

  Widget _buildFilterAndDisplay(BuildContext context, recipeCategories) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.filter_list),
            ),
            DropdownMenu<String>(
              onSelected: (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
              initialSelection: _selectedCategory,
              dropdownMenuEntries:
                  recipeCategories.map<DropdownMenuEntry<String>>((
                    String value,
                  ) {
                    return DropdownMenuEntry<String>(
                      value: value,
                      label: value,
                    );
                  }).toList(),
            ),
          ],
        ),
        Container(
          height: 50,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black38),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    gridStyle = false;
                  });
                },
                icon: Icon(Icons.list),
                color: !gridStyle ? Colors.blue : Colors.grey,
              ),
              VerticalDivider(width: 2, color: Colors.black38),
              IconButton(
                onPressed: () {
                  setState(() {
                    gridStyle = true;
                  });
                },
                icon: Icon(Icons.grid_view),
                color: gridStyle ? Colors.blue : Colors.grey,
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildRecipeListView(BuildContext context, List<Recipe> recipes) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: recipes.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return RecipeCardListView(
          recipe: recipes[index],
          onTap: () => _viewRecipe(context, recipes[index]),
          isFavorite: _favouriteIds.contains(recipes[index].id),
          onFavorite: () => _toggleFavourites(recipes[index].id),
        );
      },
    );
  }
}

void _viewRecipe(BuildContext context, Recipe recipe) {
  Navigator.pushNamed(
    context,
    "/recipe-detail",
    arguments: {"recipeId": recipe.id, "recipeName": recipe.title},
  );
}
