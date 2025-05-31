// ignore_for_file: library_private_types_in_public_api, unused_field

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/domain/models/representative/representative.dart';
import 'package:renta_control/presentation/blocs/representative/representative_bloc.dart';
import 'package:renta_control/presentation/blocs/representative/representative_event.dart';

class AddRepresentativePage extends StatefulWidget {
  final Representative? representative;

  const AddRepresentativePage({super.key, this.representative});

  @override
  _AddRepresentativePageState createState() => _AddRepresentativePageState();
}

class _AddRepresentativePageState extends State<AddRepresentativePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final List<String> _documentTypes = [
    'INE',
    'Pasaporte',
    'Cédula Profesional',
  ];
  String? _selectedDocumentType;
  Representative? _representative;

  @override
  void initState() {
    super.initState();
    _representative = widget.representative;
    _initializeControllers();
  }

  void _initializeControllers() {
    final fields = [
      'fullName',
      'documentType',
      'documentNumber',
      'street',
      'extNumber',
      'intNumber',
      'neighborhood',
      'borough',
      'city',
      'state',
      'zipCode',
      'phoneNumber',
      'email',
      'rfc',
      'curp',
    ];

    for (var field in fields) {
      _controllers[field] = TextEditingController();
    }

    if (widget.representative != null) {
      _controllers['fullName']?.text = widget.representative!.fullName;
      _selectedDocumentType =
          widget
              .representative!
              .documentType; // Assign to your dropdown variable
      _controllers['documentNumber']?.text =
          widget.representative!.documentNumber;
      _controllers['street']?.text = widget.representative!.street;
      _controllers['extNumber']?.text = widget.representative!.extNumber;
      _controllers['intNumber']?.text = widget.representative!.intNumber ?? '';
      _controllers['neighborhood']?.text = widget.representative!.neighborhood;
      _controllers['borough']?.text = widget.representative!.borough;
      _controllers['city']?.text = widget.representative!.city;
      _controllers['state']?.text = widget.representative!.state;
      _controllers['zipCode']?.text = widget.representative!.zipCode;
      _controllers['phoneNumber']?.text = widget.representative!.phoneNumber;
      _controllers['email']?.text = widget.representative!.email;
      _controllers['rfc']?.text = widget.representative!.rfc ?? '';
      _controllers['curp']?.text = widget.representative!.curp ?? '';
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar representante')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var field in _controllers.keys)
                  _buildTextField(field, isRequired: _isFieldRequired(field)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    _representative != null
                        ? "Guardar representate"
                        : "Actualizar representate",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String field, {bool isRequired = false}) {
    // Determine the label text for the field
    String labelText = _getLabelText(field);

    if (field == 'documentType') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
          value: _selectedDocumentType,
          onChanged: (String? newValue) {
            setState(() {
              _selectedDocumentType = newValue;
            });
          },
          items:
              _documentTypes.map((type) {
                return DropdownMenuItem<String>(value: type, child: Text(type));
              }).toList(),
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'Este campo es obligatorio';
            }
            return null;
          },
        ),
      );
    }

    TextInputType inputType = TextInputType.text;
    List<TextInputFormatter> inputFormatters = [];
    String? Function(String?)? validator;

    // Define input type and formatters based on the field
    if (field == 'phoneNumber') {
      // Changed from 'phone' to 'phoneNumber'
      inputType = TextInputType.phone;
      inputFormatters = [FilteringTextInputFormatter.digitsOnly];
      validator = (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Este campo es obligatorio';
        }
        if (value != null && value.isNotEmpty && value.length < 10) {
          return 'El número de teléfono debe tener al menos 10 dígitos';
        }
        return null;
      };
    } else if (field == 'zipCode') {
      inputType = TextInputType.number;
      inputFormatters = [FilteringTextInputFormatter.digitsOnly];
      validator = (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Este campo es obligatorio';
        }
        if (value != null && value.isNotEmpty && value.length != 5) {
          return 'El código postal debe tener 5 dígitos';
        }
        return null;
      };
    } else if (field == 'email') {
      inputType = TextInputType.emailAddress;
      validator = (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Este campo es obligatorio';
        }
        if (value != null && value.isNotEmpty && !value.contains('@')) {
          return 'Ingresa un correo electrónico válido';
        }
        return null;
      };
    } else if (field == 'documentNumber') {
      // You might want to add specific validation for document numbers based on document type
      validator = (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Este campo es obligatorio';
        }
        // Example: if documentType is INE, documentNumber must be 10 digits
        if (_selectedDocumentType == 'INE' &&
            (value?.length != 10 && value!.isNotEmpty)) {
          return 'El número de INE debe tener 10 dígitos';
        }
        return null;
      };
    } else if (field == 'rfc') {
      validator = (value) {
        if (value != null && value.isNotEmpty && value.length != 13) {
          return 'El RFC debe tener 13 caracteres';
        }
        return null;
      };
    } else if (field == 'curp') {
      validator = (value) {
        if (value != null && value.isNotEmpty && value.length != 18) {
          return 'El CURP debe tener 18 caracteres';
        }
        return null;
      };
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers[field],
        keyboardType: inputType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        validator:
            validator ??
            (value) {
              // Use the specific validator or a generic one
              if (isRequired && (value == null || value.isEmpty)) {
                return 'Este campo es obligatorio';
              }
              return null;
            },
      ),
    );
  }

  bool _isFieldRequired(String field) {
    const optionalFields = ['intNumber', 'rfc', 'curp'];
    return !optionalFields.contains(field);
  }

  String _getLabelText(String field) {
    final labels = {
      'fullName': 'Nombre Completo',
      'documentType': 'Tipo de Documento',
      'documentNumber': 'Número de Documento',
      'street': 'Calle',
      'extNumber': 'Número Exterior',
      'intNumber': 'Número Interior',
      'neighborhood': 'Colonia',
      'borough': 'Alcaldía/Municipio',
      'city': 'Ciudad',
      'state': 'Estado',
      'zipCode': 'Código Postal',
      'phoneNumber': 'Teléfono',
      'email': 'Correo Electrónico',
      'rfc': 'RFC',
      'curp': 'CURP',
    };
    return labels[field] ?? field;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newRepresentative = Representative(
        fullName: _controllers['fullName']!.text,
        documentType: _selectedDocumentType ?? 'INE',
        documentNumber: _controllers['documentNumber']!.text,
        street: _controllers["street"]!.text,
        extNumber: _controllers["extNumber"]!.text,
        neighborhood: _controllers["neighborhood"]!.text,
        borough: _controllers["borough"]!.text,
        city: _controllers["city"]!.text,
        state: _controllers["state"]!.text,
        zipCode: _controllers["zipCode"]!.text,
        phoneNumber: _controllers["phoneNumber"]!.text,
        email: _controllers["email"]!.text,
        rfc: _controllers["rfc"]!.text,
        curp: _controllers["curp"]!.text,
      );

      BlocProvider.of<RepresentativeBloc>(context).add(
        _representative == null
            ? AddRepresentative(representative: newRepresentative)
            : UpdateRepresentative(
              representative: newRepresentative.copyWith(
                id: _representative?.id,
              ),
            ),
      );

      Navigator.pop(context, newRepresentative);
    }
  }
}
