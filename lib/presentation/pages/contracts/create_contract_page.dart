// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:renta_control/domain/models/guarantor/guarantor.dart';
import 'package:renta_control/presentation/blocs/guarantor/guarantor_state.dart';
import 'package:renta_control/presentation/pages/guarantors/add_guarantor.dart';
import 'package:renta_control/domain/models/owner/owner_model.dart';
import 'package:renta_control/domain/models/property/property.dart';
import 'package:renta_control/domain/models/representative/representative.dart';
import 'package:renta_control/domain/models/tenant/tenant.dart';
import 'package:renta_control/presentation/blocs/guarantor/guarantor_bloc.dart';
import 'package:renta_control/presentation/blocs/guarantor/guarantor_event.dart';
import 'package:renta_control/presentation/blocs/owners/owner_bloc.dart';
import 'package:renta_control/presentation/blocs/owners/owner_event.dart';
import 'package:renta_control/presentation/blocs/owners/owner_state.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/blocs/properties/property_state.dart';
import 'package:renta_control/presentation/blocs/representative/representative_bloc.dart';
import 'package:renta_control/presentation/blocs/representative/representative_event.dart';
import 'package:renta_control/presentation/blocs/representative/representative_state.dart';
import 'package:renta_control/presentation/blocs/tenant/tenant_bloc.dart';
import 'package:renta_control/presentation/blocs/tenant/tenant_event.dart';
import 'package:renta_control/presentation/blocs/tenant/tenant_state.dart';
import 'package:intl/intl.dart';
import 'package:renta_control/presentation/pages/owners/add_owner_page.dart';
import 'package:renta_control/presentation/pages/properties/add_property_page.dart';
import 'package:renta_control/presentation/pages/representatives/add_representative_page.dart';
import 'package:renta_control/presentation/pages/tenants/add_tenant.dart';
import 'package:http/http.dart' as http;

class CreateContractPage extends StatefulWidget {
  const CreateContractPage({super.key});

  @override
  _CreateContractPageState createState() => _CreateContractPageState();
}

class _CreateContractPageState extends State<CreateContractPage> {
  Property? selectedProperty;
  Tenant? selectedTenant;
  OwnerModel? selectedOwner;
  Guarantor? selectedGuarantor;
  Representative? selectedOwnerRepresentative;
  Representative? selectedTenantRepresentative;

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _rentController = TextEditingController();
  final _depositController = TextEditingController();
  final _paymentAccountController = TextEditingController();

  //Variables para almacenar fechas seleccionadas
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  WidgetsBinding? _widgetsBindingInstance;

  @override
  void initState() {
    super.initState();
    _widgetsBindingInstance = WidgetsBinding.instance;
    _fetchAllCollections();
  }

  @override
  void dispose() {
    super.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    _paymentAccountController.dispose();
  }

  void _fetchAllCollections() {
    BlocProvider.of<PropertyBloc>(context).add(FetchProperties());
    BlocProvider.of<TenantBloc>(context).add(FetchTenants());
    BlocProvider.of<OwnerBloc>(context).add(FetchOwners());
    BlocProvider.of<GuarantorBloc>(context).add(FetchGuarantors());
    BlocProvider.of<RepresentativeBloc>(context).add(FetchRepresentatives());
  }

