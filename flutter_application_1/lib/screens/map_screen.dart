import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/station.dart';
import 'package:flutter_application_1/models/vehicle.dart'; // Import Vehicle model
import 'package:flutter_application_1/screens/booking_confirmation_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Mock data for nearby stations - using the same structure as in home_screen.dart
  final List<Map<String, dynamic>> _nearbyStations = [
    {
      'id': '1',
      'name': 'Green Volt Station #1',
      'distance': '0.5 km',
      'type': 'DC Fast Charger',
      'available': true,
      'price': '\$0.35/kWh',
      'rating': 4.8,
      'image': 'assets/icons/charging_station1.png',
      'address': '123 Main St, City',
      'latitude': 37.7749,
      'longitude': -122.4194,
      'availableChargerTypes': ['CCS', 'CHAdeMO'],
      'totalChargers': 4,
      'availableChargers': 2,
      'reviewCount': 120,
      'amenities': ['Restrooms', 'Cafe', 'WiFi'],
      'operatingHours': '24/7',
    },
    {
      'id': '2',
      'name': 'City Center EV Hub',
      'distance': '1.2 km',
      'type': 'Level 2 Charger',
      'available': true,
      'price': '\$0.25/kWh',
      'rating': 4.5,
      'image': 'assets/icons/charging_station2.png',
      'address': '456 Market St, City',
      'latitude': 37.7831,
      'longitude': -122.4075,
      'availableChargerTypes': ['J1772'],
      'totalChargers': 8,
      'availableChargers': 5,
      'reviewCount': 85,
      'amenities': ['Restrooms', 'Shopping'],
      'operatingHours': '6:00 AM - 10:00 PM',
    },
    {
      'id': '3',
      'name': 'Westside Mall Charging',
      'distance': '2.3 km',
      'type': 'DC Fast Charger',
      'available': false,
      'price': '\$0.40/kWh',
      'rating': 4.2,
      'image': 'assets/icons/charging_station3.png',
      'address': '789 West Ave, City',
      'latitude': 37.7694,
      'longitude': -122.4862,
      'availableChargerTypes': ['CCS', 'CHAdeMO', 'Tesla'],
      'totalChargers': 6,
      'availableChargers': 0,
      'reviewCount': 62,
      'amenities': ['Restrooms', 'Shopping', 'Food Court'],
      'operatingHours': '9:00 AM - 9:00 PM',
    },
    {
      'id': '4',
      'name': 'Downtown Supercharger',
      'distance': '3.1 km',
      'type': 'Tesla Supercharger',
      'available': true,
      'price': '\$0.45/kWh',
      'rating': 4.9,
      'image': 'assets/icons/charging_station4.png',
      'address': '101 Downtown Blvd, City',
      'latitude': 37.7900,
      'longitude': -122.4000,
      'availableChargerTypes': ['Tesla'],
      'totalChargers': 12,
      'availableChargers': 8,
      'reviewCount': 210,
      'amenities': ['Restrooms'],
      'operatingHours': '24/7',
    },
  ];

  // Create a mock vehicle for the booking screen
  final Vehicle _mockVehicle = Vehicle(
  id: '1',
  make: 'Tesla',
  model: 'Model 3',
  licensePlate: 'EV-123',
  batteryCapacity: '75',
  currentCharge: 30,
  chargerType: 'Type 2',
  year: 2023,
  imageUrl: 'assets/images/tesla_model_3.png',
);

  int _selectedIndex = 0;
  Map<String, dynamic>? _selectedStation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Charging Stations Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Map placeholder
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey.shade200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.map,
                      size: 80,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Interactive Map',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Simulate getting current location
                      },
                      icon: const Icon(Icons.my_location),
                      label: const Text('Get My Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Station list
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nearby Charging Stations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _nearbyStations.length,
                      itemBuilder: (context, index) {
                        final station = _nearbyStations[index];
                        final isSelected = _selectedStation == station;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: isSelected ? 4 : 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: isSelected
                                ? const BorderSide(color: Colors.green, width: 2)
                                : BorderSide.none,
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.ev_station,
                                color: Colors.green,
                                size: 30,
                              ),
                            ),
                            title: Text(
                              station['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(station['type']),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text(
                                      station['distance'],
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.bolt, size: 14, color: Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text(
                                      station['price'],
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Container(
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
                            onTap: () {
                              setState(() {
                                _selectedStation = station;
                              });
                              _showStationDetails(station);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStationDetails(Map<String, dynamic> station) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.ev_station,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        station['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        station['address'],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStationInfoItem(
                  icon: Icons.bolt,
                  label: station['type'],
                  color: Colors.orange,
                ),
                _buildStationInfoItem(
                  icon: Icons.attach_money,
                  label: station['price'],
                  color: Colors.green,
                ),
                _buildStationInfoItem(
                  icon: Icons.access_time,
                  label: station['operatingHours'],
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Charger Availability',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: station['availableChargers'] / station['totalChargers'],
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      station['availableChargers'] > 0 ? Colors.green : Colors.red,
                    ),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${station['availableChargers']}/${station['totalChargers']} available',
                  style: TextStyle(
                    color: station['availableChargers'] > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (station['availableChargerTypes'] as List<dynamic>).map((type) {
                return Chip(
                  label: Text(type.toString()),
                  backgroundColor: Colors.green.withOpacity(0.1),
                  labelStyle: const TextStyle(color: Colors.green),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Get directions (would be implemented with a real map)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Getting directions...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                                        icon: const Icon(Icons.directions),
                    label: const Text('DIRECTIONS'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to booking screen
                      // Convert the Map to a Station object
                      final stationObj = Station(
                        id: station['id'] ?? '',
                        name: station['name'],
                        type: station['type'],
                        address: station['address'] ?? '',
                        latitude: station['latitude'] ?? 0.0,
                        longitude: station['longitude'] ?? 0.0,
                        imageUrl: station['image'] ?? '',
                        available: station['available'],
                        distance: station['distance'],
                        price: station['price'],
                        availableChargerTypes: List<String>.from(station['availableChargerTypes'] ?? []),
                        totalChargers: station['totalChargers'] ?? 0,
                        availableChargers: station['availableChargers'] ?? 0,
                        rating: station['rating'] ?? 0.0,
                        reviewCount: station['reviewCount'] ?? 0,
                        amenities: List<String>.from(station['amenities'] ?? []),
                        operatingHours: station['operatingHours'] ?? '',
                        vehicle: _mockVehicle,
                      );
                      
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BookingConfirmationScreen(
                            station: stationObj,
                            selectedDate: DateTime.now(),
                            startTime: TimeOfDay.now(),
                            durationMinutes: 60,
                            vehicle: _mockVehicle,
                            chargerType: station['availableChargerTypes'] != null && 
                                        (station['availableChargerTypes'] as List).isNotEmpty
                                ? (station['availableChargerTypes'] as List).first.toString()
                                : 'Fast Charger',
                            chargerNumber: 1,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.bolt),
                    label: const Text('BOOK NOW'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationInfoItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

