import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renta_control/domain/models/property/property.dart';

class PropertyRepository {
  final CollectionReference _propertiesCollection = FirebaseFirestore.instance
      .collection("properties");

  Future<void> addProperty(Property property) async {
    try {
      await _propertiesCollection.add(property.toMap());
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
        return Property.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> deleteProperty(String propertyId) async {
    try {
      await _propertiesCollection.doc(propertyId).delete();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
