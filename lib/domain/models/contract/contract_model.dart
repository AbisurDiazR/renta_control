// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:intl/intl.dart';
import 'package:renta_control/domain/models/guarantor/guarantor.dart';
import 'package:renta_control/domain/models/property/property.dart';
import 'package:renta_control/domain/models/tenant/tenant.dart';

class Contract {
  final String? id;
  final String? contractCreatorFullName;
  final String? contractCreatorRFC;
  final DateTime? contractStartDate;
  final DateTime? contractEndDate;
  final DateTime? contractCreationDate;
  final String? rentalCost;
  final String? rentalCostText;
  final String? firstRentalMonths;
  final String? lastRentalMonths;
  final String? guarantDeposite;
  final String? guarantDepositeText;
  final DateTime? deadlineDate;
  final String? materialSituation;
  final String? parkingPlaces;
  final String? useProperty;
  final String? denomination;
  final String? contractUrl;
  final Property? property;
  final Tenant? tenant;
  final Guarantor? guarantor;

  Contract({
    this.id,
    this.contractCreatorFullName,
    this.contractCreatorRFC,
    this.contractStartDate,
    this.contractEndDate,
    this.contractCreationDate,
    this.rentalCost,
    this.rentalCostText,
    this.firstRentalMonths,
    this.lastRentalMonths,
    this.guarantDeposite,
    this.guarantDepositeText,
    this.deadlineDate,
    this.materialSituation,
    this.parkingPlaces,
    this.useProperty,
    this.denomination,
    this.contractUrl,
    this.property,
    this.tenant,
    this.guarantor,
  });

  Contract copyWith({
    String? id,
    String? contractCreatorFullName,
    String? contractCreatorRFC,
    DateTime? contractStartDate,
    DateTime? contractEndDate,
    DateTime? contractCreationDate,
    String? rentalCost,
    String? rentalCostText,
    String? firstRentalMonths,
    String? lastRentalMonths,
    String? guarantDeposite,
    String? guarantDepositeText,
    DateTime? deadlineDate,
    String? materialSituation,
    String? parkingPlaces,
    String? useProperty,
    String? denomination,
    String? ownerContract,
    String? contractUrl,
    Property? property,
    Tenant? tenant,
    Guarantor? guarantor,
  }) {
    return Contract(
      id: id ?? this.id,
      contractCreatorFullName:
          contractCreatorFullName ?? this.contractCreatorFullName,
      contractCreatorRFC: contractCreatorRFC ?? this.contractCreatorRFC,
      contractStartDate: contractStartDate ?? this.contractStartDate,
      contractEndDate: contractEndDate ?? this.contractEndDate,
      contractCreationDate: contractCreationDate ?? this.contractCreationDate,
      rentalCost: rentalCost ?? this.rentalCost,
      rentalCostText: rentalCostText ?? this.rentalCostText,
      firstRentalMonths: firstRentalMonths ?? this.firstRentalMonths,
      lastRentalMonths: lastRentalMonths ?? this.lastRentalMonths,
      guarantDeposite: guarantDeposite ?? this.guarantDeposite,
      guarantDepositeText: guarantDepositeText ?? this.guarantDepositeText,
      deadlineDate: deadlineDate ?? this.deadlineDate,
      materialSituation: materialSituation ?? this.materialSituation,
      parkingPlaces: parkingPlaces ?? this.parkingPlaces,
      useProperty: useProperty ?? this.useProperty,
      denomination: denomination ?? this.denomination,
      contractUrl: contractUrl ?? this.contractUrl,
      property: property ?? this.property,
      tenant: tenant ?? this.tenant,
      guarantor: guarantor ?? this.guarantor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contractCreatorFullName': contractCreatorFullName,
      'contractCreatorRFC': contractCreatorRFC,
      'contractStartDate': contractStartDate?.toIso8601String(),
      'contractEndDate': contractEndDate?.toIso8601String(),
      'contractCreationDate': contractCreationDate?.toIso8601String(),
      'rentalCost': rentalCost,
      'rentalCostText': rentalCostText,
      'firstRentalMonths': firstRentalMonths,
      'lastRentalMonths': lastRentalMonths,
      'guarantDeposite': guarantDeposite,
      'guarantDepositeText': guarantDepositeText,
      'deadlineDate': deadlineDate,
      'materialSituation': materialSituation,
      'parkingPlaces': parkingPlaces,
      'useProperty': useProperty,
      'denomination': denomination,
      'contractUrl': contractUrl,
      'property': property?.toMap(),
      'tenant': tenant?.toMap(),
      'guarantor': guarantor?.toMap(),
    };
  }

