// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:renta_control/domain/models/property/property.dart';
import 'package:renta_control/domain/models/tenant/tenant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Invoice {
  final String? id; // ID del documento en Firestore
  final String? invoiceNumber; // Número de recibo (puede ser auto-generado)
  final DateTime? issueDate; // Fecha de emisión del recibo
  final DateTime? dueDate; // Fecha de vencimiento del pago
  final DateTime? periodStartDate; // Inicio del período que cubre el recibo
  final DateTime? periodEndDate; // Fin del período que cubre el recibo
  final Property? property; // Propiedad asociada al recibo
  final Tenant? tenant; // Inquilino asociado al recibo
  final double? baseRent; // Monto base del alquiler
  final String?
  additionalChargesDescription; // Descripción de cargos adicionales
  final double? additionalChargesAmount; // Monto de cargos adicionales
  final double? subtotal; // Subtotal antes de impuestos
  final double? ivaRate; // Tasa de IVA (ej. 0.16 para 16%)
  final double? ivaAmount; // Monto de IVA
  final double? totalAmount; // Monto total a pagar
  final String?
  paymentStatus; // Estado del pago (ej. 'Pendiente', 'Pagado', 'Vencido')
  final String? notes; // Notas adicionales
  String? invoiceUrl;

  Invoice({
    this.id,
    this.invoiceNumber,
    this.issueDate,
    this.dueDate,
    this.periodStartDate,
    this.periodEndDate,
    this.property,
    this.tenant,
    this.baseRent,
    this.additionalChargesDescription,
    this.additionalChargesAmount,
    this.subtotal,
    this.ivaRate,
    this.ivaAmount,
    this.totalAmount,
    this.paymentStatus,
    this.notes,
    this.invoiceUrl,
  });

  // Método copyWith para facilitar la creación de nuevas instancias con cambios
  Invoice copyWith({
    String? id,
    String? invoiceNumber,
    DateTime? issueDate,
    DateTime? dueDate,
    DateTime? periodStartDate,
    DateTime? periodEndDate,
    Property? property,
    Tenant? tenant,
    double? baseRent,
    String? additionalChargesDescription,
    double? additionalChargesAmount,
    double? subtotal,
    double? ivaRate,
    double? ivaAmount,
    double? totalAmount,
    String? paymentStatus,
    String? notes,
    String? invoiceUrl,
  }) {
    return Invoice(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      periodStartDate: periodStartDate ?? this.periodStartDate,
      periodEndDate: periodEndDate ?? this.periodEndDate,
      property: property ?? this.property,
      tenant: tenant ?? this.tenant,
      baseRent: baseRent ?? this.baseRent,
      additionalChargesDescription:
          additionalChargesDescription ?? this.additionalChargesDescription,
      additionalChargesAmount:
          additionalChargesAmount ?? this.additionalChargesAmount,
      subtotal: subtotal ?? this.subtotal,
      ivaRate: ivaRate ?? this.ivaRate,
      ivaAmount: ivaAmount ?? this.ivaAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      notes: notes ?? this.notes,
      invoiceUrl: invoiceUrl ?? this.invoiceUrl,
    );
  }

  // Método para convertir el objeto Invoice a un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'invoiceNumber': invoiceNumber,
      'issueDate': issueDate?.toIso8601String(), // Guardar como String ISO 8601
      'dueDate': dueDate?.toIso8601String(),
      'periodStartDate': periodStartDate?.toIso8601String(),
      'periodEndDate': periodEndDate?.toIso8601String(),
      'property': property?.toMap(), // Guardar el mapa de la propiedad
      'tenant': tenant?.toMap(), // Guardar el mapa del inquilino
      'baseRent': baseRent,
      'additionalChargesDescription': additionalChargesDescription,
      'additionalChargesAmount': additionalChargesAmount,
      'subtotal': subtotal,
      'ivaRate': ivaRate,
      'ivaAmount': ivaAmount,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      'notes': notes,
      'invoiceUrl': invoiceUrl,
    };
  }

  // Factory para crear un objeto Invoice desde un mapa de Firestore
  factory Invoice.fromMap(Map<String, dynamic> map, String docId) {
    DateTime? _parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return null;
        }
      } else if (value is Timestamp) {
        // Si Firestore guarda como Timestamp
        return value.toDate();
      }
      return null;
    }

    T? _parseNestedModel<T>(
      dynamic data,
      T Function(Map<String, dynamic>, String?) fromMapFunction,
    ) {
      if (data is Map<String, dynamic>) {
        String? nestedId = data['id'] as String?;
        return fromMapFunction(data, nestedId);
      }
      return null;
    }

    return Invoice(
      id: docId,
      invoiceNumber: map['invoiceNumber'] as String?,
      issueDate: _parseDateTime(map['issueDate']),
      dueDate: _parseDateTime(map['dueDate']),
      periodStartDate: _parseDateTime(map['periodStartDate']),
      periodEndDate: _parseDateTime(map['periodEndDate']),
      property: _parseNestedModel<Property>(
        map['property'],
        (data, nestedId) => Property.fromMap(data, nestedId ?? ''),
      ),
      tenant: _parseNestedModel<Tenant>(
        map['tenant'],
        (data, nestedId) => Tenant.fromMap(data, nestedId ?? ''),
      ),
      baseRent: (map['baseRent'] as num?)?.toDouble(), // Convertir a double
      additionalChargesDescription:
          map['additionalChargesDescription'] as String?,
      additionalChargesAmount:
          (map['additionalChargesAmount'] as num?)?.toDouble(),
      subtotal: (map['subtotal'] as num?)?.toDouble(),
      ivaRate: (map['ivaRate'] as num?)?.toDouble(),
      ivaAmount: (map['ivaAmount'] as num?)?.toDouble(),
      totalAmount: (map['totalAmount'] as num?)?.toDouble(),
      paymentStatus: map['paymentStatus'] as String?,
      notes: map['notes'] as String?,
      invoiceUrl: map['invoiceUrl'] as String?,
    );
  }
}
