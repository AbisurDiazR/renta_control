import 'package:renta_control/domain/models/property/property.dart';

class Contract {
  final String? id;
  final Property? property;
  final String renter;
  final String contractBody;
  final String? ownerEmail;
  final String propertyName;

  Contract({ this.id, this.property, required this.renter, required this.contractBody, required this.ownerEmail, required this.propertyName});

}
