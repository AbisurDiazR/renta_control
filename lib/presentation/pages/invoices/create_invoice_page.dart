// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:renta_control/domain/models/invoice/invoice.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  _CreateInvoicePageState createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  String _selectedPaymentMethod = 'Efectivo'; // Valor por defecto
  String _selectedInvoiceUse = 'Gastos en general'; // Valor por defecto

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  _initializeControllers() {
    final fields = [
      'clientName',
      'clientEmail',
      'clientRFC',
      'productDescription',
      'productKey',
      'productPrice',
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
                _buildDropdownField(
                  label: 'Forma de pago',
                  value: _selectedPaymentMethod,
                  items: ['Efectivo', 'Tarjeta de Crédito', 'Transferencia'],
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
                _buildDropdownField(
                  label: 'Uso de CFDI',
                  value: _selectedInvoiceUse,
                  items: ['Gastos en general', 'Adquisición de mercancías'],
                  onChanged: (value) {
                    setState(() {
                      _selectedInvoiceUse = value!;
                    });
                  },
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

  Widget _buildTextField(String field, {required bool isRequired}){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers[field],
        decoration: InputDecoration(
          labelText: _getLabelText(field),
          border: OutlineInputBorder()
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder()
        ),
        items: items.map((item){
          return DropdownMenuItem(
            value: item,
            child: Text(item),            
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
  
  String _getLabelText(String field) {
    final labels = {
      'clientName': 'Nombre del Cliente',
      'clientEmail': 'Correo Electrónico del Cliente',
      'clientRFC': 'RFC del Cliente',
      'productDescription': 'Descripción del Producto',
      'productKey': 'Clave del Producto',
      'productPrice': 'Precio del Producto',
      'productQuantity': 'Cantidad del Producto',
    };
    return labels[field] ?? field;
  }

  void _submitForm(){
    if (_formKey.currentState!.validate()) {
      final newInvoice = Invoice(
        clientName: _controllers['clientName']!.text,
        clientEmail: _controllers['clientEmail']!.text,
        clientRFC: _controllers['clientRFC']!.text,
        productDescription: _controllers['productDescription']!.text,
        productKey: _controllers['productKey']!.text,
        productPrice: double.parse(_controllers['productPrice']!.text),
        productQuantity: int.parse(_controllers['productQuantity']!.text),
        paymentMethod: _selectedPaymentMethod,
        invoiceUse: _selectedInvoiceUse,
      );

      // Enviar evento para agregar factura
      //BlocProvider.of<InvoiceBloc>(context).add(AddInvoice(invoice: newInvoice));
      print(newInvoice.toMap());

      // Cerrar la pantalla después de guardar
      Navigator.pop(context);
    }    
  }
}
