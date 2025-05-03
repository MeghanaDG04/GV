import 'package:flutter/material.dart';
import '../../models/user.dart';

class AppPreferences extends StatefulWidget {
  final User user;

  const AppPreferences({Key? key, required this.user}) : super(key: key);

  @override
  _AppPreferencesState createState() => _AppPreferencesState();
}

class _AppPreferencesState extends State<AppPreferences> {
  String _selectedLanguage = 'English';
  String _selectedTheme = 'System Default';
  String _selectedChargerType = 'All Types';
  String _distanceUnit = 'Miles';
  String _currencyUnit = 'USD (\$)';
  bool _showFavoriteStationsFirst = true;
  bool _autoStartCharging = false;
  bool _mapTrafficView = true;
  
  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
  ];
  
  final List<String> _themes = [
    'System Default',
    'Light Mode',
    'Dark Mode',
  ];
  
  final List<String> _chargerTypes = [
    'All Types',
    'Type 2',
    'CCS',
    'CHAdeMO',
    'Tesla Supercharger',
  ];
  
  final List<String> _distanceUnits = [
    'Miles',
    'Kilometers',
  ];
  
  final List<String> _currencyUnits = [
    'USD (\$)',
    'EUR (€)',
    'GBP (£)',
    'JPY (¥)',
    'CNY (¥)',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App Preferences',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          
          // Appearance
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  // Language selection
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    subtitle: Text(_selectedLanguage),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: () {
                      _showSelectionDialog(
                        title: 'Select Language',
                        options: _languages,
                        selectedOption: _selectedLanguage,
                        onSelected: (language) {
                          setState(() {
                            _selectedLanguage = language;
                          });
                        },
                      );
                    },
                  ),
                  
                  const Divider(),
                  
                  // Theme selection
                  ListTile(
                    leading: const Icon(Icons.brightness_6),
                    title: const Text('Theme'),
                    subtitle: Text(_selectedTheme),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: () {
                      _showSelectionDialog(
                        title: 'Select Theme',
                        options: _themes,
                        selectedOption: _selectedTheme,
                        onSelected: (theme) {
                          setState(() {
                            _selectedTheme = theme;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Charging Preferences
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Charging Preferences',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  // Preferred charger type
                  ListTile(
                    leading: const Icon(Icons.ev_station),
                    title: const Text('Preferred Charger Type'),
                    subtitle: Text(_selectedChargerType),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: () {
                      _showSelectionDialog(
                        title: 'Select Preferred Charger Type',
                        options: _chargerTypes,
                        selectedOption: _selectedChargerType,
                        onSelected: (chargerType) {
                          setState(() {
                            _selectedChargerType = chargerType;
                          });
                        },
                      );
                    },
                  ),
                  
                  const Divider(),
                  
                  // Show favorite stations first
                  SwitchListTile(
                    secondary: const Icon(Icons.favorite),
                    title: const Text('Show Favorite Stations First'),
                    subtitle: const Text('Prioritize your favorite stations in search results'),
                    value: _showFavoriteStationsFirst,
                    onChanged: (value) {
                      setState(() {
                        _showFavoriteStationsFirst = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  // Auto-start charging
                  SwitchListTile(
                    secondary: const Icon(Icons.play_circle_outline),
                    title: const Text('Auto-Start Charging'),
                    subtitle: const Text('Automatically start charging when connected'),
                    value: _autoStartCharging,
                    onChanged: (value) {
                      setState(() {
                        _autoStartCharging = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Display Settings
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Display Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  // Distance units selection
                  ListTile(
                    leading: const Icon(Icons.straighten),
                    title: const Text('Distance Units'),
                    subtitle: Text(_distanceUnit),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: () {
                      _showSelectionDialog(
                        title: 'Select Distance Unit',
                        options: _distanceUnits,
                        selectedOption: _distanceUnit,
                        onSelected: (unit) {
                          setState(() {
                            _distanceUnit = unit;
                          });
                        },
                      );
                    },
                  ),
                  
                  const Divider(),
                  
                  // Currency units selection
                  ListTile(
                    leading: const Icon(Icons.attach_money),
                    title: const Text('Currency'),
                    subtitle: Text(_currencyUnit),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: () {
                      _showSelectionDialog(
                        title: 'Select Currency',
                        options: _currencyUnits,
                        selectedOption: _currencyUnit,
                        onSelected: (currency) {
                          setState(() {
                            _currencyUnit = currency;
                          });
                        },
                      );
                    },
                  ),
                  
                  const Divider(),
                  
                  // Map traffic view
                  SwitchListTile(
                    secondary: const Icon(Icons.map),
                    title: const Text('Show Traffic on Map'),
                    subtitle: const Text('Display traffic information on the map'),
                    value: _mapTrafficView,
                    onChanged: (value) {
                      setState(() {
                        _mapTrafficView = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Reset preferences
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reset Options',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    leading: const Icon(Icons.refresh, color: Colors.orange),
                    title: const Text('Reset to Default Settings'),
                    subtitle: const Text('Restore all app preferences to default values'),
                    onTap: () {
                      // Show reset confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Reset Settings?'),
                          content: const Text(
                            'This will reset all app preferences to their default values. This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Reset settings to default
                                setState(() {
                                  _selectedLanguage = 'English';
                                  _selectedTheme = 'System Default';
                                  _selectedChargerType = 'All Types';
                                  _distanceUnit = 'Miles';
                                  _currencyUnit = 'USD (\$)';
                                  _showFavoriteStationsFirst = true;
                                  _autoStartCharging = false;
                                  _mapTrafficView = true;
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Settings reset to defaults'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              child: const Text('RESET'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Save app preferences
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('App preferences saved'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Save Preferences'),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showSelectionDialog({
    required String title,
    required List<String> options,
    required String selectedOption,
    required Function(String) onSelected,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedOption,
                onChanged: (value) {
                  if (value != null) {
                    onSelected(value);
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }
}
