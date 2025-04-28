import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:provider/provider.dart';
import '../../models/charging_station.dart';
import '../../providers/admin_provider.dart';

class StationManagement extends StatefulWidget {
  const StationManagement({Key? key, required User currentUser}) : super(key: key);

  @override
  _StationManagementState createState() => _StationManagementState();
}

class _StationManagementState extends State<StationManagement> {
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'All';
  String _sortBy = 'Name';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        final stations = adminProvider.stations;
        
        // Apply filters and sorting
        final filteredStations = _getFilteredStations(stations);
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Charging Station Management',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              
              // Search and filter bar
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search Stations',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                    });
                                  },
                                )
                              : null,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Filter by Status',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              value: _filterStatus,
                              items: [
                                'All',
                                'Available',
                                'InUse',
                                'OutOfService',
                                'UnderMaintenance',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _filterStatus = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Sort by',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              value: _sortBy,
                              items: ['Name', 'Status', 'Power', 'Price'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _sortBy = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Station list
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
                            'Charging Stations (${filteredStations.length})',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              _showAddStationDialog(context, adminProvider);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add Station'),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      if (filteredStations.isEmpty) ...[
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text(
                              'No charging stations found matching your criteria',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ] else ...[
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredStations.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final station = filteredStations[index];
                            return ListTile(
                              leading: _getStatusIcon(station.status),
                              title: Text(station.name),
                              subtitle: Text(station.address),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${station.powerKw} kW',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text('\$${station.pricePerKwh.toStringAsFixed(2)}/kWh'),
                                    ],
                                  ),
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit Station'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'status',
                                        child: Text('Change Status'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete Station'),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _showEditStationDialog(context, station, adminProvider);
                                      } else if (value == 'status') {
                                        _showChangeStatusDialog(context, station, adminProvider);
                                      } else if (value == 'delete') {
                                        _showDeleteStationDialog(context, station, adminProvider);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                _showStationDetailsDialog(context, station);
                              },
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Station Analytics
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Station Analytics',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildAnalyticsCard(
                              title: 'Total Stations',
                              value: stations.length.toString(),
                              icon: Icons.ev_station,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildAnalyticsCard(
                              title: 'Available',
                              value: stations.where((s) => s.status == StationStatus.available).length.toString(),
                              icon: Icons.check_circle,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildAnalyticsCard(
                              title: 'In Use',
                              value: stations.where((s) => s.status == StationStatus.inUse).length.toString(),
                              icon: Icons.battery_charging_full,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildAnalyticsCard(
                              title: 'Offline/Maintenance',
                              value: stations.where((s) => 
                                s.status == StationStatus.outOfService || 
                                s.status == StationStatus.underMaintenance
                              ).length.toString(),
                              icon: Icons.error,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            // View detailed analytics
                          },
                          icon: const Icon(Icons.analytics),
                          label: const Text('View Detailed Analytics'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Bulk Actions
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bulk Actions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Import stations
                              },
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Import Stations'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Export stations
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('Export Stations'),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _showBulkPriceUpdateDialog(context, adminProvider);
                              },
                              icon: const Icon(Icons.price_change),
                              label: const Text('Update Prices'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _showBulkStatusUpdateDialog(context, adminProvider);
                              },
                              icon: const Icon(Icons.update),
                              label: const Text('Update Status'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  List<ChargingStation> _getFilteredStations(List<ChargingStation> stations) {
    return stations.where((station) {
      // Apply status filter
      if (_filterStatus != 'All') {
        final statusString = _filterStatus.toLowerCase();
        final stationStatusString = station.status.toString().split('.').last.toLowerCase();
        if (statusString != stationStatusString) {
          return false;
        }
      }
      
      // Apply search filter
      if (_searchController.text.isNotEmpty) {
        final searchTerm = _searchController.text.toLowerCase();
        return station.name.toLowerCase().contains(searchTerm) ||
               station.address.toLowerCase().contains(searchTerm) ||
               station.id.toLowerCase().contains(searchTerm);
      }
      
      return true;
    }).toList()
      ..sort((a, b) {
        // Apply sorting
        switch (_sortBy) {
          case 'Name':
            return a.name.compareTo(b.name);
          case 'Status':
            return a.status.toString().compareTo(b.status.toString());
          case 'Power':
            return b.powerKw.compareTo(a.powerKw);
          case 'Price':
            return a.pricePerKwh.compareTo(b.pricePerKwh);
          default:
            return a.name.compareTo(b.name);
        }
      });
  }
  
  Widget _buildAnalyticsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _getStatusIcon(StationStatus status) {
    switch (status) {
      case StationStatus.available:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.check_circle, color: Colors.green),
        );
      case StationStatus.inUse:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.battery_charging_full, color: Colors.orange),
        );
      case StationStatus.outOfService:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.power_off, color: Colors.red),
        );
      case StationStatus.underMaintenance:
        return Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.build, color: Colors.purple),
        );
    }
}  
            void _showAddStationDialog(BuildContext context, AdminProvider adminProvider) {
              final nameController = TextEditingController();
              final addressController = TextEditingController();
              final latitudeController = TextEditingController();
              final longitudeController = TextEditingController();
              final priceController = TextEditingController();
              final powerController = TextEditingController();
    
              StationStatus selectedStatus = StationStatus.available;
              final selectedConnectors = <ConnectorType>{};
    
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Add New Charging Station'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Station Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: latitudeController,
                                decoration: const InputDecoration(
                                  labelText: 'Latitude',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: longitudeController,
                                decoration: const InputDecoration(
                                  labelText: 'Longitude',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: priceController,
                                decoration: const InputDecoration(
                                  labelText: 'Price per kWh (\$)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: powerController,
                                decoration: const InputDecoration(
                                  labelText: 'Power (kW)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        StatefulBuilder(
                          builder: (context, setState) {
                            return DropdownButtonFormField<StationStatus>(
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                border: OutlineInputBorder(),
                              ),
                              value: selectedStatus,
                              items: StationStatus.values.map((StationStatus status) {
                                return DropdownMenuItem<StationStatus>(
                                  value: status,
                                  child: Text(_getStatusName(status)),
                                );
                              }).toList(),
                              onChanged: (StationStatus? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedStatus = newValue;
                                  });
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Connector Types:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        StatefulBuilder(
                          builder: (context, setState) {
                            return Column(
                              children: ConnectorType.values.map((type) {
                                return CheckboxListTile(
                                  title: Text(_getConnectorName(type)),
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
                        // Validate and add station
                        if (nameController.text.isNotEmpty && 
                            addressController.text.isNotEmpty &&
                            latitudeController.text.isNotEmpty &&
                            longitudeController.text.isNotEmpty &&
                            priceController.text.isNotEmpty &&
                            powerController.text.isNotEmpty &&
                            selectedConnectors.isNotEmpty) {
                
                          try {
                            final latitude = double.parse(latitudeController.text);
                            final longitude = double.parse(longitudeController.text);
                            final price = double.parse(priceController.text);
                            final power = double.parse(powerController.text);
                  
                            adminProvider.addStation(ChargingStation(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              name: nameController.text,
                              address: addressController.text,
                              latitude: latitude,
                              longitude: longitude,
                              pricePerKwh: price,
                              status: selectedStatus,
                              connectorTypes: selectedConnectors.toList(),
                              powerKw: power,
                            ));
                  
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Charging station added successfully'),
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
  
            void _showEditStationDialog(BuildContext context, ChargingStation station, AdminProvider adminProvider) {
              final nameController = TextEditingController(text: station.name);
              final addressController = TextEditingController(text: station.address);
              final latitudeController = TextEditingController(text: station.latitude.toString());
              final longitudeController = TextEditingController(text: station.longitude.toString());
              final priceController = TextEditingController(text: station.pricePerKwh.toString());
              final powerController = TextEditingController(text: station.powerKw.toString());
    
              StationStatus selectedStatus = station.status;
              final selectedConnectors = station.connectorTypes.toSet();
    
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit Charging Station'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Station Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: latitudeController,
                                decoration: const InputDecoration(
                                  labelText: 'Latitude',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: longitudeController,
                                decoration: const InputDecoration(
                                  labelText: 'Longitude',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: priceController,
                                decoration: const InputDecoration(
                                  labelText: 'Price per kWh (\$)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: powerController,
                                decoration: const InputDecoration(
                                  labelText: 'Power (kW)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        StatefulBuilder(
                          builder: (context, setState) {
                            return DropdownButtonFormField<StationStatus>(
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                border: OutlineInputBorder(),
                              ),
                              value: selectedStatus,
                              items: StationStatus.values.map((StationStatus status) {
                                return DropdownMenuItem<StationStatus>(
                                  value: status,
                                  child: Text(_getStatusName(status)),
                                );
                              }).toList(),
                              onChanged: (StationStatus? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedStatus = newValue;
                                  });
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Connector Types:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        StatefulBuilder(
                          builder: (context, setState) {
                            return Column(
                              children: ConnectorType.values.map((type) {
                                return CheckboxListTile(
                                  title: Text(_getConnectorName(type)),
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
                        // Validate and update station
                        if (nameController.text.isNotEmpty && 
                            addressController.text.isNotEmpty &&
                            latitudeController.text.isNotEmpty &&
                            longitudeController.text.isNotEmpty &&
                            priceController.text.isNotEmpty &&
                            powerController.text.isNotEmpty &&
                            selectedConnectors.isNotEmpty) {
                
                          try {
                            final latitude = double.parse(latitudeController.text);
                            final longitude = double.parse(longitudeController.text);
                            final price = double.parse(priceController.text);
                            final power = double.parse(powerController.text);
                  
                            adminProvider.updateStation(ChargingStation(
                              id: station.id,
                              name: nameController.text,
                              address: addressController.text,
                              latitude: latitude,
                              longitude: longitude,
                              pricePerKwh: price,
                              status: selectedStatus,
                              connectorTypes: selectedConnectors.toList(),
                              powerKw: power,
                            ));
                  
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Charging station updated successfully'),
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
  
            void _showChangeStatusDialog(BuildContext context, ChargingStation station, AdminProvider adminProvider) {
              StationStatus selectedStatus = station.status;
    
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                          title: const Text('Change Station Status'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: StationStatus.values.map((status) {
                return RadioListTile<StationStatus>(
                  title: Text(_getStatusName(status)),
                  value: status,
                  groupValue: selectedStatus,
                  onChanged: (StationStatus? value) {
                    if (value != null) {
                      setState(() {
                        selectedStatus = value;
                      });
                    }
                  },
                );
              }).toList(),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              adminProvider.updateStationStatus(station.id, selectedStatus);
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Station status updated to ${_getStatusName(selectedStatus)}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteStationDialog(BuildContext context, ChargingStation station, AdminProvider adminProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Charging Station?'),
        content: Text(
          'Are you sure you want to delete "${station.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              adminProvider.deleteStation(station.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Charging station deleted successfully'),
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
  
  void _showStationDetailsDialog(BuildContext context, ChargingStation station) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(station.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Address'),
              subtitle: Text(station.address),
            ),
            ListTile(
              leading: const Icon(Icons.my_location),
              title: const Text('Coordinates'),
              subtitle: Text('${station.latitude}, ${station.longitude}'),
            ),
            ListTile(
              leading: const Icon(Icons.electric_bolt),
              title: const Text('Power'),
              subtitle: Text('${station.powerKw} kW'),
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Price per kWh'),
              subtitle: Text('\$${station.pricePerKwh.toStringAsFixed(2)}'),
            ),
            ListTile(
              leading: _getStatusIcon(station.status),
              title: const Text('Status'),
              subtitle: Text(_getStatusName(station.status)),
            ),
            const Divider(),
            const Text(
              'Connector Types:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: station.connectorTypes.map((type) {
                return Chip(
                  label: Text(_getConnectorName(type)),
                  avatar: const Icon(Icons.electric_car, size: 16),
                );
              }).toList(),
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
  
  void _showBulkPriceUpdateDialog(BuildContext context, AdminProvider adminProvider) {
    final priceController = TextEditingController();
    bool isPercentage = false;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Update Prices'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'This will update the price for all charging stations that match your current filter criteria.',
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Fixed Price'),
                        value: false,
                        groupValue: isPercentage,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              isPercentage = value;
                            });
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Percentage'),
                        value: true,
                        groupValue: isPercentage,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              isPercentage = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: isPercentage ? 'Percentage Change (e.g. 10 or -5)' : 'New Price per kWh (\$)',
                    border: const OutlineInputBorder(),
                    prefixIcon: isPercentage ? const Icon(Icons.percent) : const Icon(Icons.attach_money),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                ),
                
                const SizedBox(height: 16),
                
                Consumer<AdminProvider>(
                  builder: (context, adminProvider, child) {
                    final filteredStations = _getFilteredStations(adminProvider.stations);
                    return Text(
                      'This will affect ${filteredStations.length} stations',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    );
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              try {
                if (priceController.text.isEmpty) {
                  throw Exception('Please enter a value');
                }
                
                final filteredStations = _getFilteredStations(adminProvider.stations);
                final stationIds = filteredStations.map((s) => s.id).toList();
                
                if (isPercentage) {
                  final percentageChange = double.parse(priceController.text);
                  adminProvider.bulkUpdateStationPricesByPercentage(stationIds, percentageChange);
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Prices updated by $percentageChange%'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  final newPrice = double.parse(priceController.text);
                  if (newPrice <= 0) {
                    throw Exception('Price must be greater than zero');
                  }
                  
                  adminProvider.bulkUpdateStationPrices(stationIds, newPrice);
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Prices updated to \$${newPrice.toStringAsFixed(2)}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invalid input: ${e.toString()}'),
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
  
  void _showBulkStatusUpdateDialog(BuildContext context, AdminProvider adminProvider) {
    StationStatus selectedStatus = StationStatus.available;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Update Status'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'This will update the status for all charging stations that match your current filter criteria.',
                ),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<StationStatus>(
                  decoration: const InputDecoration(
                    labelText: 'New Status',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedStatus,
                  items: StationStatus.values.map((StationStatus status) {
                    return DropdownMenuItem<StationStatus>(
                      value: status,
                      child: Text(_getStatusName(status)),
                    );
                  }).toList(),
                  onChanged: (StationStatus? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedStatus = newValue;
                      });
                    }
                  },
                ),
                
                const SizedBox(height: 16),
                
                Consumer<AdminProvider>(
                  builder: (context, adminProvider, child) {
                    final filteredStations = _getFilteredStations(adminProvider.stations);
                    return Text(
                      'This will affect ${filteredStations.length} stations',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    );
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              final filteredStations = _getFilteredStations(adminProvider.stations);
              final stationIds = filteredStations.map((s) => s.id).toList();
              
              adminProvider.bulkUpdateStationStatus(stationIds, selectedStatus);
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Status updated to ${_getStatusName(selectedStatus)} for ${stationIds.length} stations'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );
  }
  
  String _getStatusName(StationStatus status) {
    switch (status) {
      case StationStatus.available:
        return 'Available';
      case StationStatus.inUse:
        return 'In Use';
      case StationStatus.outOfService:
        return 'Out of Service';
      case StationStatus.underMaintenance:
        return 'Under Maintenance';
    }
  }
  
  String _getConnectorName(ConnectorType type) {
    switch (type) {
      case ConnectorType.type2:
        return 'Type 2';
      case ConnectorType.ccs:
        return 'CCS';
      case ConnectorType.chademo:
        return 'CHAdeMO';
      case ConnectorType.tesla:
        return 'Tesla';
    }
  }
}