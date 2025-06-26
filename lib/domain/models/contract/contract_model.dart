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
  final String? deadlineDate;
  final String? materialSituation;
  final String? parkingPlaces;
  final String? useProperty;
  final String? denomination;
  final String? ownerEmail;
  final String? contractUrl;

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
    this.ownerEmail,
    this.contractUrl,
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
    String? deadlineDate,
    String? materialSituation,
    String? parkingPlaces,
    String? useProperty,
    String? denomination,
    String? ownerEmail,
    String? contractUrl,
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
      ownerEmail: ownerEmail ?? this.ownerEmail,
      contractUrl: contractUrl ?? this.contractUrl,
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
      'ownerEmail': ownerEmail,
      'contractUrl': contractUrl,
    };
  }

  factory Contract.fromMap(Map<String, dynamic> map, String docId) {
    return Contract(
      id: docId,
      contractCreatorFullName: map['contractCreatorFullName'],
      contractCreatorRFC: map['contractCreatorRFC'],
      contractStartDate:
          map['contractStartDate'] != null
              ? DateTime.parse(map['contractStartDate'])
              : null,
      contractEndDate:
          map['contractEndDate'] != null
              ? DateTime.parse(map['contractEndDate'])
              : null,
      contractCreationDate:
          map['contractCreationDate'] != null
              ? DateTime.parse(map['contractCreationDate'])
              : null,
      rentalCost: map['rentalCost'],
      rentalCostText: map['rentalCostText'],
      firstRentalMonths: map['firstRentalMonths'],
      lastRentalMonths: map['lastRentalMonths'],
      guarantDeposite: map['guarantDeposite'],
      guarantDepositeText: map['guarantDepositeText'],
      deadlineDate: map['deadlineDate'],
      materialSituation: map['materialSituation'],
      parkingPlaces: map['parkingPlaces'],
      useProperty: map['useProperty'],
      denomination: map['denomination'],
      ownerEmail: map['ownerEmail'],
      contractUrl: map['contractUrl'],
    );
  }
}
