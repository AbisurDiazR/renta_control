// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/domain/models/owner/owner_model.dart';
import 'package:renta_control/domain/models/property/property.dart';
import 'package:renta_control/presentation/blocs/owners/owner_bloc.dart';
import 'package:renta_control/presentation/blocs/owners/owner_event.dart';
import 'package:renta_control/presentation/blocs/owners/owner_state.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/pages/owners/add_owner_page.dart';

class AddPropertyPage extends StatefulWidget {
  final Property? property;
  const AddPropertyPage({super.key, this.property});

  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  Property? propertyObject;
  OwnerModel? _selectedOwner;

  @override
  void initState() {
    super.initState();
    propertyObject = widget.property;
    _initializeControllers();
    _fetchOwners();
  }

  void _fetchOwners() {
    BlocProvider.of<OwnerBloc>(context).add(FetchOwners());
  }

  void _initializeControllers() {
    final fields = [
      'name',
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

    if (propertyObject != null) {
      _controllers['name']!.text = propertyObject!.name;
      _controllers['street']!.text = propertyObject!.street;
      _controllers['extNumber']!.text = propertyObject!.extNumber;
      _controllers['intNumber']!.text = propertyObject!.intNumber ?? '';
      _controllers['neighborhood']!.text = propertyObject!.neighborhood;
      _controllers['borough']!.text = propertyObject!.borough;
      _controllers['city']!.text = propertyObject!.city;
      _controllers['state']!.text = propertyObject!.state;
      _controllers['zipCode']!.text = propertyObject!.zipCode;
      _controllers['notes']!.text =
          propertyObject!.notes;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedOwner != null) {

      final Property newProperty = Property(
        name: _controllers['name']!.text,
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
        notes: _controllers['notes']!.text,
        ownerId: _selectedOwner?.id,
        status: 'disponible',
      );
      BlocProvider.of<PropertyBloc>(context).add(
        propertyObject == null
            ? AddProperty(property: newProperty)
            : UpdateProperty(
              property: propertyObject!.copyWith(
                name: newProperty.name,
                street: newProperty.street,
                extNumber: newProperty.extNumber,
                intNumber: newProperty.intNumber,
                neighborhood: newProperty.neighborhood,
                borough: newProperty.borough,
                city: newProperty.city,
                state: newProperty.state,
                zipCode: newProperty.zipCode,
                notes: newProperty.notes,
                ownerId: _selectedOwner?.id,
                status: newProperty.status,
                ownerName: _selectedOwner?.name,
              ),
            ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
    }
  }

  void _navigateToAddOwnerPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddOwnerPage()),
    );
    // Actualiza la lista de propietarios al volver
    // ignore: use_build_context_synchronously
    BlocProvider.of<OwnerBloc>(context).add(FetchOwners());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          propertyObject == null
              ? "Registrar nueva propiedad"
              : "Editar propiedad",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var field in _controllers.keys)
                  _buildTextField(field, isRequired: field != 'intNumber'),
                if (propertyObject != null)
                  Text(
                    'El propietario actual es: ${propertyObject!.ownerName}',
                  ),

                const SizedBox(height: 16),
                _buildOwnerDropdown(),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    propertyObject == null
                        ? 'Registrar propiedad'
                        : 'Guardar cambios',
                  ),
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
    
    if(field == 'zipCode'){
      keyboardType = TextInputType.number;
    } else if(field == 'price'){
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
      'name': 'Nombre de la propiedad',
      'street': 'Calle',
      'extNumber': 'Número exterior',
      'intNumber': 'Número interior (opcional)',
      'neighborhood': 'Colonia',
      'borough': 'Alcaldía',
      'city': 'Ciudad',
      'state': 'Estado',
      'zipCode': 'Código Postal',
      'notes': 'Comentarios',
    };
    return labels[field] ?? field;
  }

  Widget _buildOwnerDropdown() {
    return BlocBuilder<OwnerBloc, OwnerState>(
      builder: (context, state) {
        if (state is OwnerLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is OwnerLoaded) {
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<OwnerModel>(
                  value: _selectedOwner,
                  onChanged: (OwnerModel? value) {
                    setState(() {
                      _selectedOwner = value!;
                    });
                  },
                  items:
                      state.owners.map((OwnerModel owner) {
                        return DropdownMenuItem(
                          value: owner,
                          child: Text(owner.name),
                        );
                      }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Seleccione propietario',
                    border: OutlineInputBorder()
                  ),
                  validator:
                      (value) =>
                          value == null && propertyObject == null
                              ? 'Por favor selecciona un propietario'
                              : null,
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _navigateToAddOwnerPage,
              ),
            ],
          );
        } else if (state is OwnerError) {
          return Text("Error: ${state.message}");
        } else {
          return Row(
            children: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _navigateToAddOwnerPage,
              ),
            ],
          );
        }
      },
    );
  }
}
