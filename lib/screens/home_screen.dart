import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/station.dart';
import 'package:flutter_application_1/screens/booking_confirmation_screen.dart';
import 'package:flutter_application_1/screens/map_content_wrapper.dart';
import 'package:flutter_application_1/screens/map_screen.dart';
import 'package:flutter_application_1/screens/notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedFilter = 'All';
  int _unreadNotificationsCount = 2; // Mock count, in a real app this would be fetched from a service
  
  // Mock data for nearby stations
  final List<Map<String, dynamic>> _nearbyStations = [
    {
      'name': 'Green Volt Station #1',
      'distance': '0.5 km',
      'type': 'DC Fast Charger',
      'available': true,
      'price': '\$0.35/kWh',
      'rating': 4.8,
      'image': 'assets/icons/charging_station1.png',
    },
    {
      'name': 'City Center EV Hub',
      'distance': '1.2 km',
      'type': 'Level 2 Charger',
      'available': true,
      'price': '\$0.25/kWh',
      'rating': 4.5,
      'image': 'assets/icons/charging_station2.png',
    },
    {
      'name': 'Westside Mall Charging',
      'distance': '2.3 km',
      'type': 'DC Fast Charger',
      'available': false,
      'price': '\$0.40/kWh',
      'rating': 4.2,
      'image': 'assets/icons/charging_station3.png',
    },
    {
      'name': 'Downtown Supercharger',
      'distance': '3.1 km',
      'type': 'Tesla Supercharger',
      'available': true,
      'price': '\$0.45/kWh',
      'rating': 4.9,
      'image': 'assets/icons/charging_station4.png',
    },
  ];
  
  // Mock data for products - same as in product_management.dart
  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'EV Battery',
      'description': 'Battery which keeps your vehicle active for longer time',
      'price': 2.99,
      'imageUrl': 'assets/icons/ev_battery.png',
      'category': 'Batteries',
      'stockQuantity': 50,
    },
    {
      'id': '2',
      'name': 'Motor',
      'description': 'Motors for faster and smoother ride.',
      'price': 1.99,
      'imageUrl': 'assets/icons/ev_motor.png',
      'category': 'EV Motors',
      'stockQuantity': 75,
    },
    {
      'id': '3',
      'name': 'EV Charger',
      'description': 'Charger for fast charging of your vehicles',
      'price': 3.49,
      'imageUrl': 'assets/icons/ev_charger.png',
      'category': 'Chargers',
      'stockQuantity': 20,
    },
  ];
  
  // Cart items
  List<Map<String, dynamic>> _cartItems = [];
  int get _cartItemCount => _cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int? ?? 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Image.asset(
          'assets/icons/green_volt_logo.png',
          height: 40,
        ),
        // In the AppBar actions section, update the notifications IconButton:
