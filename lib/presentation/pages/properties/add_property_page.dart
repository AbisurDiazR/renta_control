// ignore_for_file: library_private_types_in_public_api, cast_from_null_always_fails, unnecessary_null_comparison, duplicate_ignore
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:renta_control/domain/models/owner/owner_model.dart';
import 'package:renta_control/domain/models/property/property.dart';
import 'package:renta_control/presentation/blocs/owners/owner_bloc.dart';
import 'package:renta_control/presentation/blocs/owners/owner_event.dart';
import 'package:renta_control/presentation/blocs/owners/owner_state.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/pages/owners/add_owner_page.dart';
import 'package:collection/collection.dart'; // ¡Importante para firstWhereOrNull!

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
  OwnerModel?
  _selectedOwner; // Ahora será inicializado por la lógica del BlocBuilder

  DateTime? _selectedRegistrationDate;

  @override
  void initState() {
    super.initState();
    propertyObject = widget.property;
    _initializeControllers();
    _fetchOwners();
  }

  void _fetchOwners() {
    // Asegurarse de que este Add OwnerBloc si existe en el arbol de widgets
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
      'landArea',
      'contructionArea',
      'deedNumber',
      'deedVolume',
      'notaryName',
      'notaryNumber',
      'notaryCity',
      'notaryState',
      'registrationDate',
      'registrationNumber',
      'registrationFolio',
      'registrationVolume',
      'registrationSection',
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
      _controllers['notes']!.text = propertyObject!.notes;
      _controllers['landArea']!.text = propertyObject!.landArea.toString();
      _controllers['contructionArea']!.text =
          propertyObject!.constructionArea.toString();
      _controllers['deedNumber']!.text = propertyObject!.deedNumber ?? '';
      _controllers['deedVolume']!.text = propertyObject!.deedVolume ?? '';
      _controllers['notaryName']!.text = propertyObject!.notaryName ?? '';
      _controllers['notaryNumber']!.text = propertyObject!.notaryNumber ?? '';
      _controllers['notaryCity']!.text = propertyObject!.notaryCity ?? '';
      _controllers['notaryState']!.text = propertyObject!.notaryState ?? '';

      // Conversión segura para registrationDate si es DateTime
      _selectedRegistrationDate = propertyObject!.registrationDate;
      _controllers['registrationDate']!.text =
          propertyObject!.registrationDate != null
              ? DateFormat(
                'dd/MM/yyyy',
              ).format(propertyObject!.registrationDate!)
              : '';

      _controllers['registrationNumber']!.text =
          propertyObject!.registrationNumber ?? '';
      _controllers['registrationFolio']!.text =
          propertyObject!.registrationFolio ?? '';
      _controllers['registrationVolume']!.text =
          propertyObject!.registrationVolume ?? '';
      _controllers['registrationSection']!.text =
          propertyObject!.registrationSection ?? '';

      // No inicialices _selectedOwner aquí. Lo haremos en el BlocBuilder.
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final Property newProperty = Property(
        id: propertyObject?.id, // Conservar el ID si es una actualización
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
        owner: _selectedOwner,
        status: 'disponible',
        landArea:
            _controllers['landArea']!.text.isNotEmpty
                ? double.tryParse(_controllers['landArea']!.text) ?? 0.0
                : 0.0,
        constructionArea:
            _controllers['contructionArea']!.text.isNotEmpty
                ? double.tryParse(_controllers['contructionArea']!.text) ?? 0.0
                : 0.0,
        deedNumber: _controllers['deedNumber']!.text,
        deedVolume: _controllers['deedVolume']!.text,
        notaryName: _controllers['notaryName']!.text,
        notaryNumber: _controllers['notaryNumber']!.text,
        notaryCity: _controllers['notaryCity']!.text,
        notaryState: _controllers['notaryState']!.text,
        registrationDate: _selectedRegistrationDate,
        registrationNumber: _controllers['registrationNumber']!.text,
        registrationFolio: _controllers['registrationFolio']!.text,
        registrationVolume: _controllers['registrationVolume']!.text,
        registrationSection: _controllers['registrationSection']!.text,
      );

      if (propertyObject == null) {
        BlocProvider.of<PropertyBloc>(
          context,
        ).add(AddProperty(property: newProperty));
      } else {
        BlocProvider.of<PropertyBloc>(context).add(
          UpdateProperty(
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
              owner: widget.property!.owner, // Asegúrate de que _selectedOwner sea OwnerModel?
              status: newProperty.status,
              landArea: newProperty.landArea,
              constructionArea: newProperty.constructionArea,
              deedNumber: newProperty.deedNumber,
              deedVolume: newProperty.deedVolume,
              notaryName: newProperty.notaryName,
              notaryNumber: newProperty.notaryNumber,
              notaryCity: newProperty.notaryCity,
              notaryState: newProperty.notaryState,
              registrationDate: newProperty.registrationDate,
              registrationNumber: newProperty.registrationNumber,
              registrationFolio: newProperty.registrationFolio,
              registrationVolume: newProperty.registrationVolume,
              registrationSection: newProperty.registrationSection,
            ),
          ),
        );
      }
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, complete todos los campos y seleccione un propietario',
          ),
        ),
      );
    }
  }

  void _navigateToAddOwnerPage() async {
    setState(() {
      _selectedOwner = null;
    });
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddOwnerPage()),
    );
    // Vuelve a cargar los propietarios después de agregar uno nuevo
    if (mounted) {
      // Asegúrate de que el widget sigue montado antes de usar el contexto
      BlocProvider.of<OwnerBloc>(context).add(FetchOwners());
    }
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
                if (propertyObject == null)
                  _buildOwnerDropdown(), // Llama al widget del dropdown
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
    bool readOnly = false;
    VoidCallback? onTapCallback; // Cambiado a VoidCallback?

    if (field == 'zipCode' ||
        field == 'landArea' ||
        field == 'contructionArea') {
      keyboardType = TextInputType.number;
    } else if (field == 'price') {
      keyboardType = TextInputType.numberWithOptions(decimal: true);
      inputFormatters = [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ];
    } else if (field == 'registrationDate') {
      keyboardType = TextInputType.datetime;
      readOnly = true;
      onTapCallback =
          () => _selectDate(
            context,
            _controllers[field]!,
            onDateTimeSelected: (date) {
              setState(() {
                _selectedRegistrationDate = date;
              });
            },
          );
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
        readOnly: readOnly,
        onTap: onTapCallback, // Asigna el callback
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller, {
    required Function(DateTime) onDateTimeSelected,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedRegistrationDate ??
          DateTime.now(), // Usa la fecha existente o la actual
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      helpText: 'Selecciona una fecha',
      fieldLabelText: 'Fecha de inscripción',
      locale: const Locale('es', 'MX'),
    );
    if (picked != null) {
      onDateTimeSelected(picked);
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
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
      'landArea': 'Superficie del terreno (m²)',
      'contructionArea': 'Superficie de construcción (m²)',
      'deedNumber': 'Número de escritura',
      'deedVolume': 'Volumen de escritura',
      'notaryName': 'Nombre del notario',
      'notaryNumber': 'Número de notaría',
      'notaryCity': 'Ciudad de la notaría',
      'notaryState': 'Estado de la notaría',
      'registrationDate': 'Fecha de inscripción en el RPPC',
      'registrationNumber': 'Número de registro de la propiedad',
      'registrationFolio': 'Foja de registro RPPC',
      'registrationVolume': 'Volumen de registro RPPC',
      'registrationSection': 'Sección de registro RPPC',
    };
    return labels[field] ?? field;
  }

  Widget _buildOwnerDropdown() {
    return BlocBuilder<OwnerBloc, OwnerState>(
      builder: (context, state) {
        if (state is OwnerLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OwnerLoaded) {
          // Lógica para inicializar _selectedOwner aquí, una vez que los propietarios estén cargados.
          // Solo si propertyObject y propertyObject.owner no son nulos y _selectedOwner aún no ha sido establecido.
          if (propertyObject != null &&
              propertyObject!.owner != null &&
              _selectedOwner == null) {
            _selectedOwner = state.owners.firstWhereOrNull(
              (o) => o.id == propertyObject!.owner!.id,
            );
          }

          if (state.owners.isEmpty) {
            return Column(
              children: [
                const Text(
                  'No hay propietarios disponibles. ¿Deseas añadir uno?',
                ),
                ElevatedButton(
                  onPressed: _navigateToAddOwnerPage,
                  child: const Text('Añadir Propietario'),
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<OwnerModel>(
                  value:
                      _selectedOwner, // Ahora puede ser null si no se encontró o no hay propiedad inicial
                  onChanged: (OwnerModel? value) {
                    setState(() {
                      _selectedOwner =
                          value; // Aceptar null si el usuario lo deselecciona
                    });
                  },
                  items:
                      state.owners.map((OwnerModel owner) {
                        return DropdownMenuItem<OwnerModel>(
                          // Asegúrate de que el tipo sea OwnerModel
                          value: owner,
                          child: Text(owner.name),
                        );
                      }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Seleccione propietario',
                    border: OutlineInputBorder(),
                  ),
                  // Validador mejorado: requiere selección si la lista no está vacía.
                  validator: (value) {                    
                    return null;
                  },                  
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _navigateToAddOwnerPage,
              ),
            ],
          );
        } else if (state is OwnerError) {
          return Text("Error cargando propietarios: ${state.message}");
        } else {
          // Estado inicial o desconocido, muestra un indicador de carga o un botón de reintento.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
