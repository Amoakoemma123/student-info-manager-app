import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/student_provider.dart';
import '../utils/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _autoBackupEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          _buildUserProfileSection(),
          const SizedBox(height: 16),
          _buildAppearanceSection(),
          const SizedBox(height: 16),
          _buildPreferencesSection(),
          const SizedBox(height: 16),
          _buildDataSection(),
          const SizedBox(height: 16),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'User Profile',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    child: Text(
                      authProvider.username.isNotEmpty
                          ? authProvider.username[0].toUpperCase()
                          : 'U',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(authProvider.username.isNotEmpty ? authProvider.username : 'User'),
                  subtitle: Text('Role: ${authProvider.role}'),
                  trailing: IconButton(
                    onPressed: () {
                      // TODO: Implement profile editing
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile editing coming soon!'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppearanceSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: AppTheme.secondaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Switch between light and dark themes'),
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
                // TODO: Implement theme switching
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${value ? 'Dark' : 'Light'} mode coming soon!'),
                  ),
                );
              },
              secondary: Icon(
                _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: AppTheme.secondaryColor,
              ),
            ),
            ListTile(
              title: const Text('Language'),
              subtitle: Text('Current: $_selectedLanguage'),
              leading: Icon(
                Icons.language,
                color: AppTheme.secondaryColor,
              ),
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                items: ['English', 'Spanish', 'French', 'German'].map((language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  // TODO: Implement language switching
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tune,
                  color: AppTheme.accentColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Preferences',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Notifications'),
              subtitle: const Text('Enable push notifications'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                // TODO: Implement notification settings
              },
              secondary: Icon(
                Icons.notifications,
                color: AppTheme.accentColor,
              ),
            ),
            SwitchListTile(
              title: const Text('Auto Backup'),
              subtitle: const Text('Automatically backup data'),
              value: _autoBackupEnabled,
              onChanged: (value) {
                setState(() {
                  _autoBackupEnabled = value;
                });
                // TODO: Implement auto backup
              },
              secondary: Icon(
                Icons.backup,
                color: AppTheme.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.storage,
                  color: AppTheme.warningColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Data Management',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.warningColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<StudentProvider>(
              builder: (context, studentProvider, child) {
                return ListTile(
                  title: const Text('Export Data'),
                  subtitle: const Text('Export student data to CSV/Excel'),
                  leading: Icon(
                    Icons.download,
                    color: AppTheme.warningColor,
                  ),
                  onTap: () {
                    // TODO: Implement data export
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data export coming soon!'),
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text('Import Data'),
              subtitle: const Text('Import student data from file'),
              leading: Icon(
                Icons.upload,
                color: AppTheme.warningColor,
              ),
              onTap: () {
                // TODO: Implement data import
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data import coming soon!'),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Clear All Data'),
              subtitle: const Text('Remove all student records'),
              leading: Icon(
                Icons.delete_forever,
                color: AppTheme.errorColor,
              ),
              onTap: () {
                _showClearDataDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Version'),
              subtitle: const Text('1.0.0'),
              leading: Icon(
                Icons.app_settings_alt,
                color: AppTheme.primaryColor,
              ),
            ),
            ListTile(
              title: const Text('Developer'),
              subtitle: const Text('Student Management System Team'),
              leading: Icon(
                Icons.code,
                color: AppTheme.primaryColor,
              ),
            ),
            ListTile(
              title: const Text('Privacy Policy'),
              leading: Icon(
                Icons.privacy_tip,
                color: AppTheme.primaryColor,
              ),
              onTap: () {
                // TODO: Show privacy policy
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Privacy policy coming soon!'),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Terms of Service'),
              leading: Icon(
                Icons.description,
                color: AppTheme.primaryColor,
              ),
              onTap: () {
                // TODO: Show terms of service
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terms of service coming soon!'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This action will permanently delete all student records. This action cannot be undone. Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllData();
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _clearAllData() {
    // TODO: Implement data clearing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data clearing coming soon!'),
      ),
    );
  }
}