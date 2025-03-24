import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renta_control/domain/models/property.dart';
import 'package:renta_control/domain/models/user_model.dart';

class PropertyRepository {
  final CollectionReference _propertiesCollection = FirebaseFirestore.instance
      .collection("properties");

  Future<void> addProperty(Property property) {
    return _propertiesCollection.add({
      'name': property.name,
      'address': property.address,
      'owner': property.owner.toMap(),
    });
  }

  Future<void> updateProperty(Property property) async {
    try {
      await _propertiesCollection.doc(property.id).update({
        'name': property.name,
        'address': property.address,
        'owner': property.owner.toMap()
      });
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
          name: data['name'],
          address: data['address'],
          owner: UserModel(
            id: data['owner']['id'],
            email: data['owner']['email'],
          ),
        );
      }).toList();
    });
  }
}
