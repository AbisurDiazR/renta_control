import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renta_control/domain/models/contract_model.dart';

class ContractRepository {
  final CollectionReference _contractsCollection = FirebaseFirestore.instance.collection("contracts");

  Future<void> addContract(Contract contract){
    return _contractsCollection.add(contract);
  }
}