  factory Contract.fromMap(Map<String, dynamic> map, String docId) {
    // Función auxiliar para parsear fechas de diferentes formatos de Firestore    
    DateTime? _parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          // Log or handle parsing error if needed
          return null;
        }
      } else if (value is Timestamp) {
        return value.toDate();
      }
      return null;
    }

    // Función auxiliar para parsear sub-mapas de modelos anidados
    // Esto es crucial para manejar la nulidad de forma segura y evitar el 'as Map<String, dynamic>'
    T? _parseNestedModel<T>(
      dynamic data,
      T Function(Map<String, dynamic>, String?) fromMapFunction,
    ) {
      if (data is Map<String, dynamic>) {
        // Asumiendo que el ID del sub-documento (si existe) está dentro de su propio mapa.
        // Si no tienen un 'id' dentro de su mapa, puedes pasar null o una cadena vacía al fromMapFunction.
        String? nestedId = data['id'] as String?;
        return fromMapFunction(data, nestedId);
      }
      return null;
    }

    return Contract(
      id: docId, // El ID del documento de Firestore para este contrato
      contractCreatorFullName: map['contractCreatorFullName'] as String?,
      contractCreatorRFC: map['contractCreatorRFC'] as String?,
      contractStartDate: _parseDateTime(map['contractStartDate']),
      contractEndDate: _parseDateTime(map['contractEndDate']),
      contractCreationDate: _parseDateTime(map['contractCreationDate']),
      rentalCost: map['rentalCost'] as String?,
      rentalCostText: map['rentalCostText'] as String?,
      firstRentalMonths: map['firstRentalMonths'] as String?,
      lastRentalMonths: map['lastRentalMonths'] as String?,
      guarantDeposite: map['guarantDeposite'] as String?,
      guarantDepositeText: map['guarantDepositeText'] as String?,
      // deadlineDate puede ser un Timestamp o un String en Firestore, pero el modelo espera DateTime?.
      deadlineDate: map['deadlineDate'] != null
          ? (map['deadlineDate'] is Timestamp
              ? (map['deadlineDate'] as Timestamp).toDate()
              : (map['deadlineDate'] is String
                  ? DateTime.tryParse(map['deadlineDate'] as String)
                  : null))
          : null,
      materialSituation: map['materialSituation'] as String?,
      parkingPlaces: map['parkingPlaces'] as String?,
      useProperty: map['useProperty'] as String?,
      denomination: map['denomination'] as String?,
      contractUrl: map['contractUrl'] as String?,

      // === MANEJO DE OBJETOS ANIDADOS ===
      // Aquí usamos la función auxiliar _parseNestedModel para mayor seguridad
      // y para pasar el ID correcto a los fromMap de los sub-modelos.

      // IMPORTANTE: En tu Firestore JSON, 'property' contiene los datos de la propiedad,
      // NO 'owner'. Debes cambiar 'map['owner']' a 'map['property']'.
      property: _parseNestedModel<Property>(
        map['property'], // <-- CORREGIDO: Usar 'property'
        (data, nestedId) => Property.fromMap(
          data,
          nestedId ?? '',
        ), // Pasa el ID del sub-documento (o '')
      ),
      tenant: _parseNestedModel<Tenant>(
        map['tenant'],
        (data, nestedId) => Tenant.fromMap(
          data,
          nestedId ?? '',
        ), // Pasa el ID del sub-documento (o '')
      ),
      guarantor: _parseNestedModel<Guarantor>(
        map['guarantor'],
        (data, nestedId) => Guarantor.fromMap(
          data,
          nestedId ?? '',
        ), // Pasa el ID del sub-documento (o '')
      ),
    );
  }
}
