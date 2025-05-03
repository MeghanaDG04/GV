import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String _apiUrl = 'https://api.stripe.com/v1/payment_intents';
  // Replace with your actual Stripe secret key in a secure way
  static const String _secretKey = 'sk_test_your_stripe_secret_key';
  
  Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      
      return jsonDecode(response.body);
    } catch (err) {
      print('Error creating payment intent: $err');
      throw Exception(err);
    }
  }

  Future<void> makePayment({
    required String amount,
    required String currency,
  }) async {
    try {
      // Create payment intent
      Map<String, dynamic> paymentIntent = await createPaymentIntent(amount, currency);
      
      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'Your App Name',
          style: ThemeMode.light,
        ),
      );
      
      // Present payment sheet
      await Stripe.instance.presentPaymentSheet();
      
      // Payment completed successfully
      return;
    } catch (e) {
      if (e is StripeException) {
        print('Error from Stripe: ${e.error.localizedMessage}');
      } else {
        print('Unforeseen error: $e');
      }
      throw Exception(e);
    }
  }
}
