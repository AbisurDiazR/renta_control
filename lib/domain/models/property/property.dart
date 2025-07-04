import 'package:renta_control/domain/models/owner/owner_model.dart';

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
  final OwnerModel? owner;
  //final String? ownerId; // ID del propietario
  final String? status;
  //final String? ownerName;

  // Nuevos campos para la propiedad detallada (Parrafo 1.b)
  final double? landArea; // Superficie del terreno en metros cuadrados
  final double? constructionArea; // **CORREGIDO: 'constructionArea' con 's'**

  // Nuevos campos para la escritura y registro
  final String? deedNumber; // Número de escritura
  final String? deedVolume; // Volumen de escritura
  final String? notaryName; // Nombre del notario
  final String? notaryNumber; // Número de notaria
  final String? notaryCity; // Ciudad donde se otorgó la notaría
  final String? notaryState; // Estado donde se otorgó la notaría
  final DateTime? registrationDate; // **CORREGIDO: Tipo DateTime?**
  final String? registrationNumber; // Número de registro de la propiedad
  final String? registrationFolio; // Foja de regigstro RPPC
  final String? registrationVolume; // Volumen de registro RPPC
  final String? registrationSection; // Sección de registro RPPC

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
    this.owner,
    //required this.ownerId, // Si es required, considera si siempre lo tendrás al crear.
    this.status,
    //this.ownerName,
    this.landArea,
    this.constructionArea, // **CORREGIDO: 'constructionArea'**
    this.deedNumber,
    this.deedVolume,
    this.notaryName,
    this.notaryNumber,
    this.notaryCity,
    this.notaryState,
    this.registrationDate,
    this.registrationNumber,
    this.registrationFolio,
    this.registrationVolume,
    this.registrationSection,
  });

  Property copyWith({
    String? id,
    String? name,
    String?
    unitNumber, // Este campo parece no estar en la clase, revisar si es necesario
    String? street,
    String? extNumber,
    String? intNumber,
    String? neighborhood,
    String? borough,
    String? city,
    String? state,
    String? zipCode,
    String? notes,
    OwnerModel? owner,
    //String? ownerId,
    String? status,
    //String? ownerName,
    double? landArea,
    double? constructionArea, // **CORREGIDO: 'constructionArea'**
    String? deedNumber,
    String? deedVolume,
    String? notaryName,
    String? notaryNumber,
    String? notaryCity,
    String? notaryState,
    DateTime? registrationDate, // **CORREGIDO: Tipo DateTime?**
    String? registrationNumber,
    String? registrationFolio,
    String? registrationVolume,
    String? registrationSection,
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
      owner: owner ?? this.owner,
      //ownerId: ownerId ?? this.ownerId,
      status: status ?? this.status,
      //ownerName: ownerName ?? this.ownerName,
      landArea: landArea ?? this.landArea,
      constructionArea:
          constructionArea ?? this.constructionArea, // **CORREGIDO**
      deedNumber: deedNumber ?? this.deedNumber,
      deedVolume: deedVolume ?? this.deedVolume,
      notaryName: notaryName ?? this.notaryName,
      notaryNumber: notaryNumber ?? this.notaryNumber,
      notaryCity: notaryCity ?? this.notaryCity,
      notaryState: notaryState ?? this.notaryState,
      registrationDate:
          registrationDate ?? this.registrationDate, // **CORREGIDO**
      registrationNumber: registrationNumber ?? this.registrationNumber,
      registrationFolio: registrationFolio ?? this.registrationFolio,
      registrationVolume: registrationVolume ?? this.registrationVolume,
      registrationSection: registrationSection ?? this.registrationSection,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'street': street,
      'extNumber': extNumber,
      'intNumber': intNumber,
      'neighborhood': neighborhood,
      'borough': borough,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'notes': notes,
      'owner': owner!.toMap(),
      //'ownerId': ownerId,
      'status': status,
      //'ownerName': ownerName,
      'landArea': landArea,
      'constructionArea': constructionArea, // **CORREGIDO: 'constructionArea'**
      'deedNumber': deedNumber,
      'deedVolume': deedVolume,
      'notaryName': notaryName,
      'notaryNumber': notaryNumber,
      'notaryCity': notaryCity,
      'notaryState': notaryState,
      'registrationDate':
          registrationDate
              ?.toIso8601String(), // **CORREGIDO: Convertir a String**
      'registrationNumber': registrationNumber,
      'registrationFolio': registrationFolio,
      'registrationVolume': registrationVolume,
      'registrationSection': registrationSection,
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
      owner: OwnerModel.fromMap(map['owner'] as Map<String, dynamic>, documentId),
      //ownerId: map['ownerId'],
      status: map['status'],
      //ownerName: map['ownerName'],
      landArea:
          (map['landArea'] as num?)?.toDouble(), // **CORREGIDO: Casteo seguro**
      constructionArea:
          (map['constructionArea'] as num?)
              ?.toDouble(), // **CORREGIDO: Ortografía y casteo seguro**
      deedNumber: map['deedNumber'],
      deedVolume: map['deedVolume'],
      notaryName: map['notaryName'],
      notaryNumber: map['notaryNumber'],
      notaryCity: map['notaryCity'],
      notaryState: map['notaryState'],
      registrationDate:
          map['registrationDate'] != null
              ? DateTime.parse(
                map['registrationDate'] as String,
              ) // **CORREGIDO: Parsear a DateTime**
              : null,
      registrationNumber: map['registrationNumber'],
      registrationFolio: map['registrationFolio'],
      registrationVolume: map['registrationVolume'],
      registrationSection: map['registrationSection'],
    );
  }
}
