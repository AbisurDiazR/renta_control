import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renta_control/domain/models/property/property.dart';

class PropertyRepository {
  final CollectionReference _propertiesCollection = FirebaseFirestore.instance
      .collection("properties");

  Future<void> addProperty(Property property) async {
    try {
      await _propertiesCollection.add({
        "name": property.name,
        "unitNumber": property.unitNumber,
        "street": property.street,
        "extNumber": property.extNumber,
        "neighborhood": property.neighborhood,
        "borough": property.borough,
        "city": property.city,
        "state": property.state,
        "zipCode": property.zipCode,
        "propertyTaxNumber": property.propertyTaxNumber,
        "ownerId": property.ownerId,
        "status": property.status,
        "ownerName": property.ownerName
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateProperty(Property property) async {
    try {
      await _propertiesCollection.doc(property.id).update(property.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<Property>> fetchProperties() {
    return _propertiesCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Property(
          id: doc.id,
          name: data['name'] ?? '',
          unitNumber: data['unitNumber'] ?? '',
          street: data['street'] ?? '',
          extNumber: data['extNumber'] ?? '',
          intNumber: data['intNumber'], // Puede ser null
          neighborhood: data['neighborhood'] ?? '',
          borough: data['borough'] ?? '',
          city: data['city'] ?? '',
          state: data['state'] ?? '',
          zipCode: data['zipCode'] ?? '',
          propertyTaxNumber: data['propertyTaxNumber'] ?? '',
          ownerId:
              data['ownerId'] ?? '', // Se usa ownerId en lugar de un UserModel
          status: data['status'],
          ownerName: data['ownerName']
        );
      }).toList();
    });
  }
}
