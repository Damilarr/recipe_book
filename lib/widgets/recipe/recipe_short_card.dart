import 'package:flutter/material.dart';

class RecipeShortCard extends StatelessWidget {
  final String mainText;
  final String subText;
  final bool reverse;
  final Color bgCol;
  final IconData? icon;

  const RecipeShortCard({
    super.key,
    this.mainText = '',
    this.subText = '',
    this.reverse = false,
    this.bgCol = Colors.white,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: bgCol,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(blurRadius: 3, color: Colors.black12)],
      ),
      child: Column(
        spacing: 6,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon!, size: 24),
          if (reverse) ...[
            Text(subText, style: Theme.of(context).textTheme.titleMedium),
            Text(mainText, style: Theme.of(context).textTheme.headlineMedium),
          ] else ...[
            Text(mainText, style: Theme.of(context).textTheme.headlineMedium),
            Text(subText, style: Theme.of(context).textTheme.titleMedium),
          ],
        ],
      ),
    );
  }
}
