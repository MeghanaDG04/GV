import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/settings/profile_settings.dart';
import '../widgets/settings/payment_billing.dart';
import '../widgets/settings/notifications_settings.dart';
import '../widgets/settings/privacy_security.dart';
import '../widgets/settings/app_preferences.dart';
import '../widgets/settings/help_support.dart';
import '../widgets/settings/user_management.dart';
import '../widgets/settings/station_management.dart';
import '../widgets/settings/analytics_reports.dart';
import '../widgets/settings/security_access.dart';
import '../widgets/settings/system_integrations.dart';

class SettingsPage extends StatefulWidget {
  final User currentUser;

  const SettingsPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late int _selectedIndex;
  late List<Map<String, dynamic>> _settingsSections;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _initSettingsSections();
  }

  void _initSettingsSections() {
    // Common settings for all users
    _settingsSections = [
      {
        'title': 'Profile',
        'icon': Icons.person,
        'widget': ProfileSettings(user: widget.currentUser),
      },
      {
        'title': 'Payment & Billing',
        'icon': Icons.payment,
        'widget': PaymentBilling(user: widget.currentUser),
      },
      {
        'title': 'Notifications',
        'icon': Icons.notifications,
        'widget': NotificationsSettings(user: widget.currentUser),
      },
      {
        'title': 'Privacy & Security',
        'icon': Icons.security,
        'widget': PrivacySecurity(user: widget.currentUser),
      },
      {
        'title': 'App Preferences',
        'icon': Icons.settings,
        'widget': AppPreferences(user: widget.currentUser),
      },
      {
        'title': 'Help & Support',
        'icon': Icons.help,
        'widget': HelpSupport(user: widget.currentUser),
      },
    ];

    // Add admin-specific settings
    if (widget.currentUser.role == UserRole.admin) {
      _settingsSections.addAll([
        {
          'title': 'User Management',
          'icon': Icons.people,
          'widget': UserManagement(currentUser: widget.currentUser),
        },
        {
          'title': 'Station Management',
          'icon': Icons.ev_station,
          'widget': StationManagement(currentUser: widget.currentUser),
        },
        {
          'title': 'Analytics & Reports',
          'icon': Icons.analytics,
          'widget': AnalyticsReports(currentUser: widget.currentUser),
        },
        {
          'title': 'Security & Access Control',
          'icon': Icons.admin_panel_settings,
          'widget': SecurityAccess(currentUser: widget.currentUser),
        },
        {
          'title': 'System Integrations',
          'icon': Icons.integration_instructions,
          'widget': SystemIntegrations(currentUser: widget.currentUser),
        },
      ]);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: Row(
        children: [
          // Settings navigation sidebar
          Container(
            width: 250,
            color: Theme.of(context).colorScheme.surface,
            child: ListView.builder(
              itemCount: _settingsSections.length,
              itemBuilder: (context, index) {
                final section = _settingsSections[index];
                return ListTile(
                  leading: Icon(
                    section['icon'],
                    color: _selectedIndex == index
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  title: Text(
                    section['title'],
                    style: TextStyle(
                      fontWeight: _selectedIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _selectedIndex == index
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                  selected: _selectedIndex == index,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          // Vertical divider
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Theme.of(context).dividerColor,
          ),
          // Settings content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _settingsSections[_selectedIndex]['widget'],
            ),
          ),
        ],
      ),
    );
  }
}
