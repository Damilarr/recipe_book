import 'package:flutter/material.dart';
import 'package:recipe_book/utils/favourite_recipe_service.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> _favouriteIds = [];
  Future<void> _loadFavourites() async {
    final favouriteIds = await FavouriteRecipeService().getFavouriteIds();
    setState(() {
      _favouriteIds = favouriteIds;
    });
  }

  @override
  void initState() {
    _loadFavourites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'), elevation: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildQuickStats(context),
            SizedBox(height: 32),
            _buildSettingsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            '12',
            'Recipes\nCooked',
            Icons.restaurant,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            _favouriteIds.length.toString(),
            'Favorites',
            Icons.favorite,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            '2',
            'Days\nActive',
            Icons.calendar_today,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String number,
    String label,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          SizedBox(height: 8),
          Text(
            number,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        _buildSettingsTile(
          context,
          Icons.notifications_outlined,
          'Notifications',
          'Manage your notification preferences',
          () {},
        ),
        _buildSettingsTile(
          context,
          Icons.dark_mode_outlined,
          'Dark Mode',
          'Switch between light and dark theme',
          () {},
        ),
        _buildSettingsTile(
          context,
          Icons.language_outlined,
          'Language',
          'Choose your preferred language',
          () {},
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
