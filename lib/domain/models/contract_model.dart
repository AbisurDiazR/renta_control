class Contract {
  final String id;
  final String owner; // ID del usuario que creó el contrato
  final String contractType; // "Persona Física" o "Persona Moral"
  final String nombre;
  final String rfc;
  final String telefono;
  final String domicilio;
  final String colonia;
  final String alcaldia;
  final String ciudad;
  final String codigoPostal;
  final String estado;
  final String pais;

  // Datos adicionales solo para persona moral
  final String? numeroActa;
  final String? libro;
  final String? notario;
  final String? ciudadNotario;
  final String? estadoNotario;

  Contract({
    required this.id,
    required this.owner,
    required this.contractType,
    required this.nombre,
    required this.rfc,
    required this.telefono,
    required this.domicilio,
    required this.colonia,
    required this.alcaldia,
    required this.ciudad,
    required this.codigoPostal,
    required this.estado,
    required this.pais,
    this.numeroActa,
    this.libro,
    this.notario,
    this.ciudadNotario,
    this.estadoNotario,
  });

  /// Convierte un `Map` a un objeto `Contract`
  factory Contract.fromMap(String id, Map<String, dynamic> data) {
    return Contract(
      id: id,
      owner: data['owner'] ?? '',
      contractType: data['contractType'] ?? 'Persona Física',
      nombre: data['nombre'] ?? '',
      rfc: data['rfc'] ?? '',
      telefono: data['telefono'] ?? '',
      domicilio: data['domicilio'] ?? '',
      colonia: data['colonia'] ?? '',
      alcaldia: data['alcaldia'] ?? '',
      ciudad: data['ciudad'] ?? '',
      codigoPostal: data['codigoPostal'] ?? '',
      estado: data['estado'] ?? '',
      pais: data['pais'] ?? '',
      numeroActa: data['numeroActa'],
      libro: data['libro'],
      notario: data['notario'],
      ciudadNotario: data['ciudadNotario'],
      estadoNotario: data['estadoNotario'],
    );
  }

  /// Convierte un objeto `Contract` a un `Map`
  Map<String, dynamic> toMap() {
    return {
      'owner': owner,
      'contractType': contractType,
      'nombre': nombre,
      'rfc': rfc,
      'telefono': telefono,
      'domicilio': domicilio,
      'colonia': colonia,
      'alcaldia': alcaldia,
      'ciudad': ciudad,
      'codigoPostal': codigoPostal,
      'estado': estado,
      'pais': pais,
      if (contractType == 'Persona Moral') ...{
        'numeroActa': numeroActa,
        'libro': libro,
        'notario': notario,
        'ciudadNotario': ciudadNotario,
        'estadoNotario': estadoNotario,
      },
    };
  }
}
