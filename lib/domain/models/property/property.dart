
class Property {
  final String? id;
  final String name;
  final String unitNumber; // Número de departamento/local
  final String street; // Calle
  final String extNumber; // Número exterior
  final String? intNumber; // Número interior (Opcional)
  final String neighborhood; // Colonia
  final String borough; // Alcaldía
  final String city; // Ciudad
  final String state; // Estado
  final String zipCode; // Código postal
  final String propertyTaxNumber; // Número de cuenta predial
  final String? ownerId; // ID del propietario
  final String? status;
  final String? ownerName;

  Property({
    this.id,
    required this.name,
    required this.unitNumber,
    required this.street,
    required this.extNumber,
    this.intNumber,
    required this.neighborhood,
    required this.borough,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.propertyTaxNumber,
    required this.ownerId,
    this.status,
    this.ownerName
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
    String? propertyTaxNumber,
    String? ownerId,
    String? status,
    String? ownerName
  }) {
    return Property(
      id: id ?? this.id,
      name: name ?? this.name,
      unitNumber: unitNumber ?? this.unitNumber,
      street: street ?? this.street,
      extNumber: extNumber ?? this.extNumber,
      intNumber: intNumber ?? this.intNumber,
      neighborhood: neighborhood ?? this.neighborhood,
      borough: borough ?? this.borough,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      propertyTaxNumber: propertyTaxNumber ?? this.propertyTaxNumber,
      ownerId: ownerId ?? this.ownerId,
      status: status ?? this.status,
      ownerName: ownerName ?? this.ownerName
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unitNumber': unitNumber,
      'street': street,
      'extNumber': extNumber,
      'intNumber': intNumber, // Puede ser null
      'neighborhood': neighborhood,
      'borough': borough,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'propertyTaxNumber': propertyTaxNumber,
      'ownerId': ownerId,
      'status': status,
      'ownerName': ownerName
    };
  }
}
