import 'package:flutter/material.dart';
import '../../models/user.dart';

class SecurityAccess extends StatefulWidget {
  final User currentUser;

  const SecurityAccess({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SecurityAccessState createState() => _SecurityAccessState();
}

class _SecurityAccessState extends State<SecurityAccess> {
  bool _twoFactorEnabled = false;
  bool _biometricEnabled = false;
  bool _autoLogoutEnabled = true;
  double _sessionTimeout = 30.0;
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Security & Access Control',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Authentication Settings
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Authentication Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Two-Factor Authentication'),
                    subtitle: const Text('Require a verification code in addition to password'),
                    value: _twoFactorEnabled,
                    onChanged: (value) {
                      setState(() {
                        _twoFactorEnabled = value;
                      });
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Biometric Authentication'),
                    subtitle: const Text('Allow fingerprint or face recognition login'),
                    value: _biometricEnabled,
                    onChanged: (value) {
                      setState(() {
                        _biometricEnabled = value;
                      });
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Auto Logout'),
                    subtitle: const Text('Automatically log out after period of inactivity'),
                    value: _autoLogoutEnabled,
                    onChanged: (value) {
                      setState(() {
                        _autoLogoutEnabled = value;
                      });
                    },
                  ),
                  if (_autoLogoutEnabled)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Session timeout: ${_sessionTimeout.round()} minutes'),
                          Slider(
                            value: _sessionTimeout,
                            min: 5,
                            max: 120,
                            divisions: 23,
                            label: '${_sessionTimeout.round()} minutes',
                            onChanged: (value) {
                              setState(() {
                                _sessionTimeout = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Role-Based Access Control
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Role-Based Access Control',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRoleAccessTable(),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Show dialog to edit role permissions
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Role Permissions'),
                  ),
                ],
              ),
            ),
          ),
          
          // Security Logs
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Security Logs',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSecurityLogsList(),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // View all logs
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('View All Logs'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRoleAccessTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Feature')),
            DataColumn(label: Text('Admin')),
            DataColumn(label: Text('Manager')),
            DataColumn(label: Text('Employee')),
            DataColumn(label: Text('Customer')),
          ],
          rows: [
            _buildRoleRow('User Management', true, true, false, false),
            _buildRoleRow('Station Management', true, true, true, false),
            _buildRoleRow('Analytics & Reports', true, true, false, false),
            _buildRoleRow('Billing Management', true, true, false, false),
            _buildRoleRow('System Settings', true, false, false, false),
          ],
        ),
      ),
    );
  }
  
  DataRow _buildRoleRow(String feature, bool admin, bool manager, bool employee, bool customer) {
    return DataRow(
      cells: [
        DataCell(Text(feature)),
        DataCell(Icon(admin ? Icons.check_circle : Icons.cancel, 
          color: admin ? Colors.green : Colors.red)),
        DataCell(Icon(manager ? Icons.check_circle : Icons.cancel, 
          color: manager ? Colors.green : Colors.red)),
        DataCell(Icon(employee ? Icons.check_circle : Icons.cancel, 
          color: employee ? Colors.green : Colors.red)),
        DataCell(Icon(customer ? Icons.check_circle : Icons.cancel, 
          color: customer ? Colors.green : Colors.red)),
      ],
    );
  }
  
  Widget _buildSecurityLogsList() {
    final logs = [
      {'user': 'John Doe', 'action': 'Login', 'time': '2023-05-15 14:32', 'status': 'Success'},
      {'user': 'Jane Smith', 'action': 'Password Change', 'time': '2023-05-15 12:18', 'status': 'Success'},
      {'user': 'Unknown IP', 'action': 'Login Attempt', 'time': '2023-05-14 23:45', 'status': 'Failed'},
      {'user': 'Admin', 'action': 'User Permission Change', 'time': '2023-05-14 16:20', 'status': 'Success'},
    ];
    
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.separated(
        itemCount: logs.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final log = logs[index];
          return ListTile(
            dense: true,
            leading: Icon(
              log['status'] == 'Success' ? Icons.check_circle : Icons.error,
              color: log['status'] == 'Success' ? Colors.green : Colors.red,
            ),
            title: Text('${log['action']} - ${log['user']}'),
            subtitle: Text(log['time'] as String),
            trailing: Text(
              log['status'] as String,
              style: TextStyle(
                color: log['status'] == 'Success' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
