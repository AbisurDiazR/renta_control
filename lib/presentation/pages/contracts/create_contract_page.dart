// ignore_for_file: library_private_types_in_public_api, unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/domain/models/guarantor/guarantor.dart';
import 'package:renta_control/domain/models/owner/owner_model.dart';
import 'package:renta_control/domain/models/property/property.dart';
import 'package:renta_control/domain/models/tenant/tenant.dart';
import 'package:renta_control/presentation/blocs/guarantor/guarantor_bloc.dart';
import 'package:renta_control/presentation/blocs/guarantor/guarantor_event.dart';
import 'package:renta_control/presentation/blocs/guarantor/guarantor_state.dart';
import 'package:renta_control/presentation/blocs/owners/owner_bloc.dart';
import 'package:renta_control/presentation/blocs/owners/owner_event.dart';
import 'package:renta_control/presentation/blocs/owners/owner_state.dart';
import 'package:renta_control/presentation/blocs/properties/property_bloc.dart';
import 'package:renta_control/presentation/blocs/properties/property_event.dart';
import 'package:renta_control/presentation/blocs/properties/property_state.dart';
import 'package:renta_control/presentation/blocs/tenant/tenant_bloc.dart';
import 'package:renta_control/presentation/blocs/tenant/tenant_event.dart';
import 'package:renta_control/presentation/blocs/tenant/tenant_state.dart';

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

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _rentController = TextEditingController();
  final _depositController = TextEditingController();
  final _paymentAccountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAllCollections();
  }

  void _fetchAllCollections() {
    BlocProvider.of<PropertyBloc>(context).add(FetchProperties());
    BlocProvider.of<TenantBloc>(context).add(FetchTenants());
    BlocProvider.of<OwnerBloc>(context).add(FetchOwners());
    BlocProvider.of<GuarantorBloc>(context).add(FetchGuarantors());
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
            _buildOwnerSelector(),
            SizedBox(height: 16.0),
            _buildGuarantorSelector(),
            SizedBox(height: 16.0),
            // Fechas y valores monetarios
            TextField(
              controller: _startDateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Fecha de inicio',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _endDateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Fecha de finalización',
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
            ],
          );
        } else if (state is PropertyError) {
          return Text("Error: ${state.message}");
        } else {
          return Text("No se encuentran propiedades registradas");
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
            ],
          );
        } else if (state is TenantError) {
          return Text("Error: ${state.message}");
        } else {
          return Text("No se encuentran inquilinos registrados");
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
            ],
          );
        } else if (state is OwnerError) {
          return Text("Error: ${state.message}");
        } else {
          return Text("No se encuentran inquilinos registrados");
        }
      },
    );
  }

  Widget _buildGuarantorSelector() {
    return BlocBuilder<GuarantorBloc, GuarantorState>(
      builder: (context, state) {
        if (state is GuarantorLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is GuarantorLoaded) {
          return Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<Guarantor>(
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
            ],
          );
        } else if (state is GuarantorError) {
          return Text("Error: ${state.message}");
        } else {
          return Text("No se encuentran inquilinos registrados");
        }
      },
    );
  }

  void _generatePdf() {
    // Validar selección
    if (selectedProperty == null ||
        selectedTenant == null ||
        selectedGuarantor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona todos los participantes'),
        ),
      );
      return;
    }

    // Aquí llamarás a un método que combine los datos y genere el PDF usando un motor como `pdf` o `dart_odf`
    // También podrías convertir el `.odt` a `.docx` y usar `docx_template`
  }
}
