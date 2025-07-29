import 'package:flutter/material.dart';
import 'package:recipe_book/data/sample_recipes.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/utils/favourite_recipe_service.dart';
import 'package:recipe_book/utils/responsive_breakpoints.dart';
import 'package:recipe_book/widgets/recipe/recipe_image_card.dart';
import 'package:recipe_book/widgets/recipe/recipe_short_card.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  String _recipeName = '';
  late Recipe currentRecipe;
  String _mainImageUrl = '';
  bool isFavorite = false;
  bool isBookMarked = false;
  int numberOfServing = 1;

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final favouriteIds = await FavouriteRecipeService().getFavouriteIds();
    setState(() {
      if (favouriteIds.contains(currentRecipe.id)) {
        isFavorite = true;
      } else {
        isFavorite = false;
      }
    });
  }

  Future<void> _toggleFavourites(String recipeId) async {
    await FavouriteRecipeService().addToFavourite(recipeId);
    await _loadFavourites();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null &&
        arguments['recipeId'] != null &&
        arguments['recipeName'] != null) {
      _recipeName = arguments['recipeName'];
      currentRecipe = sampleRecipes.firstWhere(
        (recipe) => recipe.id == arguments['recipeId'],
      );
      if (_mainImageUrl.isEmpty) {
        _mainImageUrl = currentRecipe.imageUrl;
      }
    }
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageGallery(context, currentRecipe),
            SizedBox(height: 20),
            _buildTopSection(context, currentRecipe),
            SizedBox(height: 20),
            _buildSummary(context, currentRecipe),
            SizedBox(height: 20),
            _buildIngredients(context, currentRecipe),
            SizedBox(height: 20),
            _buildNutritionInfo(context, currentRecipe),
            SizedBox(height: 20),
            _buildInstructions(context, currentRecipe),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(title: Text(_recipeName));
  }

  Widget _buildImageGallery(BuildContext context, recipe) {
    List<String> allImages = [recipe.imageUrl, ...recipe.additionalImages];

    return Column(
      spacing: 16,
      children: [
        RecipeImageCard(
          imageUrl: _mainImageUrl,
          height: 300,
          width: double.infinity,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children:
                  allImages
                      .map<Widget>(
                        (image) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _mainImageUrl = image;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  _mainImageUrl == image
                                      ? Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 3,
                                      )
                                      : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: RecipeImageCard(
                              imageUrl: image,
                              height: 120,
                              width: 120,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyBadge(difficulty, {bool isSmall = false}) {
    Color badgeColor;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        badgeColor = Colors.green;
        break;
      case 'medium':
        badgeColor = Colors.orange;
        break;
      case 'hard':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 4 : 8,
        vertical: isSmall ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(isSmall ? 8 : 12),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: isSmall ? 8 : 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, recipe) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.star, color: Colors.amber.shade700),
                        Text(
                          recipe.rating.toString(),
                          style: TextStyle(color: Theme.of(context).hintColor),
                        ),
                        SizedBox(width: 8),
                        Text("(${recipe.reviewCount.toString()} Reviews)"),
                        SizedBox(width: 8),
                        _buildDifficultyBadge(recipe.difficulty),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey[600],
                      ),
                      onPressed: () => _toggleFavourites(currentRecipe.id),
                      constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isBookMarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookMarked ? Colors.red : Colors.grey[600],
                      ),
                      onPressed: () {},
                      constraints: BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(recipe.description),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, recipe) {
    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: ResponsiveBreakpoints.isMobile(context) ? 2 : 4,
          childAspectRatio: 1.5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: [
            RecipeShortCard(
              subText: "Prep Time",
              mainText: recipe.prepTimeMinutes.toString(),
              reverse: true,
              icon: Icons.timelapse,
            ),
            RecipeShortCard(
              subText: "Cook Time",
              mainText: recipe.cookTimeMinutes.toString(),
              reverse: true,
              icon: Icons.timer,
            ),
            RecipeShortCard(
              subText: "Servings",
              mainText: recipe.servings.toString(),
              reverse: true,
              icon: Icons.people,
            ),
            RecipeShortCard(
              subText: "Category",
              mainText: recipe.category,
              reverse: true,
              icon: Icons.category_outlined,
            ),
          ],
        ),
        SizedBox(height: 8),
        Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                recipe.tags
                    .map<Widget>(
                      (tag) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredients(BuildContext context, Recipe recipe) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ingredients",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Row(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (numberOfServing > 1) {
                            numberOfServing -= 1;
                          }
                        });
                      },
                      icon: Icon(Icons.remove),
                    ),
                  ),
                  Text(
                    "$numberOfServing Servings",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          numberOfServing += 1;
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            spacing: 8,
            children:
                recipe.ingredients
                    .map<Widget>(
                      (recipe) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            recipe.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            "${recipe.amount * numberOfServing} ${recipe.unit}",
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo(BuildContext context, Recipe recipe) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nutrition Information",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  "Per Serving",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: ResponsiveBreakpoints.isMobile(context) ? 2 : 4,
            childAspectRatio: 1.5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              RecipeShortCard(
                subText: "Calories",
                mainText: recipe.nutritionInfo.calories.toString(),
                reverse: false,
                bgCol: Colors.white70,
              ),
              RecipeShortCard(
                subText: "Protein",
                mainText: recipe.nutritionInfo.protein.toString(),
                reverse: false,
                bgCol: Colors.white70,
              ),
              RecipeShortCard(
                subText: "Carbs",
                mainText: recipe.nutritionInfo.carbs.toString(),
                reverse: false,
                bgCol: Colors.white70,
              ),
              RecipeShortCard(
                subText: "Fats",
                mainText: recipe.nutritionInfo.fat.toString(),
                reverse: false,
                bgCol: Colors.white70,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions(BuildContext context, Recipe recipe) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Instructions",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Column(
            spacing: 8,
            children:
                recipe.instructions
                    .asMap()
                    .entries
                    .map<Widget>(
                      (entry) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}
