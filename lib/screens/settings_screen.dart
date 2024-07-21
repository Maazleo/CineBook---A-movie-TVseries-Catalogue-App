import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _twoFactorAuthEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedRegion = 'PAKISTAN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.cyan,

      ),
      body: ListView(
        children: [
          _buildSectionHeader('Profile'),
          _buildProfileSection(),

          _buildSectionHeader('Account Settings'),
          _buildAccountSettings(),

          _buildSectionHeader('Notification Settings'),
          _buildNotificationSettings(),

          _buildSectionHeader('Appearance Settings'),
          _buildAppearanceSettings(),

          _buildSectionHeader('Security Settings'),
          _buildSecuritySettings(),

          _buildSectionHeader('App Settings'),
          _buildAppSettings(),

          _buildSectionHeader('Help & Support'),
          _buildHelpSupport(),

          _buildSectionHeader('About'),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
         const CircleAvatar(
          backgroundImage: AssetImage('lib/images/splash.png'),
           radius: 90,
           // Replace with actual URL
        ),
        Center(
          child: ListTile(

            title: Center(child: const Text('Maaz Denk',style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400 ),)),
            subtitle: Center(child: const Text('maazmasroorhuss.com')),
            trailing: const Icon(Icons.edit),
            onTap: () => Navigator.of(context).pushNamed('/profile'),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      children: [
        ListTile(
          title: const Text('Change Password'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to change password screen
          },
        ),
        ListTile(
          title: const Text('Privacy Settings'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to privacy settings screen
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Enable Notifications'),
          value: _notificationsEnabled,
          onChanged: (bool value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Enable Sound'),
          value: _soundEnabled,
          onChanged: (bool value) {
            setState(() {
              _soundEnabled = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAppearanceSettings() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Dark Mode'),
          value: _darkMode,
          onChanged: (bool value) {
            setState(() {
              _darkMode = value;
            });
          },
        ),
        ListTile(
          title: const Text('Select Theme'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to theme selection screen
          },
        ),
      ],
    );
  }

  Widget _buildSecuritySettings() {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('Enable Two-Factor Authentication'),
          value: _twoFactorAuthEnabled,
          onChanged: (bool value) {
            setState(() {
              _twoFactorAuthEnabled = value;
            });
          },
        ),
        ListTile(
          title: const Text('Manage Devices'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to manage devices screen
          },
        ),
      ],
    );
  }

  Widget _buildAppSettings() {
    return Column(
      children: [
        ListTile(
          title: const Text('Language'),
          subtitle: Text(_selectedLanguage),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to language selection screen
          },
        ),
        ListTile(
          title: const Text('Region'),
          subtitle: Text(_selectedRegion),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to region selection screen
          },
        ),
      ],
    );
  }

  Widget _buildHelpSupport() {
    return Column(
      children: [
        ListTile(
          title: const Text('FAQs'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to FAQs screen
          },
        ),
        ListTile(
          title: const Text('Contact Support'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to contact support screen
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      children: [
        const ListTile(
          title: Text('App Version'),
          subtitle: Text('1.0.0'), // Replace with actual version
        ),
        ListTile(
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to terms of service screen
          },
        ),
        ListTile(
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Navigate to privacy policy screen
          },
        ),
      ],
    );
  }
}
