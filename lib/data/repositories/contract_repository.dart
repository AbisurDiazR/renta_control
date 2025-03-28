import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renta_control/domain/models/contract_model.dart';

class ContractRepository {
  final CollectionReference _contractsCollection = FirebaseFirestore.instance
      .collection("contracts");

  Future<void> addContract(Contract contract) async {
    try {
      await _contractsCollection.add({
        "property": contract.property!.toMap(),
        "renter": contract.renter,
        "contractBody": contract.contractBody,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<Contract>> fetchContracts() {
    return _contractsCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Contract(
          id: doc.id,
          renter: data['renter'],
          contractBody: data['contractBody'],
          ownerEmail: data['ownerEmail'],
          propertyName: data['propertyName']
        );
      }).toList();
    });
  }
}
