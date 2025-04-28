enum StationStatus {
  available,
  inUse,
  outOfService,
  underMaintenance,
}

enum ConnectorType {
  type2,
  ccs,
  chademo,
  tesla,
}

class ChargingStation {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double pricePerKwh;
  final StationStatus status;
  final List<ConnectorType> connectorTypes;
  final double powerKw;
  
  ChargingStation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.pricePerKwh,
    required this.status,
    required this.connectorTypes,
    required this.powerKw,
  });
}
