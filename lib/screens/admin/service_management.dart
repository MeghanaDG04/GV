import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/admin_provider.dart';
import '../../models/service.dart';

class ServiceManagement extends StatefulWidget {
  @override
  _ServiceManagementState createState() => _ServiceManagementState();
}

class _ServiceManagementState extends State<ServiceManagement> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  String _imageUrl = '';
  bool _isEditing = false;
  String? _editingServiceId;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }
  
  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    setState(() {
      _imageUrl = '';
      _isEditing = false;
      _editingServiceId = null;
    });
  }
  
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      // In a real app, you would upload this image to a server and get a URL back
      setState(() {
        _imageUrl = image.path; // Just for demonstration
      });
    }
  }
  
  void _editService(Service service) {
    setState(() {
      _isEditing = true;
      _editingServiceId = service.id;
      _nameController.text = service.name;
      _descriptionController.text = service.description;
      _priceController.text = service.price.toString();
      _imageUrl = service.imageUrl;
    });
  }
  
  Future<void> _saveService() async {
    if (_formKey.currentState!.validate()) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      
      final service = Service(
        id: _editingServiceId,
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        imageUrl: _imageUrl.isEmpty 
            ? 'https://via.placeholder.com/150' 
            : _imageUrl,
      );
      
      if (_isEditing) {
        await adminProvider.updateService(service);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Service updated successfully')),
        );
      } else {
        await adminProvider.addService(service);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Service added successfully')),
        );
      }
      
      _resetForm();
    }
  }
  
  Future<void> _deleteService(String id) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    await adminProvider.removeService(id);    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Service deleted successfully')),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (ctx, adminProvider, _) {
        final services = adminProvider.services;
        
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEditing ? 'Edit Service' : 'Add New Service',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        Divider(thickness: 1),
                        SizedBox(height: 16),
                        Center(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: _imageUrl.startsWith('http')
                                    ? Image.network(
                                        _imageUrl,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      )
                                    : _imageUrl.isNotEmpty
                                        ? Image.file(
                                            File(_imageUrl),
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            'https://via.placeholder.com/150',
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.indigo,
                                  radius: 20,
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt, color: Colors.white),
                                    onPressed: _pickImage,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Service Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.miscellaneous_services),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a service name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.description),
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton.icon(
                              onPressed: _resetForm,
                              icon: Icon(Icons.cancel),
                              label: Text('Cancel'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _saveService,
                              icon: Icon(_isEditing ? Icons.save : Icons.add),
                              label: Text(_isEditing ? 'Update Service' : 'Add Service'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: services.isEmpty
                    ? Center(
                        child: Text(
                          'No services added yet. Add your first service!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: services.length,
                        itemBuilder: (ctx, index) {
                          final service = services[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: service.imageUrl.startsWith('http')
                                    ? Image.network(
                                        service.imageUrl,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(service.imageUrl),
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              title: Text(service.name),
                              subtitle: Text(
                                '\${service.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _editService(service),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _showDeleteConfirmation(service.id!),
                                  ),
                                ],
                              ),
                              onTap: () => _editService(service),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }    Future<void> _showDeleteConfirmation(String id) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this service?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteService(id);
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
