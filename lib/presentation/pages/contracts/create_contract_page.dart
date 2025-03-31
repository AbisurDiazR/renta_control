// ignore_for_file: library_private_types_in_public_api, unused_field, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/domain/models/contract/contract_model.dart';
import 'package:renta_control/domain/models/property/property.dart';
//import 'package:renta_control/domain/models/user_model.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_bloc.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_event.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/blocs/properties/property_state.dart';

class CreateContractPage extends StatefulWidget {
  const CreateContractPage({super.key});

  @override
  _CreateContractPageState createState() => _CreateContractPageState();
}

class _CreateContractPageState extends State<CreateContractPage> {
  final _formKey = GlobalKey<FormState>();
  String? _contractType;
  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = false;
  Property? _selectedProperty;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _contractType = 'Persona Física';
    BlocProvider.of<PropertyBloc>(context).add(FetchProperties());
  }

  void _initializeControllers() {
    final fields = [
      'nombre',
      'rfc',
      'telefono',
      'domicilio',
      'colonia',
      'alcaldia',
      'ciudad',
      'codigoPostal',
      'estado',
      'pais',
      'numeroActa',
      'libro',
      'notario',
      'ciudadNotario',
      'estadoNotario',
    ];

    for (var field in fields) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear contrato')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _contractType,
                onChanged: (String? value) {
                  setState(() {
                    _contractType = value!;
                  });
                },
                items:
                    ['Persona Física', 'Persona Moral']
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
              ),
              _buildPropertyDropdown(),
              ..._buildFormFields(),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _submitContract,
                    child: Text('Guardar contrato'),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    List<Widget> fields = [
      _buildTextField('nombre', 'Nombre'),
      _buildTextField('rfc', 'RFC'),
      _buildTextField('telefono', 'Teléfono'),
      _buildTextField('domicilio', 'Domicilio'),
      _buildTextField('colonia', 'Colonia'),
      _buildTextField('alcaldia', 'Alcaldía o Similar'),
      _buildTextField('ciudad', 'Ciudad'),
      _buildTextField('codigoPostal', 'Código Postal'),
      _buildTextField('estado', 'Estado'),
      _buildTextField('pais', 'País'),
    ];

    if (_contractType == 'Persona Moral') {
      fields.addAll([
        _buildTextField('numeroActa', 'Número de Acta'),
        _buildTextField('libro', 'Libro'),
        _buildTextField('notario', 'Notario'),
        _buildTextField('ciudadNotario', 'Ciudad Notario'),
        _buildTextField('estadoNotario', 'Estado Notario'),
      ]);
    }

    return fields;
  }

  // Listado de propiedades 
  Widget _buildPropertyDropdown(){
    return BlocBuilder<PropertyBloc, PropertyState>(
      builder: (context, state) {
        if (state is PropertyLoading) {
          return Center(child: CircularProgressIndicator(),);
        } else if (state is PropertyLoaded) {
          return DropdownButtonFormField<Property>(
            value: _selectedProperty,
            onChanged: (Property? value) {
              setState(() {
                _selectedProperty = value!;
              });              
            },
            items: state.properties.map((Property property) {
              return DropdownMenuItem(
                value: property,
                child: Text(property.name),
              );
            }).toList(),
            decoration: InputDecoration(labelText: 'Selecciona una propiedad'),
            validator: (value) => value == null ? 'Por favor selecciona una propiedad' : null,
          );
        } else if (state is PropertyError){
          return Text("Error: ${state.message}");
        }
        return SizedBox();
      },
    );
  }

  Widget _buildTextField(String key, String label) {
    return TextFormField(
      controller: _controllers[key],
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Este campo es obligatorio';
        }
        return null;
      },
    );
  }

  // Genera el contrato como texto
  String _generateContractText(Map<String, String> data) {
    return '''
CONTRATO DE ARRENDAMIENTO

Entre las partes:
- Propietario: ${_selectedProperty?.ownerId} (${data['rfc']})
- Teléfono: ${data['telefono']}
- Domicilio: ${data['domicilio']}, ${data['colonia']}, ${data['alcaldia']}, ${data['ciudad']}, C.P. ${data['codigoPostal']}, ${data['estado']}, ${data['pais']}.

El presente contrato se celebra en base a las siguientes cláusulas:

1. El arrendador (${data['nombre']}) acuerda arrendar el inmueble ubicado en ${data['domicilio']} al arrendatario.
2. El contrato tendrá una duración de 12 meses a partir de la firma del documento.
3. El pago mensual acordado es de XXXX pesos, pagaderos los primeros 5 días de cada mes.

${_contractType == 'Persona Moral' ? '''
Información adicional para Persona Moral:
- Número de Acta: ${data['numeroActa']}
- Libro: ${data['libro']}
- Notario: ${data['notario']}
- Ciudad del Notario: ${data['ciudadNotario']}
- Estado del Notario: ${data['estadoNotario']}
''' : ''}

Ambas partes acuerdan los términos de este contrato.
Firma: ________________________
Fecha: ${DateTime.now().toLocal()}
''';
  }

  // Guardar el contrato en Firestore
  Future<void> _saveContractToFirestore(Map<String, String> data) async {
    if (_selectedProperty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecciona una propiedad antes continuar'),)
      );
      return;
    }

    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final contract = Contract(
        property: _selectedProperty!,
        renter: data['nombre']!,
        contractBody: _generateContractText(data),
        ownerEmail: _selectedProperty!.ownerId,
        propertyName: _selectedProperty!.name
      );
      BlocProvider.of<ContractBloc>(
        context,
      ).add(AddContract(contract: contract));
      Navigator.pop(context);
    }
  }

  // Maneja el proceso completo
  Future<void> _submitContract() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Obtener datos del formulario
      final Map<String, String> contractData = {
        for (var key in _controllers.keys) key: _controllers[key]!.text.trim(),
      };

      // Guardar en Firestore
      await _saveContractToFirestore(contractData);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contrato guardado exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar contrato: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
