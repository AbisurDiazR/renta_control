import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renta_control/domain/models/contract/contract_model.dart';

class ContractRepository {
  final CollectionReference _contractsCollection = FirebaseFirestore.instance
      .collection("contracts");

  Future<void> addContract(Contract contract) async {
    try {
      await _contractsCollection.add(contract.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<Contract>> fetchContracts() {
    return _contractsCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Contract.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
