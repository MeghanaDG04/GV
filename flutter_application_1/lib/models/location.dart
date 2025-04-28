class StoreLocation {
  String? id;
  String address;
  double latitude;
  double longitude;
  String contactNumber;
  String email;
  
  StoreLocation({
    this.id,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.contactNumber,
    required this.email,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'contactNumber': contactNumber,
      'email': email,
    };
  }
  
  factory StoreLocation.fromJson(Map<String, dynamic> json) {
    return StoreLocation(
      id: json['id'],
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      contactNumber: json['contactNumber'],
      email: json['email'],
    );
  }
}
