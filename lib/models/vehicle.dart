class Vehicle {
  final String id;
  final String make;
  final String model;
  final String licensePlate;
  final String batteryCapacity; // in kWh
  final String chargerType;
  final String imageUrl;
  final int year;
  final int currentCharge;

  Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.licensePlate,
    required this.batteryCapacity,
    required this.chargerType,
    required this.imageUrl,
    required this.year,
    this.currentCharge = 0, 
  });

  // Factory constructor to create a Vehicle from a map (from database)
  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      make: map['make'],
      model: map['model'],
      licensePlate: map['licensePlate'],
      batteryCapacity: map['batteryCapacity'],
      chargerType: map['chargerType'],
      imageUrl: map['imageUrl'],
      year: map['year'],
    );
  }

  // Convert vehicle to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'licensePlate': licensePlate,
      'batteryCapacity': batteryCapacity,
      'chargerType': chargerType,
      'imageUrl': imageUrl,
      'year': year,
    };
  }
}
