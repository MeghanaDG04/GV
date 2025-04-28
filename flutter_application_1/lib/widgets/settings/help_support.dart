import 'package:flutter/material.dart';
import '../../models/user.dart';

class HelpSupport extends StatefulWidget {
  final User user;

  const HelpSupport({Key? key, required this.user}) : super(key: key);

  @override
  _HelpSupportState createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  final TextEditingController _issueController = TextEditingController();
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I start a charging session?',
      'answer': 'To start a charging session, connect your vehicle to the charger, then scan the QR code on the station or select the station in the app and tap "Start Charging".'
    },
    {
      'question': 'How do I pay for charging?',
      'answer': 'You can pay using the payment methods saved in your account. Go to Settings > Payment & Billing to add or manage your payment methods.'
    },
    {
      'question': 'What if the charging station is not working?',
      'answer': 'If you encounter issues with a charging station, please report it through the app by going to the station details and tapping "Report Issue", or contact our support team.'
    },
    {
      'question': 'How do I find charging stations near me?',
      'answer': 'Open the app and allow location access. The map will show all nearby charging stations. You can also use the search function to find stations in specific areas.'
    },
    {
      'question': 'Can I reserve a charging station?',
      'answer': 'Yes, you can reserve a charging station up to 30 minutes in advance. Go to the station details and tap "Reserve".'
    },
  ];

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Help & Support',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          
          // Quick Actions
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickActionButton(
                        icon: Icons.chat,
                        label: 'Live Chat',
                        onTap: () {
                          // Open live chat
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.phone,
                        label: 'Call Support',
                        onTap: () {
                          // Make a call to support
                        },
                      ),
                      _buildQuickActionButton(
                        icon: Icons.email,
                        label: 'Email',
                        onTap: () {
                          // Send email to support
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // FAQs
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frequently Asked Questions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _faqs.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                        title: Text(
                          _faqs[index]['question'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(_faqs[index]['answer']),
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        // View all FAQs
                      },
                      icon: const Icon(Icons.help_outline),
                      label: const Text('View All FAQs'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Report an Issue
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report an Issue',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Issue Type',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      'Charging Station Problem',
                      'Payment Issue',
                      'App Bug or Error',
                      'Account Problem',
                      'Other',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // Handle dropdown change
                    },
                    hint: const Text('Select Issue Type'),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: _issueController,
                    decoration: const InputDecoration(
                      labelText: 'Describe your issue',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Attach files
                          },
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Attach Files'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Submit issue
                            if (_issueController.text.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Issue reported successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              _issueController.clear();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please describe your issue'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.send),
                          label: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Support Tickets
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Support Tickets',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: index == 0 ? Colors.orange.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            index == 0 ? Icons.pending_actions : Icons.check_circle,
                            color: index == 0 ? Colors.orange : Colors.green,
                          ),
                        ),
                        title: Text('Ticket #${10000 + index}'),
                        subtitle: Text(
                          index == 0 
                              ? 'Payment issue - In Progress' 
                              : 'App error - Resolved',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // View ticket details
                        },
                      );
                    },
                  ),
                  
                  if (2 == 0) ...[
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'You have no support tickets',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // User Guides
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Guides',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    leading: const Icon(Icons.menu_book),
                    title: const Text('Getting Started Guide'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Open getting started guide
                    },
                  ),
                  
                  const Divider(),
                  
                  ListTile(
                    leading: const Icon(Icons.video_library),
                    title: const Text('Video Tutorials'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Open video tutorials
                    },
                  ),
                  
                  const Divider(),
                  
                  ListTile(
                    leading: const Icon(Icons.tips_and_updates),
                    title: const Text('Tips & Tricks'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Open tips and tricks
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
  
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}