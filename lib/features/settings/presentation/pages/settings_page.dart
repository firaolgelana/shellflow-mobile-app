import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 1. Imports for Injection and Bloc
import '../../../../injection_container.dart'; 
import '../bloc/settings_bloc.dart';
import '../widgets/settings_utils.dart'; // Your utils file

// 2. Imports for Entities (Needed for Enums and Types)
import 'package:shell_flow_mobile_app/features/settings/domain/entities/user_setting.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/preference.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/privacy.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Provide the Bloc
    return BlocProvider(
      create: (context) => sl<SettingsBloc>()..add(LoadSettingsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        // 4. Consume the State
        body: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
            // Optional: Handle AccountDeletedSuccess navigation here
          },
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SettingsLoaded) {
              // Pass the real data to the content widget
              return _SettingsContent(settings: state.userSetting);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  final UserSetting settings;

  const _SettingsContent({required this.settings});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // --- 1. ACCOUNT SECTION ---
        SettingsUtils.buildSectionHeader('Account'),
        ListTile(
          leading: const Icon(Icons.email_outlined),
          title: const Text('Email'),
          subtitle: Text(settings.account.email), // Real Data
        ),
        ListTile(
          leading: const Icon(Icons.phone_android),
          title: const Text('Phone'),
          subtitle: Text(settings.account.phoneNumber ?? 'Not linked'), // Real Data
        ),
        ListTile(
          leading: const Icon(Icons.star_border),
          title: const Text('Plan'),
          subtitle: Text(settings.account.planType), // Real Data
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigate to Upgrade Plan page')),
            );
          },
        ),

        const Divider(),

        // --- 2. PREFERENCES SECTION ---
        SettingsUtils.buildSectionHeader('Preferences'),
        SwitchListTile(
          secondary: const Icon(Icons.dark_mode_outlined),
          title: const Text('Dark Mode'),
          // Map Enum to Bool
          value: settings.preference.theme == AppTheme.dark,
          onChanged: (val) {
            // Dispatch Theme Event
            // context.read<SettingsBloc>().add(UpdatePreferenceEvent(val));
          },
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          subtitle: Text(_getLanguageName(settings.preference.languageCode)),
          trailing: const Icon(Icons.arrow_drop_down),
          onTap: () => _showLanguageDialog(context),
        ),

        const Divider(),

        // --- 3. NOTIFICATIONS SECTION ---
        SettingsUtils.buildSectionHeader('Notifications'),
        SwitchListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Receive alerts on this device'),
          value: settings.notifications.pushEnabled,
          onChanged: (val) {
            // Create modified object
            final newSettings = settings.notifications.copyWith(pushEnabled: val);
            // Dispatch Update Event
            context.read<SettingsBloc>().add(UpdateNotificationEvent(newSettings));
          },
        ),
        SwitchListTile(
          title: const Text('Email Updates'),
          subtitle: const Text('Receive summaries via email'),
          value: settings.notifications.emailEnabled,
          onChanged: (val) {
            final newSettings = settings.notifications.copyWith(emailEnabled: val);
            context.read<SettingsBloc>().add(UpdateNotificationEvent(newSettings));
          },
        ),

        const Divider(),

        // --- 4. PRIVACY & SECURITY SECTION ---
        SettingsUtils.buildSectionHeader('Privacy & Security'),
        SwitchListTile(
          secondary: const Icon(Icons.lock_outline),
          title: const Text('Private Profile'),
          subtitle: const Text('Only friends can see your activity'),
          value: settings.privacy.isProfilePrivate,
          onChanged: (val) {
            final newPrivacy = settings.privacy.copyWith(isProfilePrivate: val);
            context.read<SettingsBloc>().add(UpdatePrivacyEvent(newPrivacy));
          },
        ),
        ListTile(
          leading: const Icon(Icons.visibility_off_outlined),
          title: const Text('Default Task Visibility'),
          subtitle: Text(_getVisibilityName(settings.privacy.defaultTaskVisibility)),
          trailing: const Icon(Icons.arrow_drop_down),
          onTap: () => _showVisibilityDialog(context),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.fingerprint),
          title: const Text('Biometric Login'),
          value: settings.security.biometricsEnabled,
          onChanged: (val) {
            final newSecurity = settings.security.copyWith(biometricsEnabled: val);
            context.read<SettingsBloc>().add(UpdateSecurityEvent(newSecurity));
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
            onPressed: () {
              // We use the Utils, but pass a callback to fire the Bloc event
              _showDeleteDialog(context);
            },
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
    );
  }

  // --- Helper Methods ---

  String _getLanguageName(String code) {
    switch (code) {
      case 'es': return 'Spanish';
      case 'am': return 'Amharic';
      default: return 'English';
    }
  }

  String _getVisibilityName(TaskVisibility visibility) {
    switch (visibility) {
      case TaskVisibility.public: return 'Everyone';
      case TaskVisibility.friendsOnly: return 'Friends Only';
      case TaskVisibility.private: return 'Only Me';
    }
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select Language'),
        children: [
          _buildLanguageOption(context, ctx, 'English', 'en'),
          _buildLanguageOption(context, ctx, 'Spanish', 'es'),
          _buildLanguageOption(context, ctx, 'Amharic', 'am'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, BuildContext dialogContext, String name, String code) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(dialogContext);
        final newPref = settings.preference.copyWith(languageCode: code);
        context.read<SettingsBloc>().add(UpdatePreferenceEvent(newPref));
      },
      child: Text(name),
    );
  }

  void _showVisibilityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Task Visibility'),
        children: [
          _buildVisibilityOption(context, ctx, 'Everyone', TaskVisibility.public),
          _buildVisibilityOption(context, ctx, 'Friends Only', TaskVisibility.friendsOnly),
          _buildVisibilityOption(context, ctx, 'Only Me', TaskVisibility.private),
        ],
      ),
    );
  }

  Widget _buildVisibilityOption(BuildContext context, BuildContext dialogContext, String name, TaskVisibility vis) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(dialogContext);
        final newPrivacy = settings.privacy.copyWith(defaultTaskVisibility: vis);
        context.read<SettingsBloc>().add(UpdatePrivacyEvent(newPrivacy));
      },
      child: Text(name),
    );
  }

  void _showDeleteDialog(BuildContext context) {
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
              // DISPATCH DELETE EVENT
              context.read<SettingsBloc>().add(DeleteAccountEvent());
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}