import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.dart';

class RecipeCardListView extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const RecipeCardListView({
    super.key,
    required this.recipe,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildListImage(),
            const SizedBox(width: 16),
            Expanded(child: _buildListContent(context)),
            _buildFavoriteButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildListImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(recipe.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            left: 4,
            child: _buildDifficultyBadge(isSmall: true),
          ),
        ],
      ),
    );
  }

  Widget _buildListContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recipe.title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          recipe.description,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildInfoChip(
              icon: Icons.timer,
              label: '${recipe.totalTimeMinutes}min',
              color: Colors.blue,
            ),
            const SizedBox(width: 8),
            _buildInfoChip(
              icon: Icons.people,
              label: '${recipe.servings}',
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            _buildRating(),
          ],
        ),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey[600],
        size: 24,
      ),
      onPressed: onFavorite,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
    );
  }

  Widget _buildDifficultyBadge({bool isSmall = false}) {
    Color badgeColor;
    switch (recipe.difficulty.toLowerCase()) {
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
        recipe.difficulty.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: isSmall ? 8 : 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.amber, size: 16),
        SizedBox(width: 4),
        Text(
          recipe.rating.toStringAsFixed(1),
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ],
    );
  }
}
