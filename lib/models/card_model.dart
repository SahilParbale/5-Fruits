class PaymentCard {
  final String id;
  final String type; // Visa, Mastercard, Amex
  final String number;
  final String holder;
  final String expiryMonth;
  final String expiryYear;
  final String cvv;
  final bool isDefault;

  PaymentCard({
    required this.id,
    required this.type,
    required this.number,
    required this.holder,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvv,
    required this.isDefault,
  });

  PaymentCard copyWith({
    String? id,
    String? type,
    String? number,
    String? holder,
    String? expiryMonth,
    String? expiryYear,
    String? cvv,
    bool? isDefault,
  }) {
    return PaymentCard(
      id: id ?? this.id,
      type: type ?? this.type,
      number: number ?? this.number,
      holder: holder ?? this.holder,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      cvv: cvv ?? this.cvv,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
