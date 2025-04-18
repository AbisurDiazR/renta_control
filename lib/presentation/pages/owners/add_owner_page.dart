// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/domain/models/owner/owner_model.dart';
import 'package:renta_control/presentation/blocs/owners/owner_bloc.dart';
import 'package:renta_control/presentation/blocs/owners/owner_event.dart';

class AddOwnerPage extends StatefulWidget {
  final OwnerModel? owner;
  const AddOwnerPage({super.key, this.owner});

  @override
  _AddOwnerPageState createState() => _AddOwnerPageState();
}

class _AddOwnerPageState extends State<AddOwnerPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final fields = [
      'name',
      'email',
      'phone',
      'street',
      'extNumber',
      'intNumber',
      'neighborhood',
      'borough',
      'city',
      'state',
      'zipCode',
    ];

    for (var field in fields) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Propietario")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var field in _controllers.keys)
                  _buildTextField(field, isRequired: field != 'intNumber'),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Guardar Propietario"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String field, {required bool isRequired}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers[field],
        decoration: InputDecoration(
          labelText: _getLabelText(field),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }

  String _getLabelText(String field) {
    final labels = {
      'name': 'Nombre Completo',
      'email': 'Correo Electrónico',
      'phone': 'Teléfono',
      'street': 'Calle',
      'extNumber': 'Número Exterior',
      'intNumber': 'Número Interior (Opcional)',
      'neighborhood': 'Colonia',
      'borough': 'Alcaldía',
      'city': 'Ciudad',
      'state': 'Estado',
      'zipCode': 'Código Postal',
    };
    return labels[field] ?? field;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newOwner = OwnerModel(
        id: '', // Firestore asignará el ID automáticamente
        name: _controllers['name']!.text,
        email: _controllers['email']!.text,
        phone: _controllers['phone']!.text,
        street: _controllers['street']!.text,
        extNumber: _controllers['extNumber']!.text,
        intNumber: _controllers['intNumber']!.text.isNotEmpty
            ? _controllers['intNumber']!.text
            : null,
        neighborhood: _controllers['neighborhood']!.text,
        borough: _controllers['borough']!.text,
        city: _controllers['city']!.text,
        state: _controllers['state']!.text,
        zipCode: _controllers['zipCode']!.text,
      );

      // Enviar evento para agregar propietario
      BlocProvider.of<OwnerBloc>(context).add(AddOwner(owner: newOwner));

      // Cerrar la pantalla después de guardar
      Navigator.pop(context);
    }
  }
}
