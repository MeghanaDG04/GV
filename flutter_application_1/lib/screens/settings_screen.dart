import 'package:flutter/material.dart';
import '../widgets/settings/user_management.dart';
import '../widgets/settings/system_settings.dart';
import '../widgets/settings/station_management.dart';
import '../models/user.dart'; // Make sure to import the User model

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';
  final User currentUser;
  
  const SettingsScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 0;
  
  late final List<Widget> _settingsPanels;
  
  @override
  void initState() {
    super.initState();
    _settingsPanels = [
      UserManagement(currentUser: widget.currentUser),
      StationManagement(currentUser: widget.currentUser),
      const SystemSettings(),
    ];
  }
  
  final List<String> _settingsTitles = [    
    'User Management',
    'Station Management',
    'System Settings',
  ];
  
  final List<IconData> _settingsIcons = [
    Icons.people,
    Icons.ev_station,
    Icons.settings_applications,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Settings - ${_settingsTitles[_selectedIndex]}'),
      ),
      body: Row(
        children: [
          // Navigation rail for larger screens
          if (MediaQuery.of(context).size.width > 600)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: List.generate(
                _settingsTitles.length,
                (index) => NavigationRailDestination(
                  icon: Icon(_settingsIcons[index]),
                  label: Text(_settingsTitles[index]),
                ),
              ),
            ),
          
          // Expanded content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: _settingsPanels[_selectedIndex],
            ),
          ),
        ],
      ),
      
      // Bottom navigation for smaller screens
      bottomNavigationBar: MediaQuery.of(context).size.width <= 600
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: List.generate(
                _settingsTitles.length,
                (index) => BottomNavigationBarItem(
                  icon: Icon(_settingsIcons[index]),
                  label: _settingsTitles[index],
                ),
              ),
            )
          : null,
    );
  }
}
