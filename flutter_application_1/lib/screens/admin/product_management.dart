import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ProductManagement extends StatefulWidget {
  const ProductManagement({Key? key}) : super(key: key);

  @override
  _ProductManagementState createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  final ImagePicker _picker = ImagePicker();
  
  // Sample data - replace with your actual data source later
  List<Product> products = [
    Product(
      id: '1',
      name: 'EV Battery',
      description: 'Battery which keeps your vehicle active for longer time',
      price: 2.99,
      imageUrl: 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.indiatoday.in%2Fauto%2Fstory%2Funion-budget-2023-24-govt-removes-customs-duty-on-import-of-goods-machinery-for-making-li-ion-cells-2329164-2023-02-01&psig=AOvVaw348UkdUFq3pnt2LzoTy01a&ust=1743443623261000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCKi5meOvsowDFQAAAAAdAAAAABAE',
      category: 'Batteries',
      stockQuantity: 50,
    ),
    Product(
      id: '2',
      name: 'Motor',
      description: 'Motors for faster and smoother ride.',
      price: 1.99,
      imageUrl: 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.motownindia.com%2FBureau%2FAuto-Industry%2F2069%2FRicardo-next-gen-electric-vehicle-motor-Motown-India-Bureau&psig=AOvVaw3O8KuRngtR4w2v0wie6FCF&ust=1743443897999000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCPCE6uSwsowDFQAAAAAdAAAAABAE',
      category: 'EV Motors',
      stockQuantity: 75,
    ),
    Product(
      id: '3',
      name: 'EV Charger',
      description: 'Charger for fast charging of your vehicles',
      price: 3.49,
      imageUrl: 'https://www.bing.com/images/search?view=detailV2&ccid=hiv3oBE5&id=93CD1105CCEF8EB18A11B7F98253385F6DADF571&thid=OIP.hiv3oBE5RDFSQKi2Q12K8QHaEK&mediaurl=https%3a%2f%2fcdn.motor1.com%2fimages%2fmgl%2fZ73pz%2fs1%2fthe-ultimate-buyer-s-guide-to-home-ev-chargers-plus-top-5-picks.jpg&exph=1080&expw=1920&q=EV+Charger+Brands&simid=608025777949055919&FORM=IRPRST&ck=9F438A6717D1EBC9228451E9476B4A18&selectedIndex=6&itb=0',
      category: 'Chargers',
      stockQuantity: 20,
    ),
  ];
  
  List<Product> filteredProducts = [];
  List<String> categories = ['Batteries', 'Storage', 'Chargers', 'EV Motors', 'EV Controllers', 'Tires & Wheels'];
  String? _selectedCategory;
  String sortBy = 'name'; // Default sort option
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    // Initialize filtered products with all products
    filteredProducts = List.from(products);
  }
  
  void _filterProducts(String query) {
    setState(() {
      filteredProducts = products.where((product) {
        final nameMatch = product.name.toLowerCase().contains(query.toLowerCase());
        final descriptionMatch = product.description.toLowerCase().contains(query.toLowerCase());
        final categoryMatch = _selectedCategory == null || product.category == _selectedCategory;
        
        return (nameMatch || descriptionMatch) && categoryMatch;
      }).toList();
      
      _sortProducts();
    });
  }
  
  void _sortProducts() {
    setState(() {
      switch (sortBy) {
        case 'name':
          filteredProducts.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'price_low':
          filteredProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'price_high':
          filteredProducts.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'stock':
          filteredProducts.sort((a, b) => b.stockQuantity.compareTo(a.stockQuantity));
          break;
      }
    });
  }
  
  void _deleteProduct(String id) {
    setState(() {
      products.removeWhere((p) => p.id == id);
      filteredProducts.removeWhere((p) => p.id == id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product deleted successfully')),
    );
  }
  
  void _showDeleteConfirmation(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteProduct(id);
            },
          ),
        ],
      ),
    );
  }
  
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }
  
  Future<void> _addNewProduct() async {
    await _showProductForm();
  }
  
  Future<void> _editProduct(Product product) async {
    await _showProductForm(product: product);
  }
  
  Future<void> _showProductForm({Product? product}) async {
    final isEditing = product != null;
    final nameController = TextEditingController(text: product?.name ?? '');
    final descriptionController = TextEditingController(text: product?.description ?? '');
    final priceController = TextEditingController(
      text: product != null ? product.price.toString() : '',
    );
    final stockController = TextEditingController(
      text: product != null ? product.stockQuantity.toString() : '',
    );
    
    String? selectedCategory = product?.category ?? categories.first;
    String? imageUrl = product?.imageUrl;
    File? imageFile;
    
    final formKey = GlobalKey<FormState>();
    
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Product' : 'Add New Product'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price (\$)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    try {
                      final price = double.parse(value);
                      if (price <= 0) {
                        return 'Price must be greater than zero';
                      }
                    } catch (e) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: stockController,
                  decoration: const InputDecoration(labelText: 'Stock Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter stock quantity';
                    }
                    try {
                      final stock = int.parse(value);
                      if (stock < 0) {
                        return 'Stock cannot be negative';
                      }
                    } catch (e) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  value: selectedCategory,
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedCategory = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Product Image:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final pickedFile = await _picker.pickImage(
                            source: ImageSource.gallery,
                            maxWidth: 800,
                          );
                          
                          if (pickedFile != null) {
                            setState(() {
                              imageFile = File(pickedFile.path);
                              imageUrl = pickedFile.path; // Store local path for now
                            });
                          }
                        },
                        child: const Text('Select Image'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (imageUrl != null || imageFile != null)
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: imageFile != null
                        ? Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                          )
                        : imageUrl!.startsWith('http')
                            ? Image.network(
                                imageUrl!,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(imageUrl!),
                                fit: BoxFit.cover,
                              ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text(isEditing ? 'Update' : 'Add'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                if (imageUrl == null && imageFile == null) {
                  _showErrorDialog('Please select an image for the product');
                  return;
                }
                
                Navigator.of(ctx).pop();
                
                // Show loading indicator
                setState(() {
                  _isLoading = true;
                });
                
                try {
                  final newProduct = Product(
                    id: isEditing ? product.id : DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    description: descriptionController.text.trim(),
                    price: double.parse(priceController.text.trim()),
                    imageUrl: imageUrl ?? '',
                    category: selectedCategory ?? categories.first,
                    stockQuantity: int.parse(stockController.text.trim()),
                  );
                  
                  setState(() {
                    if (isEditing) {
                      // Update existing product
                      final index = products.indexWhere((p) => p.id == product.id);
                      if (index >= 0) {
                        products[index] = newProduct;
                      }
                    } else {
                      // Add new product
                      products.add(newProduct);
                    }
                    
                    // Update filtered products
                    _filterProducts('');
                    _isLoading = false;
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEditing ? 'Product updated successfully' : 'Product added successfully'),
                    ),
                  );
                } catch (e) {
                  setState(() {
                    _isLoading = false;
                  });
                  _showErrorDialog('Error: $e');
                }
              }
            },
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewProduct,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search products...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onChanged: (value) {
                            _filterProducts(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          value: _selectedCategory,
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('All Categories'),
                            ),
                            ...categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                              _filterProducts('');
                            });
                          },
                          hint: const Text('Select Category'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                                                        border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          value: sortBy,
                          items: const [
                            DropdownMenuItem(value: 'name', child: Text('Name')),
                            DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                            DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
                            DropdownMenuItem(value: 'stock', child: Text('Stock')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                sortBy = value;
                                _sortProducts();
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? Center(
                            child: Text(
                              products.isEmpty
                                  ? 'No products added yet. Add your first product!'
                                  : 'No products match your search criteria.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (ctx, index) {
                              final product = filteredProducts[index];
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
                                          child: product.imageUrl.startsWith('http')
                                              ? Image.network(
                                                  product.imageUrl,
                                                  height: 120,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      height: 120,
                                                      width: double.infinity,
                                                      color: Colors.grey[300],
                                                      child: const Icon(Icons.image_not_supported, size: 50),
                                                    );
                                                  },
                                                )
                                              : Image.file(
                                                  File(product.imageUrl),
                                                  height: 120,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      height: 120,
                                                      width: double.infinity,
                                                      color: Colors.grey[300],
                                                      child: const Icon(Icons.image_not_supported, size: 50),
                                                    );
                                                  },
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
                                              '\$${product.price.toStringAsFixed(2)}',
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
                                            product.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.description,
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
                                                product.category,
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
                                                'Stock: ${product.stockQuantity}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: product.stockQuantity > 10
                                                      ? Colors.green
                                                      : product.stockQuantity > 0
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, size: 20),
                                          onPressed: () => _editProduct(product),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                          onPressed: () => _showDeleteConfirmation(product.id),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final int stockQuantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stockQuantity,
  });
}