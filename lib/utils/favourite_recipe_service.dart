import 'package:shared_preferences/shared_preferences.dart';

class FavouriteRecipeService {
  Future<void> addToFavourite(String recipeId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favouriteIds =
        prefs.getStringList('favourite_recipe_ids') ?? [];
    if (favouriteIds.contains(recipeId)) {
      favouriteIds.remove(recipeId);
    } else {
      favouriteIds.add(recipeId);
    }
    await prefs.setStringList('favourite_recipe_ids', favouriteIds);
  }

  Future<bool> isFavourite(String recipeId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favouriteIds =
        prefs.getStringList('favourite_recipe_ids') ?? [];
    return favouriteIds.contains(recipeId);
  }

  Future<List<String>> getFavouriteIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favourite_recipe_ids') ?? [];
  }
}
