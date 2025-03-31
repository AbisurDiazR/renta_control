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
}
