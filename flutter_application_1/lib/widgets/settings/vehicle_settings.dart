import 'package:flutter/material.dart';

class VehicleSettings extends StatefulWidget {
  const VehicleSettings({Key? key}) : super(key: key);

  @override
  _VehicleSettingsState createState() => _VehicleSettingsState();
}

class _VehicleSettingsState extends State<VehicleSettings> {
  // Sample vehicle data
  final List<Map<String, dynamic>> _vehicles = [
    {
      'id': '1',
      'make': 'Tesla',
      'model': 'Model 3',
      'year': 2022,
      'licensePlate': 'EV-123',
      'batteryCapacity': 75.0,
      'connectorTypes': ['Type 2', 'Tesla'],
      'image': 'assets/images/tesla_model3.png',
      'isDefault': true,
    },
    {
      'id': '2',
      'make': 'Nissan',
      'model': 'Leaf',
      'year': 2021,
      'licensePlate': 'EV-456',
      'batteryCapacity': 62.0,
      'connectorTypes': ['Type 2', 'CHAdeMO'],
      'image': 'assets/images/nissan_leaf.png',
      'isDefault': false,
    },
  ];

  @override
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Vehicles',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          
          // Vehicle list
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
                        'Registered Vehicles',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showAddVehicleDialog();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Vehicle'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  if (_vehicles.isEmpty) ...[
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'No vehicles registered yet. Add your first vehicle to get started.',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ] else ...[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _vehicles.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final vehicle = _vehicles[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: Icon(
                              Icons.electric_car,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text('${vehicle['year']} ${vehicle['make']} ${vehicle['model']}'),
                              const SizedBox(width: 8),
                              if (vehicle['isDefault'])
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.green),
                                  ),
                                  child: const Text(
                                    'Default',
                                    style: TextStyle(color: Colors.green, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('License: ${vehicle['licensePlate']}'),
                              Text('Battery: ${vehicle['batteryCapacity']} kWh'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showEditVehicleDialog(index);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteVehicleDialog(index);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            if (!vehicle['isDefault']) {
                              _setDefaultVehicle(index);
                            }
                          },
                          isThreeLine: true,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Vehicle Statistics
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vehicle Statistics',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  if (_vehicles.isEmpty) ...[
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'Add a vehicle to see statistics',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Default vehicle stats
                    ...[
                      Text(
                        '${_vehicles.firstWhere((v) => v['isDefault'] == true, orElse: () => _vehicles.first)['year']} ${_vehicles.firstWhere((v) => v['isDefault'] == true, orElse: () => _vehicles.first)['make']} ${_vehicles.firstWhere((v) => v['isDefault'] == true, orElse: () => _vehicles.first)['model']}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Total Charges',
                              value: '27',
                              icon: Icons.battery_charging_full,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Energy Used',
                              value: '487 kWh',
                              icon: Icons.electric_bolt,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: 'Avg. Charge',
                              value: '18 kWh',
                              icon: Icons.speed,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              title: 'Total Cost',
                              value: '\$146.10',
                              icon: Icons.attach_money,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            // View detailed statistics
                          },
                          icon: const Icon(Icons.analytics),
                          label: const Text('View Detailed Statistics'),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Charging Preferences
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Charging Preferences',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    title: const Text('Preferred Charging Speed'),
                    subtitle: const Text('Fast Charging (When Available)'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Change preferred charging speed
                    },
                  ),
                  
                  const Divider(),
                  
                  ListTile(
                    title: const Text('Default Charge Limit'),
                    subtitle: const Text('80%'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Change default charge limit
                    },
                  ),
                  
                  const Divider(),
                  
                  ListTile(
                    title: const Text('Preferred Connector Type'),
                    subtitle: const Text('Type 2'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Change preferred connector type
                    },
                  ),
                  
                  const Divider(),
                  
                  SwitchListTile(
                    title: const Text('Smart Charging'),
                    subtitle: const Text('Optimize charging based on electricity rates'),
                    value: true,
                    onChanged: (value) {
                      // Toggle smart charging
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.blue.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAddVehicleDialog() {
    final makeController = TextEditingController();
    final modelController = TextEditingController();
    final yearController = TextEditingController();
    final licensePlateController = TextEditingController();
    final batteryCapacityController = TextEditingController();
    
    final selectedConnectors = <String>{};
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Vehicle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: makeController,
                decoration: const InputDecoration(
                  labelText: 'Make',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: modelController,
                decoration: const InputDecoration(
                  labelText: 'Model',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: yearController,
                decoration: const InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: licensePlateController,
                            decoration: const InputDecoration(
                              labelText: 'License Plate',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: batteryCapacityController,
                            decoration: const InputDecoration(
                              labelText: 'Battery Capacity (kWh)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Connector Types:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  'Type 2',
                                  'CCS',
                                  'CHAdeMO',
                                  'Tesla',
                                ].map((type) {
                                  return CheckboxListTile(
                                    title: Text(type),
                                    value: selectedConnectors.contains(type),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedConnectors.add(type);
                                        } else {
                                          selectedConnectors.remove(type);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Validate and add vehicle
                          if (makeController.text.isNotEmpty &&
                              modelController.text.isNotEmpty &&
                              yearController.text.isNotEmpty &&
                              licensePlateController.text.isNotEmpty &&
                              batteryCapacityController.text.isNotEmpty &&
                              selectedConnectors.isNotEmpty) {
                
                            try {
                              final year = int.parse(yearController.text);
                              final batteryCapacity = double.parse(batteryCapacityController.text);
                  
                              setState(() {
                                _vehicles.add({
                                  'id': (_vehicles.length + 1).toString(),
                                  'make': makeController.text,
                                  'model': modelController.text,
                                  'year': year,
                                  'licensePlate': licensePlateController.text,
                                  'batteryCapacity': batteryCapacity,
                                  'connectorTypes': selectedConnectors.toList(),
                                  'image': 'assets/images/default_car.png',
                                  'isDefault': _vehicles.isEmpty,
                                });
                              });
                  
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Vehicle added successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Invalid input: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields and select at least one connector type'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('ADD'),
                      ),
                    ],
                  ),
                );
              }
  
              void _showEditVehicleDialog(int index) {
                final vehicle = _vehicles[index];
    
                final makeController = TextEditingController(text: vehicle['make']);
                final modelController = TextEditingController(text: vehicle['model']);
                final yearController = TextEditingController(text: vehicle['year'].toString());
                final licensePlateController = TextEditingController(text: vehicle['licensePlate']);
                final batteryCapacityController = TextEditingController(text: vehicle['batteryCapacity'].toString());
    
                final selectedConnectors = Set<String>.from(vehicle['connectorTypes']);
    
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Edit Vehicle'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: makeController,
                            decoration: const InputDecoration(
                              labelText: 'Make',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: modelController,
                            decoration: const InputDecoration(
                              labelText: 'Model',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: yearController,
                            decoration: const InputDecoration(
                              labelText: 'Year',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: licensePlateController,
                            decoration: const InputDecoration(
                              labelText: 'License Plate',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: batteryCapacityController,
                            decoration: const InputDecoration(
                              labelText: 'Battery Capacity (kWh)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Connector Types:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                children: [
                                  'Type 2',
                                  'CCS',
                                  'CHAdeMO',
                                  'Tesla',
                                ].map((type) {
                                  return CheckboxListTile(
                                    title: Text(type),
                                    value: selectedConnectors.contains(type),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedConnectors.add(type);
                                        } else {
                                          selectedConnectors.remove(type);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Validate and update vehicle
                          if (makeController.text.isNotEmpty &&
                              modelController.text.isNotEmpty &&
                              yearController.text.isNotEmpty &&
                              licensePlateController.text.isNotEmpty &&
                              batteryCapacityController.text.isNotEmpty &&
                              selectedConnectors.isNotEmpty) {
                
                            try {
                              final year = int.parse(yearController.text);
                              final batteryCapacity = double.parse(batteryCapacityController.text);
                  
                              setState(() {
                                _vehicles[index] = {
                                  'id': vehicle['id'],
                                  'make': makeController.text,
                                  'model': modelController.text,
                                  'year': year,
                                  'licensePlate': licensePlateController.text,
                                  'batteryCapacity': batteryCapacity,
                                  'connectorTypes': selectedConnectors.toList(),
                                  'image': vehicle['image'],
                                  'isDefault': vehicle['isDefault'],
                                };
                              });
                  
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Vehicle updated successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Invalid input: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields and select at least one connector type'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text('UPDATE'),
                      ),
                    ],
                  ),
                );
              }
  
              void _showDeleteVehicleDialog(int index) {
                final vehicle = _vehicles[index];
    
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Vehicle?'),
                    content: Text(
                      'Are you sure you want to delete your ${vehicle['year']} ${vehicle['make']} ${vehicle['model']}? This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL'),
                      ),
                      TextButton(
                        onPressed: () {
                          final isDefault = vehicle['isDefault'];
              
                          setState(() {
                            _vehicles.removeAt(index);
                
                            // If we removed the default vehicle, set a new default
                            if (isDefault && _vehicles.isNotEmpty) {
                              _vehicles[0]['isDefault'] = true;
                            }
                          });
              
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vehicle deleted successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Text(
                          'DELETE',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              }
  
              void _setDefaultVehicle(int index) {
                setState(() {
                  for (var i = 0; i < _vehicles.length; i++) {
                    _vehicles[i]['isDefault'] = i == index;
                  }
                });
    
                final vehicle = _vehicles[index];
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${vehicle['year']} ${vehicle['make']} ${vehicle['model']} set as default vehicle'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
}