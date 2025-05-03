import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/admin_provider.dart';
import '../../models/store.dart';

class StoreManagement extends StatefulWidget {
  @override
  _StoreManagementState createState() => _StoreManagementState();
}

class _StoreManagementState extends State<StoreManagement> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _imageUrl = '';
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    
    // Initialize with existing data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      if (adminProvider.store != null) {
        _nameController.text = adminProvider.store!.name;
        _descriptionController.text = adminProvider.store!.description;
        _imageUrl = adminProvider.store!.imageUrl;
      }
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
  
  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }
  
  Future<void> _saveStore() async {
    if (_formKey.currentState!.validate()) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      
      final updatedStore = Store(
        id: adminProvider.store?.id,
        name: _nameController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrl.isEmpty 
            ? 'https://via.placeholder.com/150' 
            : _imageUrl,
      );
      
      await adminProvider.updateStore(updatedStore);
      
      setState(() {
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Store details updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (ctx, adminProvider, _) {
        final store = adminProvider.store;
        
        if (store == null) {
          return Center(child: CircularProgressIndicator());
        }
        
        return SingleChildScrollView(
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
                  child: _isEditing
                      ? _buildEditForm()
                      : _buildStoreDetails(store),
                ),
              ),
              SizedBox(height: 20),
              if (!_isEditing)
                ElevatedButton.icon(
                  onPressed: _toggleEdit,
                  icon: Icon(Icons.edit),
                  label: Text('Edit Store Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildStoreDetails(Store store) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Store Information',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        Divider(thickness: 1),
        SizedBox(height: 16),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _imageUrl.startsWith('http')
                ? Image.network(
                    _imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : _imageUrl.isNotEmpty
                    ? Image.file(
                        File(_imageUrl),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        'https://via.placeholder.com/150',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
          ),
        ),
        SizedBox(height: 20),
        ListTile(
          leading: Icon(Icons.store, color: Colors.indigo),
          title: Text('Store Name'),
          subtitle: Text(
            store.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        ListTile(
          leading: Icon(Icons.description, color: Colors.indigo),
          title: Text('Description'),
          subtitle: Text(
            store.description,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
  
  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit Store Information',
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
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : _imageUrl.isNotEmpty
                          ? Image.file(
                              File(_imageUrl),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              'https://via.placeholder.com/150',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.green.shade700,
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
              labelText: 'Store Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.store),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a store name';
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
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                onPressed: _toggleEdit,
                icon: Icon(Icons.cancel),
                label: Text('Cancel'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _saveStore,
                icon: Icon(Icons.save),
                label: Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}