

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renta_control/domain/models/guarantor/guarantor.dart';

class GuarantorRepository {
  final CollectionReference _guarantorsCollection = FirebaseFirestore.instance
      .collection("guarantors");

  // Fetch all guarantors
  Stream<List<Guarantor>> fetchGuarantors(){
    return _guarantorsCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Guarantor.fromMap(doc.data() as Map<String,dynamic>, doc.id);
      }).toList();
    });
  }

  // Add a new guarantor
  Future<void> addGuarantor(Guarantor guarantor) async {
    try {
      await _guarantorsCollection.add(guarantor.toMap());
    } catch (e) {
      throw Exception(e.toString());      
    }
  }

  // Update an existing guarantor
  Future<void> updateGuarantor(Guarantor updatedGuarantor) async {
    try {
      await _guarantorsCollection.doc(updatedGuarantor.id).update(updatedGuarantor.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}