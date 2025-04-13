// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:renta_control/domain/models/invoice/invoice.dart';
import 'package:renta_control/domain/models/invoice/cfdi.dart';
import 'package:renta_control/domain/models/invoice/payment.dart';
import 'package:renta_control/domain/models/invoice/tax_regime.dart';
import 'package:renta_control/domain/models/property/property.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/blocs/properties/property_state.dart';
import 'package:renta_control/utils/constants/cfdi_list.dart';
import 'package:renta_control/utils/constants/payments_list.dart';
import 'package:renta_control/utils/constants/tax_regime_list.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  _CreateInvoicePageState createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  List<Payment> paymentMethods = paymentsList;
  Payment? _selectedPaymentMethod; // Codigo de forma de pago por defecto
  List<CFDI> invoiceUses = cfdiList;
  CFDI? _selectedInvoiceUse; // Codigo de uso de CFDI por defecto
  List<TaxRegime> taxRegimes = taxRegimesList;
  TaxRegime? _selectedTaxRegime; // Codigo de regimen fiscal por defecto
  Property? _selectedProperty;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchProperties();
  }

  void _fetchProperties() {
    BlocProvider.of<PropertyBloc>(context).add(FetchProperties());
  }

  _initializeControllers() {
    final fields = [
      'legalName',
      'taxId',
      'email',
      'zip',
      'productQuantity',
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
      appBar: AppBar(title: Text('Agregar factura')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var field in _controllers.keys)
                  _buildTextField(field, isRequired: true),
                SizedBox(height: 20),
                _buildPropertyDropdown(),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  value: _selectedPaymentMethod,
                  decoration: InputDecoration(
                    labelText: 'Forma de pago',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      paymentMethods.map((payment) {
                        return DropdownMenuItem(
                          value: payment,
                          child: Text(payment.name),
                        );
                      }).toList(),
                  onChanged: (Payment? value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                  validator:
                      (value) =>
                          value == null
                              ? 'Por favor selecciona un metodo de pago'
                              : null,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  value: _selectedInvoiceUse,
                  decoration: InputDecoration(
                    labelText: 'CFDI',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      invoiceUses.map((cfdi) {
                        return DropdownMenuItem(
                          value: cfdi,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              '${cfdi.cfdiUse} - ${cfdi.cfdiDescription}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (CFDI? value) {
                    setState(() {
                      _selectedInvoiceUse = value!;
                    });
                  },
                  validator:
                      (value) =>
                          value == null ? 'Por favor selecciona un CFDI' : null,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                  value: _selectedTaxRegime,
                  decoration: InputDecoration(
                    labelText: 'Regimen fiscal',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      taxRegimes.map((taxRegime) {
                        return DropdownMenuItem(
                          value: taxRegime,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              '${taxRegime.key} - ${taxRegime.description}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }).toList(),
                  onChanged: (TaxRegime? value) {
                    setState(() {
                      _selectedTaxRegime = value!;
                    });
                  },
                  validator:
                      (value) =>
                          value == null
                              ? 'Por favor selecciona un regimen fiscal'
                              : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Guardar factura'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String field, {required bool isRequired}) {
    TextInputType keyboardType = TextInputType.text;
    List<TextInputFormatter>? inputFormatters;

    if (field == 'email') {
      keyboardType = TextInputType.emailAddress;
    } else if (field == 'zip') {
      keyboardType = TextInputType.number;
    } else if (field == 'productQuantity') {
      keyboardType = TextInputType.number;
      inputFormatters = [FilteringTextInputFormatter.digitsOnly];
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers[field],
        decoration: InputDecoration(
          labelText: _getLabelText(field),
          border: OutlineInputBorder(),
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
      'legalName': 'Nombre o Razón Social del Cliente',
      'taxId': 'RFC del Cliente',
      'email': 'Correo Electrónico del Cliente',
      'zip': 'Código Postal del Domicilio Fiscal',
      'productQuantity': 'Cantidad',
    };
    return labels[field] ?? field;
  }

  void _submitForm() async {
    // Atributos de facturación
    final url = Uri.parse(dotenv.env['API_URL']!);
    final apiKey = dotenv.env['API_KEY'];

    if (_formKey.currentState!.validate()) {

      final body = {
        "payment_form": _selectedPaymentMethod!.key,
        "use": _selectedInvoiceUse!.cfdiUse,
        "customer": {
          "legal_name": _controllers['legalName']!.text,
          "tax_id": _controllers['taxId']!.text,
          "tax_system": _selectedTaxRegime!.key,
          "email": _controllers['email']!.text,
          "address": {"zip": _controllers['zip']!.text},
        },
        "items": [
          {
            "quantity": int.parse(_controllers['productQuantity']!.text),
            "product": {
              "description": "Renta de: ${_selectedProperty!.name}",
              "product_key": _selectedProperty!.productKey,
              "unit_key": _selectedProperty!.unitKey,
              "price": _selectedProperty!.price,
            },
          },
        ],
      };

      try {
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        );

        if (response.statusCode == 200) {
          // Factura creada con éxito
          print('Factura creada: ${response.body}');
          Navigator.pop(context);
        } else {
          // Error en la creación
          print('Error al crear factura: ${response.body}');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error al crear la factura')));
        }
      } catch (e) {
        print('Excepción al enviar la solicitud: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ocurrió un error al conectar con el servidor'),
          ),
        );
      }
    }
  }

  Widget _buildPropertyDropdown() {
    return BlocBuilder<PropertyBloc, PropertyState>(
      builder: (context, state) {
        if (state is PropertyLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PropertyLoaded) {
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<Property>(
                  value: _selectedProperty,
                  onChanged: (Property? value) {
                    setState(() {
                      _selectedProperty = value!;
                    });
                  },
                  items:
                      state.properties.map((Property property) {
                        return DropdownMenuItem(
                          value: property,
                          child: Text(property.name),
                        );
                      }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Seleccione la propiedad',
                    border: OutlineInputBorder()
                  ),
                  validator:
                      (value) =>
                          value == null
                              ? 'Por favor seleccione una propiedad'
                              : null,
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Text('No se pudieron obtener la lista de propiedades'),
          );
        }
      },
    );
  }
}
