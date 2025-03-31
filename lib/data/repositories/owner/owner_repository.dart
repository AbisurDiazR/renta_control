import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renta_control/domain/models/owner/owner_model.dart';

class OwnerRepository {
  final CollectionReference _ownersCollection = FirebaseFirestore.instance
      .collection("owners");

  Future<void> addOwner(OwnerModel owner) async {
    try {
      await _ownersCollection.add(owner);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateOwner(OwnerModel owner) async {
    try {
      await _ownersCollection.doc(owner.id).update(owner.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<OwnerModel>> fetchOwners() {
    return _ownersCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return OwnerModel(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          phone: data['phone'],
          street: data['street'],
          extNumber: data['extNumber'],
          neighborhood: data['neighborhood'],
          borough: data['borough'],
          city: data['city'],
          state: data['state'],
          zipCode: data['zipCode'],
        );
      }).toList();
    });
  }
}
