import 'package:flutter/material.dart';
import '../../models/user.dart';

class SystemIntegrations extends StatefulWidget {
  final User currentUser;

  const SystemIntegrations({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SystemIntegrationsState createState() => _SystemIntegrationsState();
}

class _SystemIntegrationsState extends State<SystemIntegrations> {
  final List<Map<String, dynamic>> _integrations = [
    {
      'name': 'Payment Gateway',
      'provider': 'Stripe',
      'status': 'Connected',
      'icon': Icons.payment,
      'isActive': true,
    },
    {
      'name': 'CRM System',
      'provider': 'Salesforce',
      'status': 'Connected',
      'icon': Icons.people,
      'isActive': true,
    },
    {
      'name': 'Email Service',
      'provider': 'SendGrid',
      'status': 'Connected',
      'icon': Icons.email,
      'isActive': true,
    },
    {
      'name': 'Analytics Platform',
      'provider': 'Google Analytics',
      'status': 'Connected',
      'icon': Icons.analytics,
      'isActive': true,
    },
    {
      'name': 'Cloud Storage',
      'provider': 'AWS S3',
      'status': 'Connected',
      'icon': Icons.cloud,
      'isActive': true,
    },
    {
      'name': 'SMS Gateway',
      'provider': 'Twilio',
      'status': 'Not Connected',
      'icon': Icons.sms,
      'isActive': false,
    },
    {
      'name': 'Social Media',
      'provider': 'Not Configured',
      'status': 'Not Connected',
      'icon': Icons.share,
      'isActive': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Integrations',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // API Keys and Credentials
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'API Keys and Credentials',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildApiKeyField('Public API Key', 'pk_live_*****************'),
                  _buildApiKeyField('Secret API Key', '••••••••••••••••••••••••'),
                  _buildApiKeyField('Webhook Secret', '••••••••••••••••••••••••'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Show API key management dialog
                        },
                        icon: const Icon(Icons.vpn_key),
                        label: const Text('Manage API Keys'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Show API documentation
                        },
                        icon: const Icon(Icons.description),
                        label: const Text('API Documentation'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Integrated Services
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Integrated Services',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Add new integration
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Integration'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _integrations.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final integration = _integrations[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: integration['isActive'] 
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          child: Icon(
                            integration['icon'] as IconData,
                            color: integration['isActive']
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                        title: Text(integration['name'] as String),
                        subtitle: Text(integration['provider'] as String),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Chip(
                              label: Text(
                                integration['status'] as String,
                                style: TextStyle(
                                  color: integration['isActive']
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                              backgroundColor: integration['isActive']
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () {
                                // Configure integration
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          // Open integration details
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Webhooks
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Webhooks',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Add new webhook
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Webhook'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildWebhooksList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildApiKeyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () {
                      // Copy to clipboard
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWebhooksList() {
    final webhooks = [
      {
        'event': 'payment.success',
        'url': 'https://example.com/webhooks/payment',
        'active': true,
      },
      {
        'event': 'user.signup',
        'url': 'https://example.com/webhooks/users',
        'active': true,
      },
      {
        'event': 'station.status',
        'url': 'https://example.com/webhooks/stations',
        'active': false,
      },
    ];
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: webhooks.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final webhook = webhooks[index];
          return ListTile(
            title: Text(webhook['event'] as String),
            subtitle: Text(webhook['url'] as String),
            trailing: Switch(
              value: webhook['active'] as bool,
              onChanged: (value) {
                // Toggle webhook active status
              },
            ),
            onTap: () {
              // Edit webhook
            },
          );
        },
      ),
    );
  }
}
