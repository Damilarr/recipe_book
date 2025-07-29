import 'package:flutter/material.dart';

class RecipeImageCard extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;

  const RecipeImageCard({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
