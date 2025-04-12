class Invoice {
  final String legalName;
  final String taxId;
  final String email;
  final String zip;
  final String taxSystem;
  final String paymentForm;
  final String cfdiUse;
  final String productDescription;
  final String productKey;
  final String unitKey;
  final double productPrice;
  final int productQuantity;

  Invoice({
    required this.legalName,
    required this.taxId,
    required this.email,
    required this.zip,
    required this.taxSystem,
    required this.paymentForm,
    required this.cfdiUse,
    required this.productDescription,
    required this.productKey,
    required this.unitKey,
    required this.productPrice,
    required this.productQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'payment_form': paymentForm,
      'use': cfdiUse,
      'customer': {
        'legal_name': legalName,
        'tax_id': taxId,
        'tax_system': taxSystem,
        'email': email,
        'address': {'zip': zip},
      },
      'items': [
        {
          'quantity': productQuantity,
          'product': {
            'description': productDescription,
            'product_key': productKey,
            'unit_key': unitKey,
            'price': productPrice,
          },
        },
      ],
    };
  }
}
