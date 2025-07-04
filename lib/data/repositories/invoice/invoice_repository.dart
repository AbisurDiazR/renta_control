import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:renta_control/domain/models/invoice/invoice.dart';

class InvoiceRepository {
  final CollectionReference _firestore = FirebaseFirestore.instance.collection('invoices');

  Future<void> addInvoice(Invoice invoice) async {
    try {
      await _firestore.add(invoice.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateInvoice(Invoice invoice) async {
    try {
      await _firestore.doc(invoice.id).update(invoice.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<Invoice>> fetchInvoices(){
    return _firestore.snapshots().map((querySnapshot){
      return querySnapshot.docs.map((doc){
        return Invoice.fromMap(doc.data() as Map<String,dynamic>, doc.id);
      }).toList();
    });
  }
}
