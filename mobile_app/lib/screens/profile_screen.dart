import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/plant_provider.dart';
import '../utils/theme.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final plantProvider = Provider.of<PlantProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundGreen,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppTheme.primaryGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Info Card
            _buildUserInfoCard(authProvider),
            
            const SizedBox(height: 20),
            
            // Statistics Card
            _buildStatisticsCard(plantProvider),
            
            const SizedBox(height: 20),
            
            // Settings Section
            _buildSettingsSection(context, authProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(AuthProvider authProvider) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryGreen,
              AppTheme.accentGreen,
            ],
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Text(
                authProvider.userInitials,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authProvider.displayName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authProvider.userEmail ?? 'user@example.com',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Plant Doctor',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(PlantProvider plantProvider) {
    final totalPlants = plantProvider.plantHistory.length;
    final healthyPlants = plantProvider.plantHistory
        .where((plant) => plant.diseases.isEmpty)
        .length;
    final plantsWithDiseases = plantProvider.getPlantsWithDiseases().length;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Garden Stats',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.eco,
                    title: 'Total Plants',
                    value: totalPlants.toString(),
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.check_circle,
                    title: 'Healthy',
                    value: healthyPlants.toString(),
                    color: AppTheme.successGreen,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.healing,
                    title: 'Needs Care',
                    value: plantsWithDiseases.toString(),
                    color: AppTheme.warningOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, AuthProvider authProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            _buildSettingItem(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Manage push notifications',
              onTap: () {
                // TODO: Navigate to notifications settings
              },
            ),
            
            _buildSettingItem(
              icon: Icons.language,
              title: 'Language',
              subtitle: 'English',
              onTap: () {
                // TODO: Navigate to language settings
              },
            ),
            
            _buildSettingItem(
              icon: Icons.dark_mode,
              title: 'Theme',
              subtitle: 'Light mode',
              onTap: () {
                // TODO: Navigate to theme settings
              },
            ),
            
            _buildSettingItem(
              icon: Icons.help,
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () {
                // TODO: Navigate to help screen
              },
            ),
            
            _buildSettingItem(
              icon: Icons.info,
              title: 'About',
              subtitle: 'App version and information',
              onTap: () {
                // TODO: Navigate to about screen
              },
            ),
            
            const Divider(height: 30),
            
            _buildSettingItem(
              icon: Icons.logout,
              title: 'Sign Out',
              subtitle: 'Sign out of your account',
              onTap: () => _showSignOutDialog(context, authProvider),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive 
              ? AppTheme.errorRed.withOpacity(0.1)
              : AppTheme.primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? AppTheme.errorRed : AppTheme.primaryGreen,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: isDestructive ? AppTheme.errorRed : AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppTheme.textSecondary,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}