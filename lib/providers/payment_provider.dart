import 'package:flutter/foundation.dart';

enum PaymentStatus {
  initial,
  loading,
  success,
  error,
}

class PaymentProvider with ChangeNotifier {
  PaymentStatus _status = PaymentStatus.initial;
  String? _error;

  PaymentStatus get status => _status;
  String? get error => _error;

  Future<void> processPayment(String amount) async {
    try {
      _status = PaymentStatus.loading;
      notifyListeners();

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      _status = PaymentStatus.success;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _status = PaymentStatus.error;
      notifyListeners();
      throw e;
    }
  }

  void reset() {
    _status = PaymentStatus.initial;
    _error = null;
    notifyListeners();
  }
}
