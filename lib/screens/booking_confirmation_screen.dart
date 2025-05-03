import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../models/booking.dart';
import '../models/station.dart';
import '../models/vehicle.dart';

class BookingConfirmationScreen extends StatefulWidget {
  static const routeName = '/booking-confirmation';

  final Station station;
  final DateTime selectedDate;
  final TimeOfDay startTime;
  final int durationMinutes;
  final Vehicle vehicle;
  final String chargerType;
  final int chargerNumber;

  const BookingConfirmationScreen({
    Key? key,
    required this.station,
    required this.selectedDate,
    required this.startTime,
    required this.durationMinutes,
    required this.vehicle,
    required this.chargerType,
    required this.chargerNumber,
  }) : super(key: key);

  @override
  _BookingConfirmationScreenState createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late String _bookingId;
  late TimeOfDay _endTime;
  late double _estimatedCost;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Generate a random booking ID
    _bookingId = _generateBookingId();
    
    // Calculate end time
    final int endMinutes = widget.startTime.hour * 60 + widget.startTime.minute + widget.durationMinutes;
    _endTime = TimeOfDay(hour: endMinutes ~/ 60 % 24, minute: endMinutes % 60);
    
    // Calculate estimated cost (example calculation)
    final double ratePerHour = _getRateForChargerType(widget.chargerType);
    _estimatedCost = ratePerHour * (widget.durationMinutes / 60);
    
    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _generateBookingId() {
    final Random random = Random();
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(6);
    final int randomPart = random.nextInt(9000) + 1000;
    return 'EV$timestamp$randomPart';
  }
  double _getRateForChargerType(String chargerType) {
    // Example rates per hour
    switch (chargerType) {
      case 'Fast Charger':
        return 15.0;
      case 'Super Charger':
        return 25.0;
      case 'Ultra Charger':
        return 35.0;
      default:
        return 10.0;
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat.jm().format(dateTime);
  }

  Future<void> _confirmBooking() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Create booking object
    final booking = Booking(
      id: _bookingId,
      stationId: widget.station.id,
      stationName: widget.station.name,
      vehicleId: widget.vehicle.id,
      vehicleName: widget.vehicle.model,
      date: widget.selectedDate,
      startTime: widget.startTime,
      endTime: _endTime,
      chargerType: widget.chargerType,
      chargerNumber: widget.chargerNumber,
      cost: _estimatedCost,
      status: 'Confirmed',
    );

    // In a real app, you would save this booking to your database
    // bookingProvider.addBooking(booking);

    setState(() {
      _isLoading = false;
    });

    // Show confirmation dialog
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade700, size: 28),
            const SizedBox(width: 10),
            const Text('Booking Confirmed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your booking has been confirmed. A confirmation has been sent to your email and mobile number.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Booking ID: $_bookingId',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Navigate to bookings history page
              // Navigator.of(context).pushReplacementNamed('/bookings');
            },
            child: const Text('View My Bookings'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushReplacementNamed('/home');
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green.shade700),
                  const SizedBox(height: 16),
                  const Text('Processing your booking...'),
                ],
              ),
            )
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header with station image
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        image: DecorationImage(
                          image: NetworkImage(widget.station.imageUrl),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.station.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.station.address,
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Booking details
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Booking Details',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              const SizedBox(height: 8),
                              
                              // Booking ID
                              _buildDetailRow(
                                icon: Icons.confirmation_number,
                                title: 'Booking ID',
                                value: _bookingId,
                                isHighlighted: true,
                              ),
                              
                              // Date
                              _buildDetailRow(
                                icon: Icons.calendar_today,
                                title: 'Date',
                                value: DateFormat.yMMMMd().format(widget.selectedDate),
                              ),
                              
                              // Time
                              _buildDetailRow(
                                icon: Icons.access_time,
                                title: 'Time',
                                value: '${_formatTimeOfDay(widget.startTime)} - ${_formatTimeOfDay(_endTime)}',
                              ),
                              
                              // Duration
                              _buildDetailRow(
                                icon: Icons.timelapse,
                                title: 'Duration',
                                value: '${widget.durationMinutes} minutes',
                              ),
                              
                              // Vehicle
                              _buildDetailRow(
                                icon: Icons.electric_car,
                                title: 'Vehicle',
                                value: '${widget.vehicle.make} ${widget.vehicle.model}',
                              ),
                              
                              // Charger Type
                              _buildDetailRow(
                                icon: Icons.electrical_services,
                                title: 'Charger Type',
                                value: widget.chargerType,
                              ),
                              
                              // Charger Number
                              _buildDetailRow(
                                icon: Icons.power,
                                title: 'Charger Number',
                                value: '#${widget.chargerNumber}',
                              ),
                              
                              const Divider(),
                              
                              // Cost
                              _buildDetailRow(
                                icon: Icons.attach_money,
                                title: 'Estimated Cost',
                                value: '\$${_estimatedCost.toStringAsFixed(2)}',
                                isHighlighted: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Payment method
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment Method',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.credit_card, color: Colors.green.shade700),
                                  ),
                                  const SizedBox(width: 16),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Credit Card',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text('**** **** **** 4582'),
                                    ],
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      // Show payment method selection dialog
                                    },
                                    child: const Text('Change'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Notes
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notes',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                maxLines: 3,
                                decoration: InputDecoration(
                                  hintText: 'Add any special instructions or notes...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Cancellation policy
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        elevation: 2,
                        color: Colors.amber.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                                                        children: [
                              Icon(Icons.info_outline, color: Colors.amber.shade800),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cancellation Policy',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Free cancellation up to 1 hour before the scheduled time. Late cancellations may incur a fee of 50% of the booking amount.',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Confirm button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: _confirmBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Confirm Booking',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    // Cancel button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.green.shade700, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                    fontSize: isHighlighted ? 16 : 14,
                    color: isHighlighted ? Colors.green.shade700 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

