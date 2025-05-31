class Representative {
  final String? id; // Id del representante
  final String fullName;
  final String documentType;
  final String documentNumber;
  final String street;
  final String extNumber;
  final String? intNumber; // Optional
  final String neighborhood;
  final String borough;
  final String city;
  final String state;
  final String zipCode;
  final String phoneNumber;
  final String email;
  final String? rfc; // Añadido: Registro Federal de Contribuyentes
  final String? curp; // Añadido: Clave Única de Registro de Población

  Representative({
    this.id,
    required this.fullName,
    required this.documentType,
    required this.documentNumber,
    required this.street,
    required this.extNumber,
    this.intNumber,
    required this.neighborhood,
    required this.borough,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phoneNumber,
    required this.email,
    this.rfc,
    this.curp,
  });

  Representative copyWith({
    String? id,
    String? fullName,
    String? documentType,
    String? documentNumber,
    String? street,
    String? extNumber,
    String? intNumber,
    String? neighborhood,
    String? borough,
    String? city,
    String? state,
    String? zipCode,
    String? phoneNumber,
    String? email,
    String? rfc,
    String? curp,
    String? powerOfAttorneyDescription,
    DateTime? powerOfAttorneyStartDate,
    DateTime? powerOfAttorneyEndDate,
  }) {
    return Representative(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      street: street ?? this.street,
      extNumber: extNumber ?? this.extNumber,
      intNumber: intNumber ?? this.intNumber,
      neighborhood: neighborhood ?? this.neighborhood,
      borough: borough ?? this.borough,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      rfc: rfc ?? this.rfc,
      curp: curp ?? this.curp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'documentType': documentType,
      'documentNumber': documentNumber,
      'street': street,
      'extNumber': extNumber,
      'intNumber': intNumber,
      'neighborhood': neighborhood,
      'borough': borough,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'phoneNumber': phoneNumber,
      'email': email,
      'rfc': rfc,
      'curp': curp,
    };
  }

  factory Representative.fromMap(Map<String, dynamic> map, String docId) {
    return Representative(
      id: docId,
      fullName: map['fullName'] ?? '',
      documentType: map['documentType'] ?? '',
      documentNumber: map['documentNumber'] ?? '',
      street: map['street'] ?? '',
      extNumber: map['extNumber'] ?? '',
      intNumber: map['intNumber'],
      neighborhood: map['neighborhood'] ?? '',
      borough: map['borough'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      rfc: map['rfc'],
      curp: map['curp'],
    );
  }
}
