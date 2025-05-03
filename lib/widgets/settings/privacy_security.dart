import 'package:flutter/material.dart';
import '../../models/user.dart';

class PrivacySecurity extends StatefulWidget {
  final User user;

  const PrivacySecurity({Key? key, required this.user}) : super(key: key);

  @override
  _PrivacySecurityState createState() => _PrivacySecurityState();
}

class _PrivacySecurityState extends State<PrivacySecurity> {
  bool _twoFactorEnabled = false;
  bool _locationSharing = true;
  bool _usageDataSharing = true;
  bool _marketingConsent = false;
  bool _biometricLogin = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy & Security',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          
          // Account Security
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Security',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    leading: const Icon(Icons.password),
                    title: const Text('Change Password'),
                    subtitle: const Text('Last changed 3 months ago'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to change password screen
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    secondary: const Icon(Icons.security),
                    title: const Text('Two-Factor Authentication'),
                    subtitle: const Text('Add an extra layer of security'),
                    value: _twoFactorEnabled,
                    onChanged: (value) {
                      setState(() {
                        _twoFactorEnabled = value;
                      });
                      if (value) {
                        // Show 2FA setup dialog
                      }
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    secondary: const Icon(Icons.fingerprint),
                    title: const Text('Biometric Login'),
                    subtitle: const Text('Use fingerprint or face recognition to log in'),
                    value: _biometricLogin,
                    onChanged: (value) {
                      setState(() {
                        _biometricLogin = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  ListTile(
                    leading: const Icon(Icons.devices),
                    title: const Text('Manage Devices'),
                    subtitle: const Text('See devices logged into your account'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to devices screen
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Privacy Settings
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  SwitchListTile(
                    secondary: const Icon(Icons.location_on),
                    title: const Text('Location Sharing'),
                    subtitle: const Text('Share your location to find nearby charging stations'),
                    value: _locationSharing,
                    onChanged: (value) {
                      setState(() {
                        _locationSharing = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    secondary: const Icon(Icons.data_usage),
                    title: const Text('Usage Data Sharing'),
                    subtitle: const Text('Share anonymous usage data to improve our service'),
                    value: _usageDataSharing,
                    onChanged: (value) {
                      setState(() {
                        _usageDataSharing = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    secondary: const Icon(Icons.campaign),
                    title: const Text('Marketing Communications'),
                    subtitle: const Text('Receive promotional emails and offers'),
                    value: _marketingConsent,
                    onChanged: (value) {
                      setState(() {
                        _marketingConsent = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Data Management
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Management',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: const Text('Download Your Data'),
                    subtitle: const Text('Get a copy of your personal data'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Handle data download
                    },
                  ),
                  
                  const Divider(),
                  
                  ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: const Text('Delete Account'),
                    subtitle: const Text('Permanently delete your account and data'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Show delete account confirmation
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Account?'),
                          content: const Text(
                            'This action cannot be undone. All your data will be permanently deleted.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Handle account deletion
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'DELETE',
                                style: TextStyle(color: Colors.red),
                              ),
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
          
          // Privacy Policy
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Legal',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    leading: const Icon(Icons.policy),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Open privacy policy
                    },
                  ),
                  
                  const Divider(),
                  
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Terms of Service'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Open terms of service
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
                // Save privacy and security settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Privacy & security settings saved'),
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