class Invoice {
  final String clientName;
  final String clientEmail;
  final String clientRFC;
  final String productDescription;
  final String productKey;
  final double productPrice;
  final int productQuantity;
  final String paymentMethod;
  final String invoiceUse;

  Invoice({
    required this.clientName,
    required this.clientEmail,
    required this.clientRFC,
    required this.productDescription,
    required this.productKey,
    required this.productPrice,
    required this.productQuantity,
    required this.paymentMethod,
    required this.invoiceUse,
  });

  double get totalAmount => productPrice * productQuantity;

  /// **Método para convertir el objeto en un mapa (para Firebase o JSON)**
  Map<String, dynamic> toMap() {
    return {
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientRFC': clientRFC,
      'productDescription': productDescription,
      'productKey': productKey,
      'productPrice': productPrice,
      'productQuantity': productQuantity,
      'paymentMethod': paymentMethod,
      'invoiceUse': invoiceUse,
      'totalAmount': totalAmount,
    };
  }
}
