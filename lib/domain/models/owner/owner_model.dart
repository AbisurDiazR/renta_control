class OwnerModel {
  final String? id; // ID del propietario
  final String name; // Nombre completo
  final String email; // Correo electrónico
  final String phone; // Teléfono
  final String street; // Calle
  final String extNumber; // Número exterior
  final String? intNumber; // Número interior (Opcional)
  final String neighborhood; // Colonia
  final String borough; // Alcaldía
  final String city; // Ciudad
  final String state; // Estado
  final String zipCode; // Código Postal

  OwnerModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.street,
    required this.extNumber,
    this.intNumber,
    required this.neighborhood,
    required this.borough,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  /// **Método para convertir el objeto en un mapa (para Firebase o JSON)**
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'street': street,
      'extNumber': extNumber,
      'intNumber': intNumber,
      'neighborhood': neighborhood,
      'borough': borough,
      'city': city,
      'state': state,
      'zipCode': zipCode,
    };
  }

  OwnerModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? street,
    String? extNumber,
    String? intNumber,
    String? neighborhood,
    String? borough,
    String? city,
    String? state,
    String? zipCode,
  }) {
    return OwnerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      extNumber: extNumber ?? this.extNumber,
      intNumber: intNumber ?? this.intNumber,
      neighborhood: neighborhood ?? this.neighborhood,
      borough: borough ?? this.borough,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
    );
  }

  factory OwnerModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OwnerModel(
      id: documentId,
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      street: map['street'],
      extNumber: map['extNumber'],
      intNumber: map['intNumber'],
      neighborhood: map['neighborhood'],
      borough: map['borough'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zipCode'],
    );
  }
}
