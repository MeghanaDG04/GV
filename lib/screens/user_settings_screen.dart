import 'package:flutter/material.dart';
import '../widgets/settings/profile_settings.dart';
import '../widgets/settings/vehicle_settings.dart';
import '../models/user.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  int _selectedIndex = 0;
  
  // Create a mock user for testing
  static final User currentUser = User(
    id: '1',
    name: 'John Doe',
    email: 'john.doe@example.com',
    photoUrl: 'assets/icons/default_profile.png',
    role:UserRole.user
  );
  
  final List<Widget> _settingsPanels = [
    ProfileSettings(user: currentUser),
    const VehicleSettings(),
    // Placeholder widgets for the other settings panels
    const Center(child: Text('Payment History - Coming Soon')),
    const Center(child: Text('Favorite Stations - Coming Soon')),
  ];  
  final List<String> _settingsTitles = [
    'Profile',
    'Vehicles',
    'Payment History',
    'Favorite Stations',
  ];
  
  final List<IconData> _settingsIcons = [
    Icons.person,
    Icons.electric_car,
    Icons.receipt_long,
    Icons.star,
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings - ${_settingsTitles[_selectedIndex]}'),
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
              type: BottomNavigationBarType.fixed,
            )
          : null,
    );
  }
}
