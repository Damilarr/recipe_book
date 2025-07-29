import 'package:flutter/material.dart';
import 'package:recipe_book/screens/favorites_screen.dart';
import 'package:recipe_book/screens/home_screen.dart';
import 'package:recipe_book/screens/profile_screen.dart';
import 'package:recipe_book/screens/recipe_list_screen.dart';
import 'package:recipe_book/utils/responsive_breakpoints.dart';

class ResponsiveNavigation extends StatefulWidget {
  @override
  _ResponsiveNavigationState createState() => _ResponsiveNavigationState();
}

class _ResponsiveNavigationState extends State<ResponsiveNavigation> {
  int selectedIndex = 0;

  final List<AppNavigationDestination> destinations = [
    AppNavigationDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      page: HomeScreen(),
    ),
    AppNavigationDestination(
      label: 'Recipes',
      icon: Icons.restaurant_outlined,
      selectedIcon: Icons.restaurant,
      page: RecipeListScreen(),
    ),
    AppNavigationDestination(
      label: 'Favorites',
      icon: Icons.favorite_outline,
      selectedIcon: Icons.favorite,
      page: FavoritesScreen(),
    ),
    AppNavigationDestination(
      label: 'Profile',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      page: ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.isDesktop(context)) {
      return _buildDesktopLayout();
    } else if (ResponsiveBreakpoints.isTablet(context)) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    "Recipe Book",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: NavigationRail(
                    extended: true,
                    backgroundColor: Colors.transparent,

                    unselectedLabelTextStyle: TextStyle(
                      fontSize: 16, //
                      fontWeight: FontWeight.w500,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    selectedLabelTextStyle: TextStyle(
                      fontSize: 16, //
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                    unselectedIconTheme: IconThemeData(
                      size: 24, //
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    selectedIconTheme: IconThemeData(
                      size: 24, //
                      color: Theme.of(context).primaryColor,
                    ),
                    selectedIndex: selectedIndex,
                    onDestinationSelected: _onDestinationSelected,
                    destinations:
                        destinations.map(_buildRailDestination).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: destinations[selectedIndex].page),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: destinations.map(_buildRailDestination).toList(),
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(child: destinations[selectedIndex].page),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: destinations[selectedIndex].page,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: destinations.map(_buildBottomDestination).toList(),
      ),
    );
  }

  NavigationRailDestination _buildRailDestination(
    AppNavigationDestination dest,
  ) {
    return NavigationRailDestination(
      icon: Icon(dest.icon),
      selectedIcon: Icon(dest.selectedIcon),
      label: Text(dest.label),
    );
  }

  Widget _buildBottomDestination(AppNavigationDestination dest) {
    return NavigationDestination(
      icon: Icon(dest.icon),
      selectedIcon: Icon(dest.selectedIcon),
      label: dest.label,
    );
  }

  void _onDestinationSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class AppNavigationDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;

  const AppNavigationDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });
}
