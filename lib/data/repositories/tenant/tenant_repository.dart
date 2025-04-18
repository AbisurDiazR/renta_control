import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renta_control/domain/models/tenant/tenant.dart';

class TenantRepository {
  final CollectionReference _tenantsCollection = FirebaseFirestore.instance
      .collection("tenants");

  Future<void> addTenant(Tenant tenant) async {
    try {
      /*await _tenantsCollection.add({
        "fullName": tenant.fullName,
        "email": tenant.email,
        "phone": tenant.phone,
        "documentType": tenant.documentType,
        "documentNumber": tenant.documentNumber,
        "occupation": tenant.occupation,
        "monthlyIncome": tenant.monthlyIncome,
        "street": tenant.street,
        "extNumber": tenant.extNumber,
        "neighborhood": tenant.neighborhood,
        "borough": tenant.borough,
        "city": tenant.city,
        "state": tenant.state,
        "zipCode": tenant.zipCode,
      });*/
      await _tenantsCollection.add(tenant.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateTenant(Tenant tenant) async {
    try {
      await _tenantsCollection.doc(tenant.id).update(tenant.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<Tenant>> fetchTenants(){
    return _tenantsCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Tenant.fromMap(doc.data() as Map<String,dynamic>, doc.id);
      }).toList();
    });
  }
}
