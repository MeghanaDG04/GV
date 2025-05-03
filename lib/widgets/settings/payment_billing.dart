import 'package:flutter/material.dart';
import '../../models/user.dart';

class PaymentBilling extends StatefulWidget {
  final User user;

  const PaymentBilling({Key? key, required this.user}) : super(key: key);

  @override
  _PaymentBillingState createState() => _PaymentBillingState();
}

class _PaymentBillingState extends State<PaymentBilling> {
  bool _autoPayEnabled = false;
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment & Billing',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          
          // Tab navigation
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  tabs: const [
                    Tab(text: 'Payment Methods'),
                    Tab(text: 'Transaction History'),
                    Tab(text: 'Billing Settings'),
                  ],
                  onTap: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 20),
                
                // Tab content
                [
                  _buildPaymentMethodsTab(),
                  _buildTransactionHistoryTab(),
                  _buildBillingSettingsTab(),
                ][_selectedTabIndex],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Payment methods list
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
                    Text(
                      'Saved Payment Methods',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add new payment method
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add New'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Sample payment methods
                _buildPaymentMethodItem(
                  icon: Icons.credit_card,
                  title: 'Visa ending in 4242',
                  subtitle: 'Expires 12/25',
                  isDefault: true,
                ),
                const Divider(),
                _buildPaymentMethodItem(
                  icon: Icons.credit_card,
                  title: 'Mastercard ending in 5555',
                  subtitle: 'Expires 10/24',
                  isDefault: false,
                ),
                const Divider(),
                _buildPaymentMethodItem(
                  icon: Icons.account_balance,
                  title: 'Bank Account',
                  subtitle: 'Chase ****6789',
                  isDefault: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionHistoryTab() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Transaction list
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.ev_station,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text('Charging Session #${1000 + index}'),
                  subtitle: Text('Station: Downtown #${index + 1} • ${DateTime.now().subtract(Duration(days: index)).toString().substring(0, 10)}'),
                  trailing: Text(
                    '\${(index + 1) * 5.50}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    // Show transaction details
                  },
                );
              },
            ),
            
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  // View all transactions
                },
                icon: const Icon(Icons.history),
                label: const Text('View All Transactions'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingSettingsTab() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Billing Preferences',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Auto-pay toggle
            SwitchListTile(
              title: const Text('Enable Auto-Pay'),
              subtitle: const Text('Automatically charge your default payment method'),
              value: _autoPayEnabled,
              onChanged: (value) {
                setState(() {
                  _autoPayEnabled = value;
                });
              },
            ),
            
            const Divider(),
            
            // Billing address
            ListTile(
              title: const Text('Billing Address'),
              subtitle: const Text('123 Main St, Anytown, CA 12345'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Edit billing address
                },
              ),
            ),
            
            const Divider(),
            
            // Billing email
            ListTile(
              title: const Text('Billing Email'),
              subtitle: Text(widget.user.email),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Edit billing email
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Download invoices
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Download invoices
                },
                icon: const Icon(Icons.download),
                label: const Text('Download Invoices'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDefault,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(subtitle),
                if (isDefault)
                  Chip(
                    label: const Text('Default'),
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
              ],
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'default',
                child: Text('Set as Default'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            onSelected: (value) {
              // Handle menu item selection
            },
          ),
        ],
      ),
    );
  }
}