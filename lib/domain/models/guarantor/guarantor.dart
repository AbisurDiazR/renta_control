class Guarantor {
  final String id;
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
  final String occupation;
  final double monthlyIncome;
  final String employer;

  Guarantor({
    this.id = '',
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
    required this.occupation,
    required this.monthlyIncome,
    required this.employer,
  });

  Guarantor copyWith({
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
    String? occupation,
    double? monthlyIncome,
    String? employer,
    String? relationshipToTenant,
  }) {
    return Guarantor(
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
      occupation: occupation ?? this.occupation,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      employer: employer ?? this.employer,
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
      'occupation': occupation,
      'monthlyIncome': monthlyIncome,
      'employer': employer,
    };
  }

  factory Guarantor.fromMap(Map<String, dynamic> map, String docId) {
    return Guarantor(
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
      occupation: map['occupation'] ?? '',
      monthlyIncome: (map['monthlyIncome'] as num?)?.toDouble() ?? 0.0,
      employer: map['employer'] ?? '',
    );
  }
}
