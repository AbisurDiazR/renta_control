// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/domain/models/tenant/tenant.dart';
import 'package:renta_control/presentation/blocs/tenant/tenant_bloc.dart';
import 'package:renta_control/presentation/blocs/tenant/tenant_event.dart';

class AddTenantPage extends StatefulWidget {
  final Tenant? tenant;
  const AddTenantPage({super.key, this.tenant});

  @override
  _AddTenantPageState createState() => _AddTenantPageState();
}

class _AddTenantPageState extends State<AddTenantPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final List<String> _documentTypes = [
    'INE',
    'Pasaporte',
    'Cédula Profesional',
  ];
  String? _selectedDocumentType;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final fields = [
      'fullName',
      'email',
      'phone',
      'documentType',
      'documentNumber',
      'occupation',
      'monthlyIncome',
      'employer',
      'street',
      'extNumber',
      'intNumber',
      'neighborhood',
      'borough',
      'city',
      'state',
      'zipCode',
      'notes',
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
      appBar: AppBar(title: const Text("Agregar Inquilino")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  child: const Text("Guardar Inquilino"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String field, {required bool isRequired}) {
    if (field == 'documentType') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Tipo de documento',
            border: OutlineInputBorder(),
          ),
          value: _selectedDocumentType,
          onChanged: (String? value) {
            setState(() {
              _selectedDocumentType = value!;
            });
          },
          items:
              _documentTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
          validator:
              (value) =>
                  value == null
                      ? 'Por favor seleccione un tipo de documento'
                      : null,
        ),
      );
    }
    TextInputType keyboardType = TextInputType.text;
    List<TextInputFormatter>? inputFormatters;

    if (field == 'phone' || field == 'zipCode') {
      keyboardType = TextInputType.number;
    } else if (field == 'email') {
      keyboardType = TextInputType.emailAddress;
    } else if (field == 'monthlyIncome') {
      keyboardType = TextInputType.numberWithOptions(decimal: true);
      inputFormatters = [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ];
    }
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
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
      ),
    );
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
      'notes': 'Notas (Opcional)',
    };
    return labels[field] ?? field;
  }

  bool _isFieldRequired(String field) {
    const optionalFields = ['intNumber', 'employer', 'notes'];
    return !optionalFields.contains(field);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newTenant = Tenant(
        id: '', // Firestore asignará el ID automáticamente
        fullName: _controllers['fullName']!.text,
        email: _controllers['email']!.text,
        phone: _controllers['phone']!.text,
        documentType: _selectedDocumentType!,
        documentNumber: _controllers['documentNumber']!.text,
        occupation: _controllers['occupation']!.text,
        monthlyIncome:
            double.tryParse(_controllers['monthlyIncome']!.text) ?? 0.0,
        employer:
            _controllers['employer']!.text.isNotEmpty
                ? _controllers['employer']!.text
                : '',
        street: _controllers['street']!.text,
        extNumber: _controllers['extNumber']!.text,
        intNumber:
            _controllers['intNumber']!.text.isNotEmpty
                ? _controllers['intNumber']!.text
                : '',
        neighborhood: _controllers['neighborhood']!.text,
        borough: _controllers['borough']!.text,
        city: _controllers['city']!.text,
        state: _controllers['state']!.text,
        zipCode: _controllers['zipCode']!.text,
        notes:
            _controllers['notes']!.text.isNotEmpty
                ? _controllers['notes']!.text
                : '',
      );

      // Enviar evento para agregar inquilino
      BlocProvider.of<TenantBloc>(context).add(AddTenant(tenant: newTenant));

      // Cerrar la pantalla después de guardar
      Navigator.pop(context);
    }
  }
}
