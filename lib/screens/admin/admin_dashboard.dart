import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/settings_screen.dart';
import 'store_management.dart';
import 'service_management.dart';
import 'location_management.dart';
import 'product_management.dart';
import '../login_screen.dart';
import 'package:flutter/src/painting/edge_insets.dart';
//import 'product_management.dart';
import 'package:flutter/src/widgets/basic.dart';

class AdminDashboard extends StatefulWidget {
  static const routeName = '/admin-dashboard';

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    StoreManagement(),
    ServiceManagement(),
    LocationManagement(),
    ProductManagement(),
  ];
  
  final List<String> _titles = [
    'Store Management',
    'Service Management',
    'Location Management',
    'Product Management',
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard - ${_titles[_selectedIndex]}'),
        backgroundColor: Colors.green.shade700, // Changed from indigo to leaf green
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Update logout to navigate to login screen
              // Alternative approach using MaterialPageRoute
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green.shade700, // Changed from indigo to leaf green
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.green.shade700), // Changed from indigo to leaf green
                  ),
                  Container(height: 10),
                  Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Manage your store',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Store Details'),
              selected: _selectedIndex == 0,
              onTap: () {
                _selectPage(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.miscellaneous_services),
              title: Text('Services'),
              selected: _selectedIndex == 1,
              onTap: () {
                _selectPage(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Location'),
              selected: _selectedIndex == 2,
              onTap: () {
                _selectPage(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Products'),
              selected: _selectedIndex == 3,
              onTap: () {
                _selectPage(3);
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  SettingsScreen.routeName,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle logout
                Navigator.pop(context);
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade700, // Changed from indigo to leaf green
        unselectedItemColor: Colors.grey,
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.miscellaneous_services),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Products',
          ),
        ],
      ),
    );
  }    void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
