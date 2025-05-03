class Product {
  String? id;
  String name;
  String description;
  double price;
  int stockQuantity;
  String imageUrl;
  String category;
  
  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.imageUrl,
    required this.category,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stockQuantity': stockQuantity,
      'imageUrl': imageUrl,
      'category': category,
    };
  }
  
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      stockQuantity: json['stockQuantity'],
      imageUrl: json['imageUrl'],
      category: json['category'],
    );
  }
}
