class Tenant {
  final String? id; // ID único del inquilino
  final String fullName; // Nombre completo
  final String email; // Correo electrónico
  final String phone; // Número de teléfono
  final String documentType; // Tipo de documento (DNI, NIE, Pasaporte)
  final String documentNumber; // Número del documento
  final String occupation; // Ocupación o profesión
  final double monthlyIncome; // Ingreso mensual
  final String? employer; // Empleador actual (opcional)
  final String street; // Calle
  final String extNumber; // Número exterior
  final String? intNumber; // Número interior (opcional)
  final String neighborhood; // Colonia o barrio
  final String borough; // Alcaldía o municipio
  final String city; // Ciudad
  final String state; // Estado o provincia
  final String zipCode; // Código postal
  final String? notes; // Notas adicionales (opcional)

  Tenant({
    this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.documentType,
    required this.documentNumber,
    required this.occupation,
    required this.monthlyIncome,
    this.employer,
    required this.street,
    required this.extNumber,
    this.intNumber,
    required this.neighborhood,
    required this.borough,
    required this.city,
    required this.state,
    required this.zipCode,
    this.notes,
  });

  Tenant copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? documentType,
    String? documentNumber,
    String? occupation,
    double? monthlyIncome,
    String? employer,
    String? street,
    String? extNumber,
    String? intNumber,
    String? neighborhood,
    String? borough,
    String? city,
    String? state,
    String? zipCode,
    String? notes,
  }) {
    return Tenant(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      occupation: occupation ?? this.occupation,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      employer: employer ?? this.employer,
      street: street ?? this.street,
      extNumber: state ?? this.state,
      intNumber: intNumber ?? this.intNumber,
      neighborhood: neighborhood ?? this.neighborhood,
      borough: borough ?? this.borough,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "documentType": documentType,
      "documentNumber": documentNumber,
      "occupation": occupation,
      "monthlyIncome": monthlyIncome,
      "employer": employer,
      "street": street,
      "extNumber": state,
      "intNumber": intNumber,
      "neighborhood": neighborhood,
      "borough": borough,
      "city": city,
      "state": state,
      "zipCode": zipCode,
      "notes": notes,
    };
  }

  factory Tenant.fromMap(Map<String, dynamic> map, String documentId) {
    return Tenant(
      id: documentId,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      documentType: map['documentType'] ?? '',
      documentNumber: map['documentNumber'] ?? '',
      occupation: map['occupation'] ?? '',
      monthlyIncome: map['monthlyIncome'] ?? '',
      employer: map['employer'] ?? '',
      street: map['street'] ?? '',
      extNumber: map['extNumber'] ?? '',
      intNumber: map['intNumber'],
      neighborhood: map['neighborhood'] ?? '',
      borough: map['borough'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      notes: map['notes'] ?? ''
    );
  }
}
