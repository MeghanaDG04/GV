import 'package:flutter/material.dart';
import 'vehicle.dart';

class Booking {
  final String id;
  final String stationId;
  final String stationName;
  final String vehicleId;
  final String vehicleName;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String chargerType;
  final int chargerNumber;
  final double cost;
  final String status; // 'Pending', 'Confirmed', 'Completed', 'Cancelled'
  Vehicle? vehicle;

  Booking({
    required this.id,
    required this.stationId,
    required this.stationName,
    required this.vehicleId,
    required this.vehicleName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.chargerType,
    required this.chargerNumber,
    required this.cost,
    required this.status,
    this.vehicle,
  });

  // Convert booking to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stationId': stationId,
      'stationName': stationName,
      'vehicleId': vehicleId,
      'vehicleName': vehicleName,
      'date': date.toIso8601String(),
      'startTimeHour': startTime.hour,
      'startTimeMinute': startTime.minute,
      'endTimeHour': endTime.hour,
      'endTimeMinute': endTime.minute,
      'chargerType': chargerType,
      'chargerNumber': chargerNumber,
      'cost': cost,
      'status': status,
    };
  }

  // Create a booking from a map (from database)
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      stationId: map['stationId'],
      stationName: map['stationName'],
      vehicleId: map['vehicleId'],
      vehicleName: map['vehicleName'],
      date: DateTime.parse(map['date']),
      startTime: TimeOfDay(hour: map['startTimeHour'], minute: map['startTimeMinute']),
      endTime: TimeOfDay(hour: map['endTimeHour'], minute: map['endTimeMinute']),
      chargerType: map['chargerType'],
      chargerNumber: map['chargerNumber'],
      cost: map['cost'],
      status: map['status'],
    );
  }
}
