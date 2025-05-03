class PaymentModel {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardHolderName;
  final double amount;

  PaymentModel({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardHolderName,
    required this.amount,
  });
}
