import 'package:flutter/material.dart';

class SystemSettings extends StatefulWidget {
  const SystemSettings({Key? key}) : super(key: key);

  @override
  _SystemSettingsState createState() => _SystemSettingsState();
}

class _SystemSettingsState extends State<SystemSettings> {
  // System settings
  bool _maintenanceMode = false;
  bool _debugMode = false;
  double _sessionTimeout = 30;
  String _selectedLogLevel = 'Info';
  String _selectedBackupFrequency = 'Daily';
  
  // Notification settings
  bool _systemNotifications = true;
  bool _maintenanceNotifications = true;
  bool _userRegistrationNotifications = true;
  bool _paymentFailureNotifications = true;
  
  // API settings
  final TextEditingController _apiKeyController = TextEditingController(text: 'sk_test_51HG7LkJh2Y32SZVQvR5mTWKcfLHQQNcLlDfTJwGdL1QpTe2Ue8Jf4JKdS');
  final TextEditingController _webhookUrlController = TextEditingController(text: 'https://api.evcharger.com/webhooks');
  
  final List<String> _logLevels = [
    'Debug',
    'Info',
    'Warning',
    'Error',
    'Critical',
  ];
  
  final List<String> _backupFrequencies = [
    'Hourly',
    'Daily',
    'Weekly',
    'Monthly',
  ];

