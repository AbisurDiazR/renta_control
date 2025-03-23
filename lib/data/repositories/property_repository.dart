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

  Future<void> updateProperty(String docId, Property property) {
    return _propertiesCollection.doc(docId).set({
      'name': property.name,
      'address': property.address,
      'owner': property.owner.toMap(),
    });
  }

  Stream<List<Property>> fetchProperties() {
    /*try {
      QuerySnapshot querySnapshot = await _propertiesCollection.get();
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Property(
          name: data['name'],
          address: data['address'],
          owner: UserModel(
            id: data['owner']['id'],
            email: data['owner']['email']
          ),
        );
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener las propiedades: $e');
    }*/
    return _propertiesCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Property(
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
