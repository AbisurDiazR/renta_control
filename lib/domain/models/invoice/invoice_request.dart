class InvoiceRequest {
  final String paymentForm;
  final String use;
  final Customer customer;
  final List<Item> items;

  InvoiceRequest({
    required this.paymentForm,
    required this.use,
    required this.customer,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
    'payment_form': paymentForm,
    'use': use,
    'customer': customer.toJson(),
    'items': items.map((item) => item.toJson()).toList(),
  };
}

class Customer {
  final String legalName;
  final String taxId;
  final String taxSystem;
  final String email;
  final Address address;

  Customer({
    required this.legalName,
    required this.taxId,
    required this.taxSystem,
    required this.email,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    'legal_name': legalName,
    'tax_id': taxId,
    'tax_system': taxSystem,
    'email': email,
    'address': address.toJson(),
  };
}

class Address {
  final String zip;

  Address({required this.zip});

  Map<String, dynamic> toJson() => {'zip': zip};
}

class Item {
  final int quantity;
  final Product product;

  Item({required this.quantity, required this.product});

  Map<String, dynamic> toJson() => {
    'quantity': quantity,
    'product': product.toJson(),
  };
}

class Product {
  final String description;
  final String productKey;
  final String unitKey;
  final double price;

  Product({
    required this.description,
    required this.productKey,
    required this.unitKey,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'description': description,
    'product_key': productKey,
    'unit_key': unitKey,
    'price': price,
  };
}
