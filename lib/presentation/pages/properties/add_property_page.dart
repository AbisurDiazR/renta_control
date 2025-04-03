// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
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
  List<OwnerModel> _owners = [];

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

  void _setSelectedOwner(List<OwnerModel> owners) {
    if (_selectedOwner == null && propertyObject != null) {
      _selectedOwner = owners.firstWhere(
        (owner) => owner.id == propertyObject!.ownerId,
        orElse:
            () => OwnerModel(
              name: '',
              email: '',
              phone: '',
              street: '',
              extNumber: '',
              neighborhood: '',
              borough: '',
              city: '',
              state: '',
              zipCode: '',
            ),
      );
    }

    if (_selectedOwner!.id!.isEmpty) {
      _selectedOwner = null;
    }

    // Verifica si _selectedOwner aún no está en la lista, si es así, lo pone en null
    if (_selectedOwner != null &&
        !owners.any((o) => o.id == _selectedOwner!.id)) {
      _selectedOwner = null;
    }
  }

  void _initializeControllers() {
    final fields = [
      'name',
      'unitNumber',
      'street',
      'extNumber',
      'intNumber',
      'neighborhood',
      'borough',
      'city',
      'state',
      'zipCode',
      'propertyTaxNumber',
    ];

    for (var field in fields) {
      _controllers[field] = TextEditingController();
    }

    if (propertyObject != null) {
      _controllers['name']!.text = propertyObject!.name;
      _controllers['unitNumber']!.text = propertyObject!.unitNumber;
      _controllers['street']!.text = propertyObject!.street;
      _controllers['extNumber']!.text = propertyObject!.extNumber;
      _controllers['intNumber']!.text = propertyObject!.intNumber ?? '';
      _controllers['neighborhood']!.text = propertyObject!.neighborhood;
      _controllers['borough']!.text = propertyObject!.borough;
      _controllers['city']!.text = propertyObject!.city;
      _controllers['state']!.text = propertyObject!.state;
      _controllers['zipCode']!.text = propertyObject!.zipCode;
      _controllers['propertyTaxNumber']!.text =
          propertyObject!.propertyTaxNumber;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedOwner != null) {
      final Property newProperty = Property(
        name: _controllers['name']!.text,
        unitNumber: _controllers['unitNumber']!.text,
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
        propertyTaxNumber: _controllers['propertyTaxNumber']!.text,
        ownerId: _selectedOwner?.id,
        status: 'disponible',
        ownerName: _selectedOwner?.name,
      );
      BlocProvider.of<PropertyBloc>(context).add(
        propertyObject == null
            ? AddProperty(property: newProperty)
            : UpdateProperty(
              property: propertyObject!.copyWith(
                name: newProperty.name,
                unitNumber: newProperty.unitNumber,
                street: newProperty.street,
                extNumber: newProperty.extNumber,
                intNumber: newProperty.intNumber,
                neighborhood: newProperty.neighborhood,
                borough: newProperty.borough,
                city: newProperty.city,
                state: newProperty.state,
                zipCode: newProperty.zipCode,
                propertyTaxNumber: newProperty.propertyTaxNumber,
                ownerId: _selectedOwner?.id,
                status: newProperty.status,
                ownerName: _selectedOwner?.name,
              ),
            ),
      );
      print(_selectedOwner?.toMap());
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
      'name': 'Nombre de la propiedad',
      'unitNumber': 'Número de departamento/local',
      'street': 'Calle',
      'extNumber': 'Número exterior',
      'intNumber': 'Número interior (opcional)',
      'neighborhood': 'Colonia',
      'borough': 'Alcaldía',
      'city': 'Ciudad',
      'state': 'Estado',
      'zipCode': 'Código Postal',
      'propertyTaxNumber': 'Número de cuenta predial',
    };
    return labels[field] ?? field;
  }

  Widget _buildOwnerDropdown() {
    return BlocBuilder<OwnerBloc, OwnerState>(
      builder: (context, state) {
        if (state is OwnerLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is OwnerLoaded) {
          _owners = state.owners;
          if (_selectedOwner == null && propertyObject != null) {
            _setSelectedOwner(_owners);
          }
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
                  ),
                  validator:
                      (value) =>
                          value == null
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