actions: [
  Stack(
    children: [
      IconButton(
        icon: const Icon(Icons.notifications_outlined),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsScreen()),
          ).then((value) {
            // When returning from notifications screen, update the unread count
            // In a real app, this would be handled by a state management solution
            setState(() {
              _unreadNotificationsCount = 0;
            });
          });
        },
      ),
      if (_unreadNotificationsCount > 0)
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              minWidth: 18,
              minHeight: 18,
            ),
            child: Text(
              '$_unreadNotificationsCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ],
  ),

          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              accountName: const Text("User Name"),
              accountEmail: const Text("user@email.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset('assets/icons/default_profile.png'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer first
                Navigator.pushNamed(context, '/user_settings_screen'); // Navigate to user settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context); 
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context); 
                Navigator.pushNamed(context, '/help');
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_support),
              title: const Text('Contact'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context,'/contact');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(),
          const MapContentWrapper(),
          _buildProductContent(),
          _buildPaymentsContent(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(Icons.home, size: 35)
                : const Icon(Icons.home_outlined),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits), //miscellaneous_services_outlined
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? const Icon(Icons.account_balance_wallet, size: 35)
                : const Icon(Icons.account_balance_wallet_outlined),
            label: 'Payments',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/icons/default_profile.png'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.bolt, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '350 kWh',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Main heading
            const Text(
              'Find Your Charging Station',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by location or station name',
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.green),
                    onPressed: () {
                      // Show filter options
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Quick filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  _buildFilterChip('Available Now'),
                  _buildFilterChip('DC Fast'),
                  _buildFilterChip('Level 2'),
                  _buildFilterChip('Free'),
                  _buildFilterChip('Tesla'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Nearby stations section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nearby Charging Stations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to map view
                    setState(() {
                      _selectedIndex = 1; // Switch to map tab
                    });
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Station list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _nearbyStations.length,
              itemBuilder: (context, index) {
                final station = _nearbyStations[index];
                return _buildStationCard(station);
              },
            ),
            
            const SizedBox(height: 24),
            
            // Plan your route button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to route planning
                },
                icon: const Icon(Icons.directions),
                label: const Text('Plan Your Route'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Quick stats section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Total Charges', '27', Icons.battery_charging_full),
                  _buildStatItem('CO₂ Saved', '245 kg', Icons.eco),
                  _buildStatItem('Favorite Stations', '3', Icons.favorite),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }  
  
  Widget _buildProductContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'EV Products',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, size: 28),
                    onPressed: () {
                      _showCartDialog();
                    },
                  ),
                                    if (_cartItemCount > 0)
                    Positioned(
                                            right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '$_cartItemCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search, color: Colors.green),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _products.length,
              itemBuilder: (ctx, index) {
                final product = _products[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Container(
                              height: 120,
                              width: double.infinity,
                              color: Colors.green.withOpacity(0.1),
                              child: const Icon(
                                Icons.electric_car,
                                color: Colors.green,
                                size: 50,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '\$${product['price'].toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['description'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.category, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  product['category'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.inventory_2, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  'Stock: ${product['stockQuantity']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: product['stockQuantity'] > 10
                                        ? Colors.green
                                        : product['stockQuantity'] > 0
                                            ? Colors.orange
                                            : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Add to cart functionality
                            setState(() {
                              // Check if product is already in cart
                              int existingIndex = _cartItems.indexWhere((item) => item['id'] == product['id']);
                              
                              if (existingIndex >= 0) {
                                // If product is already in cart, increment quantity
                                _cartItems[existingIndex]['quantity'] = (_cartItems[existingIndex]['quantity'] ?? 1) + 1;
                              } else {
                                // Otherwise add new product to cart
                                final cartItem = Map<String, dynamic>.from(product);
                                cartItem['quantity'] = 1;
                                _cartItems.add(cartItem);
                              }
                            });
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product['name']} added to cart'),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'VIEW CART',
                                  onPressed: () {
                                    _showCartDialog();
                                  },
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 71, 185, 75),
                            minimumSize: const Size(double.infinity, 30),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 12),
                            selectionColor: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPaymentsContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.green, Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Summary',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.account_balance_wallet, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Total Spent This Month',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '\$78.35',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPaymentStat('Charging', '\$65.20'),
                      _buildPaymentStat('Products', '\$13.15'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Payment Methods Section
            const Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // Payment Methods Cards
            _buildPaymentMethodCard(
              icon: Icons.credit_card,
              title: 'Credit Card',
              subtitle: '**** **** **** 4582',
              isDefault: true,
            ),
            _buildPaymentMethodCard(
              icon: Icons.account_balance,
              title: 'Bank Account',
              subtitle: '**** 7890',
              isDefault: false,
            ),
            
            // Add Payment Method Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: OutlinedButton.icon(
                onPressed: () {
                  //_showAddPaymentMethodDialog,  // Use our new method here
                },
                icon: const Icon(Icons.add, color: Colors.green),
                label: const Text(
                  'Add Payment Method',
                  style: TextStyle(color: Colors.green),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Transaction History Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaction History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full transaction history
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Transaction List
            _buildTransactionItem(
              title: 'Green Volt Station #1',
              date: 'May 15, 2023 • 10:45 AM',
              amount: '-\$12.75',
              icon: Icons.ev_station,
              isCredit: false,
            ),
            _buildTransactionItem(
              title: 'EV Battery Purchase',
              date: 'May 12, 2023 • 3:20 PM',
              amount: '-\$2.99',
              icon: Icons.battery_charging_full,
              isCredit: false,
            ),
            _buildTransactionItem(
              title: 'Refund - Cancelled Booking',
              date: 'May 10, 2023 • 9:15 AM',
              amount: '+\$8.50',
              icon: Icons.replay,
              isCredit: true,
            ),
            _buildTransactionItem(
              title: 'City Center EV Hub',
              date: 'May 8, 2023 • 5:30 PM',
              amount: '-\$15.25',
              icon: Icons.ev_station,
              isCredit: false,
            ),
            _buildTransactionItem(
              title: 'Monthly Reward Credit',
              date: 'May 1, 2023 • 12:00 AM',
              amount: '+\$5.00',
              icon: Icons.card_giftcard,
              isCredit: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDefault,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDefault
            ? const BorderSide(color: Colors.green, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.green),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Default',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Show payment method options
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String date,
    required String amount,
    required IconData icon,
    required bool isCredit,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isCredit ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isCredit ? Colors.green : Colors.blue,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          date,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        trailing: Text(
          amount,
          style: TextStyle(
            color: isCredit ? Colors.green : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
  
  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.green),
            SizedBox(width: 10),
            Text('My Cart'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: _cartItems.isEmpty
              ? const Center(
                  child: Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    final item = _cartItems[index];
                    final quantity = item['quantity'] as int? ?? 1;
                    final price = item['price'] as double;
                    final totalPrice = quantity * price;
                    
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.electric_car, color: Colors.green),
                      ),
                      title: Text(
                        item['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('\$${price.toStringAsFixed(2)} × $quantity'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () {
                              setState(() {
                                _cartItems.removeAt(index);
                              });
                              Navigator.pop(context);
                              if (_cartItems.isNotEmpty) {
                                _showCartDialog(); // Reopen dialog to refresh
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        actions: [
          if (_cartItems.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${_cartItems.fold(0.0, (sum, item) => sum + (item['price'] as double) * (item['quantity'] as int? ?? 1)).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _cartItems.clear();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('CLEAR CART', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Here you would navigate to checkout
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Proceeding to checkout...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('CHECKOUT'),
            ),
          ] else
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CLOSE'),
            ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Colors.green,
        backgroundColor: Colors.grey.shade200,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
      ),
    );
  }
  
  Widget _buildStationCard(Map<String, dynamic> station) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Station image or icon
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.ev_station,
                color: Colors.green,
                size: 40,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Station details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          station['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: station['available'] ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          station['available'] ? 'Available' : 'In Use',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    station['type'],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        station['distance'],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.bolt, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        station['price'],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Navigation button
            IconButton(
              icon: const Icon(Icons.navigate_next, color: Colors.green),
              onPressed: () {
                // Example of how to navigate to the booking confirmation screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BookingConfirmationScreen(
                      station: Station(
                        id: station['id'] ?? '',
                        name: station['name'],
                        type: station['type'],
                        address: station['address'] ?? '',
                        latitude: station['latitude'] ?? 0.0,
                        longitude: station['longitude'] ?? 0.0,
                        imageUrl: station['imageUrl'] ?? '',
                        available: station['available'],
                        distance: station['distance'],
                        price: station['price'],
                        availableChargerTypes: station['availableChargerTypes'] ?? [],
                        totalChargers: station['totalChargers'] ?? 0,
                        availableChargers: station['availableChargers'] ?? 0,
                        rating: station['rating'] ?? 0.0,
                        reviewCount: station['reviewCount'] ?? 0,
                        amenities: station['amenities'] ?? [],
                        operatingHours: station['operatingHours'] ?? '',
                        vehicle: station['vehicle'],
                      ),
                      selectedDate: DateTime.now(),
                      startTime: TimeOfDay.now(),
                      durationMinutes: 60,
                      vehicle: station['vehicle'],
                      chargerType: 'Fast Charger',
                      chargerNumber: 3,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
