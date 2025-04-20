class Property {
  final String? id;
  final String name;
  final String street; // Calle
  final String extNumber; // Número exterior
  final String? intNumber; // Número interior (Opcional)
  final String neighborhood; // Colonia
  final String borough; // Alcaldía
  final String city; // Ciudad
  final String state; // Estado
  final String zipCode; // Código postal
  final String notes; // Número de cuenta predial
  final String? ownerId; // ID del propietario
  final String? status;
  final String? ownerName;

  Property({
    this.id,
    required this.name,
    required this.street,
    required this.extNumber,
    this.intNumber,
    required this.neighborhood,
    required this.borough,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.notes,
    required this.ownerId,
    this.status,
    this.ownerName,
  });

  Property copyWith({
    String? id,
    String? name,
    String? unitNumber,
    String? street,
    String? extNumber,
    String? intNumber,
    String? neighborhood,
    String? borough,
    String? city,
    String? state,
    String? zipCode,
    String? notes,
    String? ownerId,
    String? status,
    String? ownerName,
    String? productKey, // e.g., '80131500'
    String? unitKey, // e.g., 'E48'
    double? price, // e.g., 10000.00
  }) {
    return Property(
      id: id ?? this.id,
      name: name ?? this.name,
      street: street ?? this.street,
      extNumber: extNumber ?? this.extNumber,
      intNumber: intNumber ?? this.intNumber,
      neighborhood: neighborhood ?? this.neighborhood,
      borough: borough ?? this.borough,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      notes: notes ?? this.notes,
      ownerId: ownerId ?? this.ownerId,
      status: status ?? this.status,
      ownerName: ownerName ?? this.ownerName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'street': street,
      'extNumber': extNumber,
      'intNumber': intNumber, // Puede ser null
      'neighborhood': neighborhood,
      'borough': borough,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'notes': notes,
      'ownerId': ownerId,
      'status': status,
      'ownerName': ownerName,
    };
  }

  factory Property.fromMap(Map<String, dynamic> map, String documentId) {
    return Property(
      id: documentId,
      name: map['name'],
      street: map['street'],
      extNumber: map['extNumber'],
      intNumber: map['intNumber'],
      neighborhood: map['neighborhood'],
      borough: map['borough'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zipCode'],
      notes: map['notes'],
      ownerId: map['ownerId'],
      status: map['status'],
      ownerName: map['ownerName'],
    );
  }
}
