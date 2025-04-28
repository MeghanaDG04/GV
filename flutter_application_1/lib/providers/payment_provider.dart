import 'package:flutter/foundation.dart';
import '../services/payment_service.dart';

enum PaymentStatus { initial, loading, success, failed }

class PaymentProvider with ChangeNotifier {
  PaymentStatus _status = PaymentStatus.initial;
  String _errorMessage = '';
  final PaymentService _paymentService = PaymentService();

  PaymentStatus get status => _status;
  String get errorMessage => _errorMessage;

  Future<void> processPayment(String amount) async {
    try {
      _status = PaymentStatus.loading;
      notifyListeners();

      // Convert amount to cents/smallest currency unit
      final amountInCents = (double.parse(amount) * 100).round().toString();
      
      await _paymentService.makePayment(
        amount: amountInCents,
        currency: 'usd', // Change as needed
      );

      _status = PaymentStatus.success;
      notifyListeners();
    } catch (e) {
      _status = PaymentStatus.failed;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void resetStatus() {
    _status = PaymentStatus.initial;
    _errorMessage = '';
    notifyListeners();
  }
}