  @override
  void dispose() {
    _apiKeyController.dispose();
    _webhookUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Settings',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          
          // General System Settings
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'General System Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  SwitchListTile(
                    secondary: const Icon(Icons.build),
                    title: const Text('Maintenance Mode'),
                    subtitle: const Text('Put the system in maintenance mode'),
                    value: _maintenanceMode,
                    onChanged: (value) {
                      setState(() {
                        _maintenanceMode = value;
                      });
                      if (value) {
                        _showMaintenanceModeDialog();
                      }
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    secondary: const Icon(Icons.bug_report),
                    title: const Text('Debug Mode'),
                    subtitle: const Text('Enable detailed logging and debugging features'),
                    value: _debugMode,
                    onChanged: (value) {
                      setState(() {
                        _debugMode = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  ListTile(
                    leading: const Icon(Icons.timer),
                    title: const Text('Session Timeout (minutes)'),
                    subtitle: Text('${_sessionTimeout.toInt()} minutes'),
                    trailing: SizedBox(
                      width: 200,
                      child: Slider(
                        value: _sessionTimeout,
                        min: 5,
                        max: 120,
                        divisions: 23,
                        label: _sessionTimeout.toInt().toString(),
                        onChanged: (value) {
                          setState(() {
                            _sessionTimeout = value;
                          });
                        },
                      ),
                    ),
                  ),
                  
                  const Divider(),
                  
                  ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text('Log Level'),
                    subtitle: Text(_selectedLogLevel),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: () {
                      _showSelectionDialog(
                        title: 'Select Log Level',
                        options: _logLevels,
                        selectedOption: _selectedLogLevel,
                        onSelected: (logLevel) {
                          setState(() {
                            _selectedLogLevel = logLevel;
                          });
                        },
                      );
                    },
                  ),
                  
                  const Divider(),
                  
                  ListTile(
                    leading: const Icon(Icons.backup),
                    title: const Text('Database Backup Frequency'),
                    subtitle: Text(_selectedBackupFrequency),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: () {
                      _showSelectionDialog(
                        title: 'Select Backup Frequency',
                        options: _backupFrequencies,
                        selectedOption: _selectedBackupFrequency,
                        onSelected: (frequency) {
                          setState(() {
                            _selectedBackupFrequency = frequency;
                          });
                        },
                      );
                    },
                  ),
                  
                  const Divider(),
                  
                  ListTile(
                    leading: const Icon(Icons.storage),
                    title: const Text('Database Management'),
                    subtitle: const Text('Backup, restore, or clear database'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showDatabaseManagementDialog();
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Admin Notifications
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Notifications',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  SwitchListTile(
                    secondary: const Icon(Icons.system_update),
                    title: const Text('System Alerts'),
                    subtitle: const Text('Receive notifications about system events'),
                    value: _systemNotifications,
                    onChanged: (value) {
                      setState(() {
                        _systemNotifications = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    secondary: const Icon(Icons.engineering),
                    title: const Text('Maintenance Alerts'),
                    subtitle: const Text('Receive notifications about maintenance tasks'),
                    value: _maintenanceNotifications,
                    onChanged: (value) {
                      setState(() {
                        _maintenanceNotifications = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    secondary: const Icon(Icons.person_add),
                    title: const Text('New User Registrations'),
                    subtitle: const Text('Receive notifications when new users register'),
                    value: _userRegistrationNotifications,
                    onChanged: (value) {
                      setState(() {
                        _userRegistrationNotifications = value;
                      });
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    secondary: const Icon(Icons.payment),
                    title: const Text('Payment Failures'),
                    subtitle: const Text('Receive notifications about payment failures'),
                    value: _paymentFailureNotifications,
                    onChanged: (value) {
                      setState(() {
                        _paymentFailureNotifications = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // API Configuration
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'API Configuration',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: _apiKeyController,
                    decoration: InputDecoration(
                      labelText: 'API Key',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {
                          // Toggle visibility
                        },
                      ),
                    ),
                    obscureText: true,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: _webhookUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Webhook URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Test API connection
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('API connection successful'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Test Connection'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  // Regenerate API key
                                                  _showRegenerateApiKeyDialog();
                                                },
                                                icon: const Icon(Icons.refresh),
                                                label: const Text('Regenerate Key'),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.orange,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
          
                                const SizedBox(height: 24),
          
                                // System Logs
                                Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'System Logs',
                                          style: Theme.of(context).textTheme.titleLarge,
                                        ),
                                        const SizedBox(height: 16),
                  
                                        Container(
                                          height: 200,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: ListView(
                                            children: const [
                                              Text(
                                                '[2023-05-15 08:30:22] [INFO] System started successfully',
                                                style: TextStyle(color: Colors.green, fontFamily: 'monospace'),
                                              ),
                                              Text(
                                                '[2023-05-15 08:31:05] [INFO] Database connection established',
                                                style: TextStyle(color: Colors.green, fontFamily: 'monospace'),
                                              ),
                                              Text(
                                                '[2023-05-15 09:15:33] [WARNING] High CPU usage detected (85%)',
                                                style: TextStyle(color: Colors.orange, fontFamily: 'monospace'),
                                              ),
                                              Text(
                                                '[2023-05-15 10:22:17] [INFO] User ID 1042 logged in',
                                                style: TextStyle(color: Colors.green, fontFamily: 'monospace'),
                                              ),
                                              Text(
                                                '[2023-05-15 11:05:41] [ERROR] Payment gateway timeout',
                                                style: TextStyle(color: Colors.red, fontFamily: 'monospace'),
                                              ),
                                              Text(
                                                '[2023-05-15 11:06:22] [INFO] Payment gateway reconnected',
                                                style: TextStyle(color: Colors.green, fontFamily: 'monospace'),
                                              ),
                                              Text(
                                                '[2023-05-15 12:30:15] [INFO] Scheduled backup started',
                                                style: TextStyle(color: Colors.green, fontFamily: 'monospace'),
                                              ),
                                              Text(
                                                '[2023-05-15 12:32:08] [INFO] Backup completed successfully',
                                                style: TextStyle(color: Colors.green, fontFamily: 'monospace'),
                                              ),
                                            ],
                                          ),
                                        ),
                  
                                        const SizedBox(height: 16),
                  
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton.icon(
                                              onPressed: () {
                                                // Download logs
                                              },
                                              icon: const Icon(Icons.download),
                                              label: const Text('Download Logs'),
                                            ),
                                            const SizedBox(width: 16),
                                            TextButton.icon(
                                              onPressed: () {
                                                // Clear logs
                                                _showClearLogsDialog();
                                              },
                                              icon: const Icon(Icons.delete),
                                              label: const Text('Clear Logs'),
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.red,
                                              ),
                                            ),
                                          ],
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
                                      // Save system settings
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('System settings saved successfully'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: const Text('Save System Settings'),
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
  
                        void _showMaintenanceModeDialog() {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Enable Maintenance Mode?'),
                              content: const Text(
                                'Enabling maintenance mode will make the app inaccessible to regular users. Only administrators will be able to log in. Are you sure you want to continue?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _maintenanceMode = false;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Confirm maintenance mode
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Maintenance mode enabled'),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  },
                                  child: const Text('ENABLE'),
                                ),
                              ],
                            ),
                          );
                        }
  
                        void _showDatabaseManagementDialog() {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Database Management'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.backup),
                                    title: const Text('Backup Database'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      // Show backup in progress
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Database backup in progress...'),
                                          duration: Duration(seconds: 5),
                                        ),
                                      );
                                      // Simulate backup completion
                                      Future.delayed(const Duration(seconds: 5), () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Database backup completed successfully'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      });
                                    },
                                  ),
                                  const Divider(),
                                  ListTile(
                                    leading: const Icon(Icons.restore),
                                    title: const Text('Restore Database'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _showRestoreDatabaseDialog();
                                    },
                                  ),
                                  const Divider(),
                                  ListTile(
                                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                                    title: const Text(
                                      'Clear Database',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _showClearDatabaseDialog();
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('CLOSE'),
                                ),
                              ],
                            ),
                          );
                        }
  
                        void _showRestoreDatabaseDialog() {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Restore Database'),
                              content: const Text(
                                'Restoring the database will overwrite all current data. This action cannot be undone. Are you sure you want to continue?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Show restore in progress
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Database restore in progress...'),
                                        duration: Duration(seconds: 5),
                                      ),
                                    );
                                    // Simulate restore completion
                                    Future.delayed(const Duration(seconds: 5), () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Database restored successfully'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    });
                                  },
                                  child: const Text('RESTORE'),
                                ),
                              ],
                            ),
                          );
                        }
  
                        void _showClearDatabaseDialog() {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Clear Database'),
                              content: const Text(
                                'Clearing the database will permanently delete all data. This action cannot be undone. Are you sure you want to continue?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Show clear in progress
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Database clearing in progress...'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                    // Simulate clear completion
                                    Future.delayed(const Duration(seconds: 3), () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Database cleared successfully'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    });
                                  },
                                  child: const Text(
                                    'CLEAR',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
  
                        void _showRegenerateApiKeyDialog() {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Regenerate API Key'),
                              content: const Text(
                                'Regenerating the API key will invalidate the current key. All services using the current key will need to be updated. Are you sure you want to continue?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Generate new API key
                                    setState(() {
                                      _apiKeyController.text = 'sk_test_' + DateTime.now().millisecondsSinceEpoch.toString();
                                    });
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('API key regenerated successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  child: const Text('REGENERATE'),
                                ),
                              ],
                            ),
                          );
                        }
  
                        void _showClearLogsDialog() {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Clear System Logs'),
                              content: const Text(
                                'Are you sure you want to clear all system logs? This action cannot be undone.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('System logs cleared successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'CLEAR',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
}