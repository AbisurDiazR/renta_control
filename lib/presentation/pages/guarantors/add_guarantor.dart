// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/domain/models/guarantor/guarantor.dart';
import 'package:renta_control/presentation/blocs/guarantor/guarantor_bloc.dart';
import 'package:renta_control/presentation/blocs/guarantor/guarantor_event.dart';

class AddGuarantorPage extends StatefulWidget {
  final Guarantor? guarantor;
  const AddGuarantorPage({super.key, this.guarantor});

  @override
  _AddGuarantorPageState createState() => _AddGuarantorPageState();
}

class _AddGuarantorPageState extends State<AddGuarantorPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final List<String> _documentTypes = [
    'INE',
    'Pasaporte',
    'Cédula Profesional',
  ];
  String? _selectedDocumentType;
  Guarantor? _guarantor;

  @override
  void initState() {
    super.initState();
    _guarantor = widget.guarantor;
    _initializeControllers();
  }

  void _initializeControllers() {
    final fields = [
      'fullName',
      'phone',
      'email',
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
      'occupation',
      'monthlyIncome',
      'employer',
    ];

    for (var field in fields) {
      _controllers[field] = TextEditingController();
    }

    if (_guarantor != null) {
      _controllers['fullName']?.text = _guarantor!.fullName;
      _controllers['email']?.text = _guarantor!.email;
      _controllers['phone']?.text = _guarantor!.phoneNumber;
      _selectedDocumentType = _guarantor!.documentType;
      _controllers['documentNumber']?.text = _guarantor!.documentNumber;
      _controllers['street']?.text = _guarantor!.street;
      _controllers['extNumber']?.text = _guarantor!.extNumber;
      _controllers['intNumber']?.text = _guarantor!.intNumber ?? '';
      _controllers['neighborhood']?.text = _guarantor!.neighborhood;
      _controllers['borough']?.text = _guarantor!.borough;
      _controllers['city']?.text = _guarantor!.city;
      _controllers['state']?.text = _guarantor!.state;
      _controllers['zipCode']?.text = _guarantor!.zipCode;
      _controllers['occupation']?.text = _guarantor!.occupation;
      _controllers['monthlyIncome']?.text =
          _guarantor!.monthlyIncome.toString();
      _controllers['employer']?.text = _guarantor!.employer;
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
      appBar: AppBar(title: const Text('Agregar Fiador')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var field in _controllers.keys)
                  _buildTextField(field, isRequired: _isFieldRequired(field)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    _guarantor == null ? "Guardar Fiador" : "Actualizar Fiador",
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
    if (field == 'documentType') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: _getLabelText(field),
            border: OutlineInputBorder(),
          ),
          value: _selectedDocumentType,
          onChanged: (String? newValue) {
            setState(() {
              _selectedDocumentType = newValue!;
            });
          },
          items:
              _documentTypes.map((type) {
                return DropdownMenuItem<String>(value: type, child: Text(type));
              }).toList(),
          validator:
              (value) => value == null ? 'Este campo es obligatorio' : null,
        ),
      );
    }
    TextInputType inputType = TextInputType.text;
    List<TextInputFormatter> inputFormatters = [];
    if (field == 'monthlyIncome') {
      inputType = TextInputType.number;
      inputFormatters = [FilteringTextInputFormatter.digitsOnly];
    } else if (field == 'phone') {
      inputType = TextInputType.phone;
      inputFormatters = [FilteringTextInputFormatter.digitsOnly];
    } else if (field == 'zipCode') {
      inputType = TextInputType.number;
      inputFormatters = [FilteringTextInputFormatter.digitsOnly];
    } else if (field == 'email') {
      inputType = TextInputType.emailAddress;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers[field],
        keyboardType: inputType,
        inputFormatters: inputFormatters,
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

  bool _isFieldRequired(String field) {
    const optionalFields = ['intNumber', 'employer', 'notes'];
    return !optionalFields.contains(field);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newGuarantor = Guarantor(
        fullName: _controllers['fullName']!.text,
        email: _controllers['email']!.text,
        phoneNumber: _controllers['phone']!.text,
        documentType: _selectedDocumentType ?? 'INE',
        documentNumber: _controllers['documentNumber']!.text,
        occupation: _controllers['occupation']!.text,
        monthlyIncome:
            double.tryParse(_controllers['monthlyIncome']!.text) ?? 0.0,
        employer: _controllers['employer']!.text,
        street: _controllers['street']!.text,
        extNumber: _controllers['extNumber']!.text,
        intNumber:
            _controllers['intNumber']!.text.isNotEmpty
                ? _controllers['intNumber']!.text
                : null,
        neighborhood: _controllers['neighborhood']!.text,
        borough: _controllers['borough']!.text,
        city: _controllers['city']!.text,
        state: _controllers['state']!.text,
        zipCode: _controllers['zipCode']!.text,
      );
      BlocProvider.of<GuarantorBloc>(context).add(
        _guarantor == null
            ? AddGuarantor(guarantor: newGuarantor)
            : UpdateGuarantor(
              guarantor: newGuarantor.copyWith(id: _guarantor!.id),
            ),
      );
      Navigator.pop(context, newGuarantor);
    }
  }

  String _getLabelText(String field) {
    final labels = {
      'fullName': 'Nombre Completo',
      'email': 'Correo Electrónico',
      'phone': 'Teléfono',
      'documentType': 'Tipo de Documento',
      'documentNumber': 'Número de Documento',
      'occupation': 'Ocupación',
      'monthlyIncome': 'Ingreso Mensual',
      'employer': 'Empleador',
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
}
