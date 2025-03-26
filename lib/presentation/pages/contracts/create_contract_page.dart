// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_bloc.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_state.dart';

class CreateContractPage extends StatefulWidget {
  const CreateContractPage({super.key});

  @override
  _CreateContractPageState createState() => _CreateContractPageState();
}

class _CreateContractPageState extends State<CreateContractPage> {
  final _formKey = GlobalKey<FormState>();
  String _contractType = 'Persona Fisica';
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
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
      appBar: AppBar(title: Text('Crear Contrato')),
      body: BlocConsumer<ContractBloc, ContractState>(
        listener: (context, state) {
          if (state is ContractAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Contrato creado con exito')),
            );
            Navigator.pop(context);
          } else if (state is ContractError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  DropdownButtonFormField<String>(
                    value: _contractType,
                    onChanged: (value) {
                      setState(() {
                        _contractType = value!;
                      });
                    },
                    items:
                        ['Persona Física', 'Persona Moral']
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                    decoration: InputDecoration(labelText: 'Tipo de Contrato'),
                  ),
                  ..._buildFormFields(),
                  SizedBox(height: 20),
                  state is ContractLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                        onPressed: _submitContract,
                        child: Text('Guardar Contrato'),
                      ),
                ],
              ),
            ),
          );
        },
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

  _submitContract() {}
}
