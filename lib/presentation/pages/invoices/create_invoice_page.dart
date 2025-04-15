// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/domain/models/invoice/cfdi.dart';
import 'package:renta_control/domain/models/invoice/invoice_request.dart';
import 'package:renta_control/domain/models/invoice/payment.dart';
import 'package:renta_control/domain/models/invoice/tax_regime.dart';
import 'package:renta_control/domain/models/property/property.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_bloc.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_event.dart';
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
    final fields = ['legalName', 'taxId', 'email', 'zip', 'productQuantity'];

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
    if (_formKey.currentState!.validate()) {
      final invoiceRequest = InvoiceRequest(
        paymentForm: _selectedPaymentMethod!.key,
        use: _selectedInvoiceUse!.cfdiUse,
        customer: Customer(
          legalName: _controllers['legalName']!.text,
          taxId: _controllers['taxId']!.text,
          taxSystem: _selectedTaxRegime!.key,
          email: _controllers['email']!.text,
          address: Address(zip: _controllers['zip']!.text),
        ),
        items: [
          Item(
            quantity: int.parse(_controllers['productQuantity']!.text),
            product: Product(
              description: 'Renta de: ${_selectedProperty!.name}',
              productKey: _selectedProperty!.productKey,
              unitKey: _selectedProperty!.unitKey,
              price: _selectedProperty!.price,
            ),
          ),
        ],
      );

      // Enviar evento para crear factura
      BlocProvider.of<InvoiceBloc>(
        context,
      ).add(CreateInvoice(invoiceRequest: invoiceRequest));

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
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
                    border: OutlineInputBorder(),
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
