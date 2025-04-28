class Store {
  String? id;
  String name;
  String description;
  String imageUrl;
  
  Store({
    this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
  
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
