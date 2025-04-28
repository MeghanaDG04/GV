import 'package:flutter/material.dart';
import '../../models/user.dart';

class NotificationsSettings extends StatefulWidget {
  final User user;

  const NotificationsSettings({Key? key, required this.user}) : super(key: key);

  @override
  _NotificationsSettingsState createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  bool _chargingStatusNotifications = true;
  bool _stationAvailabilityNotifications = true;
  bool _priceChangeNotifications = false;
  bool _promotionalNotifications = false;
  bool _systemUpdatesNotifications = true;
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _quietHoursEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notification Settings',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          
          // Notification types
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification Types',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  SwitchListTile(
                    title: const Text('Charging Status'),
                    subtitle: const Text('Get notified about your charging session status'),
                    value: _chargingStatusNotifications,
                    onChanged: (value) {
                      setState(() {
                        _chargingStatusNotifications = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    title: const Text('Station Availability'),
                    subtitle: const Text('Get notified when your favorite stations become available'),
                    value: _stationAvailabilityNotifications,
                    onChanged: (value) {
                      setState(() {
                        _stationAvailabilityNotifications = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    title: const Text('Price Changes'),
                    subtitle: const Text('Get notified about charging price changes'),
                    value: _priceChangeNotifications,
                    onChanged: (value) {
                      setState(() {
                        _priceChangeNotifications = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    title: const Text('Promotions & Offers'),
                    subtitle: const Text('Get notified about special offers and discounts'),
                    value: _promotionalNotifications,
                    onChanged: (value) {
                      setState(() {
                        _promotionalNotifications = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    title: const Text('System Updates'),
                    subtitle: const Text('Get notified about app updates and maintenance'),
                    value: _systemUpdatesNotifications,
                    onChanged: (value) {
                      setState(() {
                        _systemUpdatesNotifications = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Notification channels
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification Channels',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  SwitchListTile(
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Receive notifications on your device'),
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() {
                        _pushNotifications = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    title: const Text('Email Notifications'),
                    subtitle: Text('Send to ${widget.user.email}'),
                    value: _emailNotifications,
                    onChanged: (value) {
                      setState(() {
                        _emailNotifications = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    title: const Text('SMS Notifications'),
                    subtitle: const Text('Send to phone number'),
                    value: _smsNotifications,
                    onChanged: (value) {
                      setState(() {
                        _smsNotifications = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Quiet hours
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quiet Hours',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  SwitchListTile(
                    title: const Text('Enable Quiet Hours'),
                    subtitle: const Text('Mute notifications during specified hours'),
                    value: _quietHoursEnabled,
                    onChanged: (value) {
                      setState(() {
                        _quietHoursEnabled = value;
                      });
                    },
                  ),
                  
                  if (_quietHoursEnabled) ...[
                    const Divider(),
                    ListTile(
                      title: const Text('Quiet Hours Start'),
                      subtitle: const Text('10:00 PM'),
                      trailing: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () {
                          // Show time picker
                        },
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Quiet Hours End'),
                      subtitle: const Text('7:00 AM'),
                      trailing: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () {
                          // Show time picker
                        },
                      ),
                    ),
                  ],
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
                // Save notification settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notification settings saved'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Save Settings'),
            ),
          ),
        ],
      ),
    );
  }
}