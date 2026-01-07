import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // --- DUMMY STATE (Replace with Bloc state later) ---
  bool _isDarkMode = false;
  bool _pushEnabled = true;
  bool _emailEnabled = false;
  bool _isProfilePrivate = false;
  bool _biometricsEnabled = true;
  String _language = 'English';
  String _taskVisibility = 'Friends Only';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue, // Or Theme.of(context).primaryColor
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // --- 1. ACCOUNT SECTION ---
          _buildSectionHeader('Account'),
          const ListTile(
            leading: Icon(Icons.email_outlined),
            title: Text('Email'),
            subtitle: Text('firaol@example.com'), // Dummy Data
          ),
          const ListTile(
            leading: Icon(Icons.phone_android),
            title: Text('Phone'),
            subtitle: Text('+251 911 22 33 44'), // Dummy Data
          ),
          ListTile(
            leading: const Icon(Icons.star_border),
            title: const Text('Plan'),
            subtitle: const Text('Free Tier'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigate to Upgrade Plan page')),
              );
            },
          ),

          const Divider(),

          // --- 2. PREFERENCES SECTION ---
          _buildSectionHeader('Preferences'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (val) {
              setState(() => _isDarkMode = val);
              // Later: context.read<SettingsBloc>().add(ThemeChangedEvent(val));
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(_language),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: () => _showLanguageDialog(),
          ),

          const Divider(),

          // --- 3. NOTIFICATIONS SECTION ---
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive alerts on this device'),
            value: _pushEnabled,
            onChanged: (val) {
              setState(() => _pushEnabled = val);
            },
          ),
          SwitchListTile(
            title: const Text('Email Updates'),
            subtitle: const Text('Receive summaries via email'),
            value: _emailEnabled,
            onChanged: (val) {
              setState(() => _emailEnabled = val);
            },
          ),

          const Divider(),

          // --- 4. PRIVACY & SECURITY SECTION ---
          _buildSectionHeader('Privacy & Security'),
          SwitchListTile(
            secondary: const Icon(Icons.lock_outline),
            title: const Text('Private Profile'),
            subtitle: const Text('Only friends can see your activity'),
            value: _isProfilePrivate,
            onChanged: (val) {
              setState(() => _isProfilePrivate = val);
            },
          ),
          ListTile(
            leading: const Icon(Icons.visibility_off_outlined),
            title: const Text('Default Task Visibility'),
            subtitle: Text(_taskVisibility),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: () => _showVisibilityDialog(),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: const Text('Biometric Login'),
            value: _biometricsEnabled,
            onChanged: (val) {
              setState(() => _biometricsEnabled = val);
            },
          ),

          const Divider(),
          const SizedBox(height: 20),

          // --- 5. DANGER ZONE ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () => _showDeleteConfirmation(context),
              child: const Text('Delete Account'),
            ),
          ),
          const SizedBox(height: 40),
          
          // Version Info
          const Center(
            child: Text(
              'v1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- Helper Widgets & Methods ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select Language'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              setState(() => _language = 'English');
              Navigator.pop(ctx);
            },
            child: const Text('English'),
          ),
          SimpleDialogOption(
            onPressed: () {
              setState(() => _language = 'Spanish');
              Navigator.pop(ctx);
            },
            child: const Text('Spanish'),
          ),
          SimpleDialogOption(
            onPressed: () {
              setState(() => _language = 'Amharic');
              Navigator.pop(ctx);
            },
            child: const Text('Amharic'),
          ),
        ],
      ),
    );
  }

  void _showVisibilityDialog() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Task Visibility'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              setState(() => _taskVisibility = 'Everyone');
              Navigator.pop(ctx);
            },
            child: const Text('Everyone'),
          ),
          SimpleDialogOption(
            onPressed: () {
              setState(() => _taskVisibility = 'Friends Only');
              Navigator.pop(ctx);
            },
            child: const Text('Friends Only'),
          ),
          SimpleDialogOption(
            onPressed: () {
              setState(() => _taskVisibility = 'Only Me');
              Navigator.pop(ctx);
            },
            child: const Text('Only Me'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This action is irreversible. All your data will be lost immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              // Perform delete logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion requested')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}