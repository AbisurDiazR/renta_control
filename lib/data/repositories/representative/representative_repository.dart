import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renta_control/domain/models/representative/representative.dart';

class RepresentativeRepository {
  final CollectionReference _representativesCollection = FirebaseFirestore
      .instance
      .collection("representatives");

  Future<void> addRepresentative(Representative representative) async {
    try {
      await _representativesCollection.add(representative.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateRepresentative(Representative representative) async {
    try {
      await _representativesCollection
          .doc(representative.id)
          .update(representative.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<Representative>> fetchRepresentatives() {
    return _representativesCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Representative.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  Future<void> deleteRepresentative(String representativeId) async {
    try {
      await _representativesCollection.doc(representativeId).delete();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