  //Metodo para seleccionar la fecha
  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller, {
    required bool isStartDate,
  }) async {
    final DateTime initialDate =
        (isStartDate ? _selectedStartDate : _selectedEndDate) ?? DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      helpText:
          isStartDate
              ? 'Selecciona la fecha de inicio'
              : 'Selecciona la fecha de finalización',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      locale: Locale('es', 'ES'),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = pickedDate;
        } else {
          _selectedEndDate = pickedDate;
        }
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear contrato')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildePropertySelector(),
            SizedBox(height: 16.0),
            _buildTenantSelector(),
            SizedBox(height: 16.0),
            _buildRepresentativeSelector(
              isOwnerRepresentative: false,
              currentSelected: selectedTenantRepresentative,
              onChanged: (representative) {
                setState(() {
                  selectedTenantRepresentative = representative;
                });
              },
              labelText: "Seleccione un representante del inquilino",
            ),
            SizedBox(height: 16.0),
            _buildOwnerSelector(),
            SizedBox(height: 16.0),
            _buildRepresentativeSelector(
              isOwnerRepresentative: true,
              currentSelected: selectedOwnerRepresentative,
              onChanged: (representative) {
                setState(() {
                  selectedOwnerRepresentative = representative;
                });
              },
              labelText: "Seleccione un representante del propietario",
            ),
            SizedBox(height: 16.0),
            _buildGuarantSelector(),
            SizedBox(height: 16.0),
            // Fechas y valores monetarios
            TextField(
              controller: _startDateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Fecha de inicio',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap:
                  () => _selectDate(
                    context,
                    _startDateController,
                    isStartDate: true,
                  ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Fecha de finalización',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap:
                  () => _selectDate(
                    context,
                    _endDateController,
                    isStartDate: false,
                  ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _rentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Renta mensual',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _depositController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Depósito en garantía',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _paymentAccountController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Cuenta para pagos',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generatePdf,
              child: const Text('Generar contrato'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildePropertySelector() {
    return BlocBuilder<PropertyBloc, PropertyState>(
      builder: (context, state) {
        if (state is PropertyLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PropertyLoaded) {
          _widgetsBindingInstance?.addPostFrameCallback((_) {
            if (selectedProperty != null) {
              final foundProperty = state.properties.firstWhereOrNull(
                (p) => p.id == selectedProperty!.id,
              );

              if (foundProperty != null && foundProperty != selectedProperty) {
                setState(() {
                  selectedProperty = foundProperty;
                });
              } else if (foundProperty == null && selectedProperty != null) {
                setState(() {
                  selectedProperty = null;
                });
              }
            }
          });
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<Property>(
                  value: selectedProperty,
                  onChanged: (Property? value) {
                    setState(() {
                      selectedProperty = value!;
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
                    labelText: 'Seleccione una propiedad',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null
                              ? 'Por favor seleccione una propiedad'
                              : null,
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _navigateToAdd('property');
                },
              ),
            ],
          );
        } else if (state is PropertyError) {
          return Text("Error: ${state.message}");
        } else {
          return Row(
            children: [
              Text("No se encuentran propiedades registradas"),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _navigateToAdd('property');
                },
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildTenantSelector() {
    return BlocBuilder<TenantBloc, TenantState>(
      builder: (context, state) {
        if (state is TenantLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TenantLoaded) {
          _widgetsBindingInstance?.addPostFrameCallback((_) {
            if (selectedTenant != null) {
              final foundTenant = state.tenants.firstWhereOrNull(
                (t) => t.id == selectedTenant!.id,
              );

              if (foundTenant != null && foundTenant != selectedTenant) {
                setState(() {
                  selectedTenant = foundTenant;
                });
              } else if (foundTenant == null && selectedTenant != null) {
                setState(() {
                  selectedTenant = null;
                });
              }
            }
          });
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<Tenant>(
                  value: selectedTenant,
                  onChanged: (Tenant? value) {
                    setState(() {
                      selectedTenant = value!;
                    });
                  },
                  items:
                      state.tenants.map((Tenant tenant) {
                        return DropdownMenuItem(
                          value: tenant,
                          child: Text(tenant.fullName),
                        );
                      }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Selecciones un inquilino',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null
                              ? 'Por favor seleccione un inquilino'
                              : null,
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _navigateToAdd('tenant');
                },
              ),
            ],
          );
        } else if (state is TenantError) {
          return Text("Error: ${state.message}");
        } else {
          return Row(
            children: [
              Text("No se encuentran inquilinos registrados"),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _navigateToAdd('tenant');
                },
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildOwnerSelector() {
    return BlocBuilder<OwnerBloc, OwnerState>(
      builder: (context, state) {
        if (state is OwnerLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is OwnerLoaded) {
          _widgetsBindingInstance?.addPostFrameCallback((_) {
            if (selectedOwner != null) {
              final foundOwner = state.owners.firstWhereOrNull(
                (o) => o.id == selectedOwner!.id,
              );

              if (foundOwner != null && foundOwner != selectedOwner) {
                setState(() {
                  selectedOwner = foundOwner;
                });
              } else if (foundOwner == null && selectedOwner != null) {
                setState(() {
                  selectedOwner = null;
                });
              }
            }
          });
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<OwnerModel>(
                  value: selectedOwner,
                  onChanged: (OwnerModel? value) {
                    setState(() {
                      selectedOwner = value!;
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
                    labelText: 'Selecciones un propietario',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null
                              ? 'Por favor seleccione un propietario'
                              : null,
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _navigateToAdd('owner');
                },
              ),
            ],
          );
        } else if (state is OwnerError) {
          return Text("Error: ${state.message}");
        } else {
          return Row(
            children: [
              Text("No se encuentran propietarios registrados"),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _navigateToAdd('owner');
                },
              ),
            ],
          );
        }
      },
    );
  }

  // Selector de representante de inquilino
  Widget _buildRepresentativeSelector({
    required bool isOwnerRepresentative,
    required Representative? currentSelected,
    required ValueChanged<Representative?> onChanged,
    required String labelText,
  }) {
    return BlocBuilder<RepresentativeBloc, RepresentativeState>(
      builder: (context, state) {
        if (state is RepresentativeLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is RepresentativeLoaded) {
          _widgetsBindingInstance?.addPersistentFrameCallback((_) {
            Representative? previousSelected =
                isOwnerRepresentative
                    ? selectedOwnerRepresentative
                    : selectedTenantRepresentative;
            if (previousSelected != null) {
              final foundRepresentative = state.representatives
                  .firstWhereOrNull((r) => r.id == previousSelected.id);
              if (foundRepresentative != null &&
                  foundRepresentative != previousSelected) {
                setState(() {
                  if (isOwnerRepresentative) {
                    selectedOwnerRepresentative = foundRepresentative;
                  } else {
                    selectedTenantRepresentative = foundRepresentative;
                  }
                });
              } else if (foundRepresentative == null &&
                  previousSelected != null) {
                setState(() {
                  if (isOwnerRepresentative) {
                    selectedOwnerRepresentative = null;
                  } else {
                    selectedTenantRepresentative = null;
                  }
                });
              }
            }
          });
          List<Representative> avalaibleRepresentatives =
              state.representatives.where((representative) {
                if (isOwnerRepresentative) {
                  return representative != selectedTenantRepresentative;
                } else {
                  return representative != selectedOwnerRepresentative;
                }
              }).toList();

          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  value: currentSelected,
                  onChanged: onChanged,
                  items:
                      avalaibleRepresentatives.map((
                        Representative representative,
                      ) {
                        return DropdownMenuItem(
                          value: representative,
                          child: Text(representative.fullName),
                        );
                      }).toList(),
                  decoration: InputDecoration(
                    labelText: labelText,
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null
                              ? 'Por favor ${labelText.toLowerCase()}'
                              : null,
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _navigateToAdd('representative');
                },
              ),
            ],
          );
        } else if (state is RepresentativeError) {
          return Text("Error: ${state.message}");
        } else {
          return Row(
            children: [
              Text("No hay representantes registados"),
              SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  _navigateToAdd('representative');
                },
                icon: Icon(Icons.add),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildGuarantSelector() {
    return BlocBuilder<GuarantorBloc, GuarantorState>(
      builder: (context, state) {
        if (state is GuarantorLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is GuarantorLoaded) {
          _widgetsBindingInstance?.addPostFrameCallback((_) {
            if (selectedGuarantor != null) {
              final foundGuarantor = state.guarantors.firstWhereOrNull(
                (g) => g.id == selectedGuarantor!.id,
              );

              if (foundGuarantor != null &&
                  foundGuarantor != selectedGuarantor) {
                setState(() {
                  selectedGuarantor = foundGuarantor;
                });
              } else if (foundGuarantor == null && selectedGuarantor != null) {
                setState(() {
                  selectedGuarantor = null;
                });
              }
            }
          });
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  value: selectedGuarantor,
                  onChanged: (Guarantor? value) {
                    setState(() {
                      selectedGuarantor = value!;
                    });
                  },
                  items:
                      state.guarantors.map((Guarantor guarantor) {
                        return DropdownMenuItem(
                          value: guarantor,
                          child: Text(guarantor.fullName),
                        );
                      }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Seleccione un fiador',
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value == null
                              ? 'Por favor seleccione un fiador'
                              : null,
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  _navigateToAdd('guarantor');
                },
                icon: Icon(Icons.add),
              ),
            ],
          );
        } else if (state is GuarantorError) {
          return Text("Error: ${state.message}");
        } else {
          return Row(
            children: [
              Text("No hay fiadores registados"),
              SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  _navigateToAdd('guarantor');
                },
                icon: Icon(Icons.add),
              ),
            ],
          );
        }
      },
    );
  }

  // Agregar representante
  void _navigateToAdd(String typeElement) async {
    if (typeElement == 'representative') {
      setState(() {
        selectedOwnerRepresentative = null;
        selectedTenantRepresentative = null;
      });
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddRepresentativePage()),
      );
    } else if (typeElement == 'guarantor') {
      setState(() {
        selectedGuarantor = null;
      });
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddGuarantorPage()),
      );
    } else if (typeElement == 'property') {
      setState(() {
        selectedProperty = null;
      });
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddPropertyPage()),
      );
    } else if (typeElement == 'tenant') {
      setState(() {
        selectedTenant = null;
      });
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddTenantPage()),
      );
    } else if (typeElement == 'owner') {
      setState(() {
        selectedOwner = null;
      });
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddOwnerPage()),
      );
    }
  }

  Future<void> _generatePdf() async {
    final String? firebaseUrl = dotenv.env['FIREBASE_API'];

    if (firebaseUrl == null || firebaseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase URL no está configurado')),
      );
      return;
    }

    if (selectedProperty == null ||
        selectedTenant == null ||
        selectedOwner == null ||
        _selectedStartDate == null ||
        _selectedEndDate == null ||
        _rentController.text.isEmpty ||
        _depositController.text.isEmpty ||
        _paymentAccountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    // Indicador de progreso
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Generando contrato...')));

    try {
      final Map<String, dynamic> contractData = {
        'ownerFullName': selectedOwner!.name,
        'ownerRepresentative': selectedOwnerRepresentative!.fullName,
        'tenantFullName': selectedTenant!.fullName,
        'tenantRepresentative': selectedTenantRepresentative!.fullName,
        'guarantorFullName': selectedGuarantor!.fullName,
      };

      // Envia una solicitud POST al servidor para generar el contrato
      final response = await http.post(
        Uri.parse('$firebaseUrl/contracts'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'data': contractData}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final String? downloadUrl = responseBody['downloadUrl'];

        if (downloadUrl != null && downloadUrl.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Contrato generado exitosamente'),
              action: SnackBarAction(
                label: 'Abrir PDf',
                onPressed: () {
                  print('Abriendo URL: $downloadUrl');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('URL de descarga: $downloadUrl')),
                  );
                },
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('URL de descarga no disponible')),
          );
        }
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        final String errorMessage = errorBody['error'] ?? 'Error desconocido';
        throw Exception(
          'Error en el backend: ${response.statusCode} - $errorMessage',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar el contrato: $e')),
      );
      print('Error al generar el contrato: $e');
      return;
    }
  }
}
