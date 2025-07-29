import 'package:flutter/material.dart';

class RecipeCategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  const RecipeCategoryCard({
    super.key,
    required this.name,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/recipe-list",
          arguments: {'category': name},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: textColor),
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
