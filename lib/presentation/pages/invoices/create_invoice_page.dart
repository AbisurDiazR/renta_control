// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:renta_control/domain/models/contract/contract_model.dart';
import 'package:renta_control/domain/models/invoice/invoice.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_bloc.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_event.dart';
import 'package:renta_control/presentation/blocs/contracts/contract_state.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_bloc.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_event.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_state.dart';
import 'package:renta_control/utils/date_picker_helper.dart';

class CreateInvoicePage extends StatefulWidget {
  final Invoice? invoice;

  const CreateInvoicePage({Key? key, this.invoice}) : super(key: key);

  @override
  _CreateInvoicePageState createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>(); // GlobalKey for form validation

  // Text editing controllers for form fields
  //final TextEditingController _invoiceNumberController =
  //  TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _periodStartDateController =
      TextEditingController();
  final TextEditingController _periodEndDateController =
      TextEditingController();
  final TextEditingController _baseRentController = TextEditingController();
  final TextEditingController _additionalChargesDescriptionController =
      TextEditingController();
  final TextEditingController _additionalChargesAmountController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // State variables for selected dates and the chosen contract
  DateTime? _selectedIssueDate;
  DateTime? _selectedPeriodStartDate;
  DateTime? _selectedPeriodEndDate;
  Contract? _selectedContract; // The selected Contract object

  // WidgetsBinding instance for post-frame callbacks (to update dropdowns after Bloc loads data)
  WidgetsBinding? _widgetsBindingInstance;

  @override
  void initState() {
    super.initState();
    _widgetsBindingInstance = WidgetsBinding.instance;
    _fetchAllContracts(); // Trigger fetching contracts when the page initializes
    _initializeFormFields(); // Initialize form fields with existing invoice data or defaults
  }

  // Initializes form fields based on whether an invoice is being edited or created
  void _initializeFormFields() {
    if (widget.invoice != null) {
      // If in edit mode, pre-fill fields from the existing invoice
      //_invoiceNumberController.text = widget.invoice!.invoiceNumber ?? '';
      _selectedIssueDate = widget.invoice!.issueDate;
      _issueDateController.text =
          _selectedIssueDate != null
              ? DateFormat('dd/MM/yyyy').format(_selectedIssueDate!)
              : '';
      _selectedPeriodStartDate = widget.invoice!.periodStartDate;
      _periodStartDateController.text =
          _selectedPeriodStartDate != null
              ? DateFormat('dd/MM/yyyy').format(_selectedPeriodStartDate!)
              : '';
      _selectedPeriodEndDate = widget.invoice!.periodEndDate;
      _periodEndDateController.text =
          _selectedPeriodEndDate != null
              ? DateFormat('dd/MM/yyyy').format(_selectedPeriodEndDate!)
              : '';
      _baseRentController.text =
          widget.invoice!.baseRent?.toStringAsFixed(2) ?? '';
      _additionalChargesDescriptionController.text =
          widget.invoice!.additionalChargesDescription ?? '';
      _additionalChargesAmountController.text =
          widget.invoice!.additionalChargesAmount?.toStringAsFixed(2) ?? '';
      _notesController.text = widget.invoice!.notes ?? '';

      // The _selectedContract will be set in the ContractBloc listener once contracts are loaded
    } else {
      // Default values for a new invoice
      _selectedIssueDate = DateTime.now();
      _issueDateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(_selectedIssueDate!);
      _selectedPeriodStartDate = DateTime.now().subtract(
        const Duration(days: 30),
      ); // Default to previous month
      _periodStartDateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(_selectedPeriodStartDate!);
      _selectedPeriodEndDate = DateTime.now(); // Default to today
      _periodEndDateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(_selectedPeriodEndDate!);
    }
  }

  // Triggers the fetching of contracts via ContractBloc
  void _fetchAllContracts() {
    BlocProvider.of<ContractBloc>(context).add(FetchContracts());
  }

  @override
  void dispose() {
    // Dispose all text editing controllers to prevent memory leaks
    //_invoiceNumberController.dispose();
    _issueDateController.dispose();
    _periodStartDateController.dispose();
    _periodEndDateController.dispose();
    _baseRentController.dispose();
    _additionalChargesDescriptionController.dispose();
    _additionalChargesAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // --- Validation Logic for form fields ---

  // Validator for required text fields
  /*String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'El campo $fieldName es obligatorio';
    }
    return null;
  }*/

  // Validator for number input fields
  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'El campo $fieldName es obligatorio';
    }
    final numValue = double.tryParse(value);
    if (numValue == null) {
      return 'El campo $fieldName debe ser un número válido';
    }
    if (numValue <= 0 && fieldName != 'Monto de Cargos Adicionales') {
      return 'El campo $fieldName debe ser mayor a cero';
    }
    if (numValue < 0 && fieldName == 'Monto de Cargos Adicionales') {
      return 'El campo $fieldName no puede ser negativo';
    }
    return null;
  }

  // Validator for date fields
  String? _validateDate(DateTime? date, String fieldName) {
    if (date == null) {
      return 'La fecha de $fieldName es obligatoria';
    }
    return null;
  }

  // Validator for period start and end dates to ensure end date is not before start date
  String? _validatePeriodDates(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return null; // Individual date validation handles nulls
    }
    if (endDate.isBefore(startDate)) {
      return 'La fecha de fin del período no puede ser anterior a la de inicio';
    }
    return null;
  }

  // Validator for dropdown selections
  String? _validateDropdown<T>(T? value, String fieldName) {
    if (value == null) {
      return 'Debe seleccionar un $fieldName';
    }
    return null;
  }

  // --- Logic to generate and save the invoice and its PDF ---
  Future<void> _generateAndSaveInvoice() async {
    final String? firebaseUrl = dotenv.env['FIREBASE_API'];

    // Validate the entire form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, corrija los errores del formulario.'),
        ),
      );
      return;
    }

    // Calculate final amounts based on current text field values
    final double baseRentValue =
        double.tryParse(_baseRentController.text) ?? 0.0;
    final double additionalChargesAmountValue =
        double.tryParse(_additionalChargesAmountController.text) ?? 0.0;
    final double subtotalValue = baseRentValue + additionalChargesAmountValue;
    const double ivaRateValue = 0.16; // Fixed IVA rate
    final double ivaAmountValue = subtotalValue * ivaRateValue;
    final double totalAmountValue = subtotalValue + ivaAmountValue;

    // Create the Invoice object from form data
    try {
      final Invoice newInvoice = Invoice(
        id: widget.invoice?.id, // Preserve ID if in edit mode
        invoiceNumber:
            'RC-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}',
        issueDate: _selectedIssueDate,
        periodStartDate: _selectedPeriodStartDate,
        periodEndDate: _selectedPeriodEndDate,
        property:
            _selectedContract?.property, // Get Property from selected Contract
        tenant: _selectedContract?.tenant, // Get Tenant from selected Contract
        baseRent: baseRentValue,
        additionalChargesDescription:
            _additionalChargesDescriptionController.text,
        additionalChargesAmount: additionalChargesAmountValue,
        subtotal: subtotalValue,
        ivaRate: ivaRateValue,
        ivaAmount: ivaAmountValue,
        totalAmount: totalAmountValue,
        notes: _notesController.text,
        paymentStatus:
            widget.invoice?.paymentStatus ??
            'Pendiente', // Keep existing status or default
        // contractCreatorFullName is not part of Invoice model, passed separately to mapper
      );

      final Map<String, dynamic> invoiceData = {
        "invoiceNumber": newInvoice.invoiceNumber,
        "issueDate": DateFormat(
          'dd \'de\' MMMM \'de\' yyyy',
          'es',
        ).format(newInvoice.issueDate!),
        "periodStartDate": DateFormat(
          'dd \'de\' MMMM \'de\' yyyy',
          'es',
        ).format(newInvoice.periodStartDate!),
        "periodEndDate": DateFormat(
          'dd \'de\' MMMM \'de\' yyyy',
          'es',
        ).format(newInvoice.periodEndDate!),
        "baseRent": '\$${newInvoice.baseRent}',
        "additionalChargesDescription": newInvoice.additionalChargesDescription,
        "additionalChargesAmount": '\$${newInvoice.additionalChargesAmount}',
        "subtotal": '\$${newInvoice.subtotal}',
        "ivaRate": '\$${newInvoice.ivaRate}',
        "ivaAmount": '\$${newInvoice.ivaAmount}',
        "totalAmount": '\$${newInvoice.totalAmount}',
        "notes": newInvoice.notes,
        "aditionalChargesAmount": newInvoice.additionalChargesAmount,
        "propertyName": newInvoice.property!.name,
        "propertyAddress":
            '${newInvoice.property!.street}, ${newInvoice.property!.extNumber}, ${newInvoice.property!.borough}, ${newInvoice.property!.city}, ${newInvoice.property!.state}, ${newInvoice.property!.zipCode}"',
        "tenantFullName": newInvoice.tenant!.fullName,
        "tenantEmail": newInvoice.tenant!.email,
        "tenantPhone": newInvoice.tenant!.phone,
        "contractCreatorFullName": _selectedContract!.contractCreatorFullName,
      };

      final response = await http.post(
        Uri.parse('$firebaseUrl/invoices'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'data': invoiceData}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final String? downloadUrl = responseBody['downloadUrl'];

        if (downloadUrl != null && downloadUrl.isNotEmpty) {
          newInvoice.invoiceUrl = downloadUrl;

          BlocProvider.of<InvoiceBloc>(
            context,
          ).add(AddInvoice(invoice: newInvoice));

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Recibo generado exitosamente')),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al generar el recibo: $e')));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.invoice == null ? 'Generar Recibo' : 'Editar Recibo',
        ),
      ),
      // MultiBlocListener to listen for states from different Blocs
      body: MultiBlocListener(
        listeners: [
          // Listener for ContractBloc to handle errors or initial loading
          BlocListener<ContractBloc, ContractState>(
            listener: (context, state) {
              if (state is ContractError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error cargando contratos: ${state.message}'),
                  ),
                );
              } else if (state is ContractLoaded &&
                  widget.invoice != null &&
                  _selectedContract == null) {
                // In edit mode, if contracts are loaded and no contract is yet selected,
                // try to find the contract associated with the existing invoice.
                final foundContract = state.contracts.firstWhereOrNull(
                  (c) =>
                      c.property?.id == widget.invoice!.property?.id &&
                      c.tenant?.id == widget.invoice!.tenant?.id,
                );
                if (foundContract != null) {
                  setState(() {
                    _selectedContract = foundContract;
                    // Pre-fill form fields from the found contract if they are empty
                    if (_baseRentController.text.isEmpty) {
                      _baseRentController.text = foundContract.rentalCost ?? '';
                    }
                    if (_periodStartDateController.text.isEmpty &&
                        foundContract.contractStartDate != null) {
                      _selectedPeriodStartDate =
                          foundContract.contractStartDate;
                      _periodStartDateController.text = DateFormat(
                        'dd/MM/yyyy',
                      ).format(_selectedPeriodStartDate!);
                    }
                    if (_periodEndDateController.text.isEmpty &&
                        foundContract.contractEndDate != null) {
                      _selectedPeriodEndDate = foundContract.contractEndDate;
                      _periodEndDateController.text = DateFormat(
                        'dd/MM/yyyy',
                      ).format(_selectedPeriodEndDate!);
                    }
                  });
                }
              }
            },
          ),
          // Listener for InvoiceBloc to handle errors during invoice operations
          BlocListener<InvoiceBloc, InvoiceState>(
            listener: (context, state) {
              if (state is InvoiceError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error en el recibo: ${state.message}'),
                  ),
                );
              }
              // Additional specific feedback for InvoiceCreated, InvoiceUpdatedEvent, etc., can be added here
              // The _generateAndSaveInvoice() method already handles the success/failure of PDF generation and navigation.
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contract Selector Dropdown
                  _buildContractSelector(),
                  const SizedBox(height: 16),

                  // Invoice Number Text Field
                  /*TextFormField(
                    controller: _invoiceNumberController,
                    decoration: InputDecoration(
                      labelText: 'Número de Recibo',
                      border: const OutlineInputBorder(),
                    ),
                    validator:
                        (value) => _validateRequired(value, 'Número de Recibo'),
                  ),
                  const SizedBox(height: 16),*/

                  // Issue Date Field
                  _buildDateField(
                    context,
                    controller: _issueDateController,
                    labelText: 'Fecha de Emisión',
                    selectedDate: _selectedIssueDate,
                    onDateSelected: (pickedDate) {
                      setState(() {
                        _selectedIssueDate = pickedDate;
                      });
                    },
                    validator:
                        (value) => _validateDate(_selectedIssueDate, 'Emisión'),
                  ),
                  const SizedBox(height: 16),

                  // Period Start Date Field
                  _buildDateField(
                    context,
                    controller: _periodStartDateController,
                    labelText: 'Período: Fecha de Inicio',
                    selectedDate: _selectedPeriodStartDate,
                    onDateSelected: (pickedDate) {
                      setState(() {
                        _selectedPeriodStartDate = pickedDate;
                      });
                    },
                    validator:
                        (value) => _validateDate(
                          _selectedPeriodStartDate,
                          'Inicio del Período',
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Period End Date Field
                  _buildDateField(
                    context,
                    controller: _periodEndDateController,
                    labelText: 'Período: Fecha de Fin',
                    selectedDate: _selectedPeriodEndDate,
                    onDateSelected: (pickedDate) {
                      setState(() {
                        _selectedPeriodEndDate = pickedDate;
                      });
                    },
                    validator: (value) {
                      final dateError = _validateDate(
                        _selectedPeriodEndDate,
                        'Fin del Período',
                      );
                      if (dateError != null) return dateError;
                      return _validatePeriodDates(
                        _selectedPeriodStartDate,
                        _selectedPeriodEndDate,
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Base Rent Amount Text Field
                  TextFormField(
                    controller: _baseRentController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Monto del Alquiler Base',
                      prefixText: '\$',
                      border: const OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            _validateNumber(value, 'Monto del Alquiler Base'),
                  ),
                  const SizedBox(height: 16),

                  // Additional Charges Description Text Field
                  TextFormField(
                    controller: _additionalChargesDescriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción de Cargos Adicionales (Opcional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Additional Charges Amount Text Field
                  TextFormField(
                    controller: _additionalChargesAmountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Monto de Cargos Adicionales (Opcional)',
                      prefixText: '\$',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return _validateNumber(
                          value,
                          'Monto de Cargos Adicionales',
                        );
                      }
                      return null; // Optional field, no validation needed if empty
                    },
                  ),
                  const SizedBox(height: 24),

                  // Invoice Summary (Calculated locally)
                  Text(
                    'Resumen del Recibo',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Alquiler Base: \$${(double.tryParse(_baseRentController.text) ?? 0.0).toStringAsFixed(2)}',
                  ),
                  Text(
                    'Cargos Adicionales: \$${(double.tryParse(_additionalChargesAmountController.text) ?? 0.0).toStringAsFixed(2)}',
                  ),
                  Text(
                    'Subtotal: \$${((double.tryParse(_baseRentController.text) ?? 0.0) + (double.tryParse(_additionalChargesAmountController.text) ?? 0.0)).toStringAsFixed(2)}',
                  ),
                  Text(
                    'IVA (16%): \$${(((double.tryParse(_baseRentController.text) ?? 0.0) + (double.tryParse(_additionalChargesAmountController.text) ?? 0.0)) * 0.16).toStringAsFixed(2)}',
                  ),
                  Text(
                    'Total: \$${(((double.tryParse(_baseRentController.text) ?? 0.0) + (double.tryParse(_additionalChargesAmountController.text) ?? 0.0)) * 1.16).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Notes Text Field
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notas (Opcional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save and Generate PDF Button
                  Center(
                    child: BlocBuilder<InvoiceBloc, InvoiceState>(
                      builder: (context, state) {
                        // Determine if the button should be disabled (e.g., during submission or PDF generation)
                        final bool isSubmitting = state is InvoiceLoading;
                        return ElevatedButton(
                          onPressed:
                              isSubmitting ? null : _generateAndSaveInvoice,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child:
                              isSubmitting
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : Text(
                                    widget.invoice == null
                                        ? 'Generar y Guardar Recibo'
                                        : 'Guardar Cambios y Generar PDF',
                                  ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ), // Extra space at the bottom for FAB
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Methods for Form Fields ---

  // Reusable widget for date input fields with a date picker
  Widget _buildDateField(
    BuildContext context, {
    required TextEditingController controller,
    required String labelText,
    required DateTime? selectedDate,
    required ValueChanged<DateTime?> onDateSelected,
    String? Function(String?)? validator, // Optional validator function
  }) {
    return TextFormField(
      controller: controller,
      readOnly:
          true, // Make the text field read-only as date is picked from dialog
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.calendar_today),
        suffixIcon:
            selectedDate != null
                ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                  ), // Clear button if date is selected
                  onPressed: () {
                    onDateSelected(null); // Clear selected date in state
                    controller.clear(); // Clear text field
                  },
                )
                : null,
      ),
      onTap: () async {
        // Show the custom date picker dialog
        await showCustomDatePicker(
          context,
          controller, // showCustomDatePicker handles updating the controller's text
          initialDate: selectedDate ?? DateTime.now(),
          helpText: 'Seleccione $labelText',
          fieldLabelText: labelText,
          onDateSelected: (pickedDate) {
            onDateSelected(pickedDate); // Update the local state variable
          },
        );
      },
      validator: validator, // Apply the provided validator
    );
  }

  // Widget for the Contract selection dropdown
  Widget _buildContractSelector() {
    return BlocBuilder<ContractBloc, ContractState>(
      builder: (context, state) {
        List<Contract> contracts = [];
        bool isLoading = false;
        String? errorMessage;

        if (state is ContractLoading) {
          isLoading = true;
        } else if (state is ContractLoaded) {
          contracts = state.contracts;
          // Synchronize _selectedContract if in edit mode and not yet set
          _widgetsBindingInstance?.addPostFrameCallback((_) {
            if (widget.invoice != null && _selectedContract == null) {
              // Try to find the contract that matches the property and tenant of the existing invoice
              final foundContract = contracts.firstWhereOrNull(
                (c) =>
                    c.property?.id == widget.invoice!.property?.id &&
                    c.tenant?.id == widget.invoice!.tenant?.id,
              );
              if (foundContract != null) {
                setState(() {
                  _selectedContract = foundContract;
                  // Pre-fill relevant form fields from the selected contract
                  if (_baseRentController.text.isEmpty) {
                    _baseRentController.text = foundContract.rentalCost ?? '';
                  }
                  if (_periodStartDateController.text.isEmpty &&
                      foundContract.contractStartDate != null) {
                    _selectedPeriodStartDate = foundContract.contractStartDate;
                    _periodStartDateController.text = DateFormat(
                      'dd/MM/yyyy',
                    ).format(_selectedPeriodStartDate!);
                  }
                  if (_periodEndDateController.text.isEmpty &&
                      foundContract.contractEndDate != null) {
                    _selectedPeriodEndDate = foundContract.contractEndDate;
                    _periodEndDateController.text = DateFormat(
                      'dd/MM/yyyy',
                    ).format(_selectedPeriodEndDate!);
                  }
                });
              }
            } else if (_selectedContract != null &&
                !contracts.contains(_selectedContract)) {
              // If the previously selected contract no longer exists in the list, deselect it
              setState(() {
                _selectedContract = null;
                // Optionally clear related fields if the contract is deselected
                _baseRentController.clear();
                _periodStartDateController.clear();
                _periodEndDateController.clear();
                _selectedPeriodStartDate = null;
                _selectedPeriodEndDate = null;
              });
            }
          });
        } else if (state is ContractError) {
          errorMessage = state.message;
        }

        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<Contract>(
                value: _selectedContract,
                decoration: InputDecoration(
                  labelText: 'Selecciona un Contrato',
                  border: const OutlineInputBorder(),
                  errorText: errorMessage,
                ),
                items:
                    contracts.map((contract) {
                      return DropdownMenuItem<Contract>(
                        value: contract,
                        // Display contract details for easy identification
                        child: Text(
                          '${contract.denomination ?? 'Contrato sin denominación'} (${contract.tenant?.fullName ?? 'N/A'})',
                        ),
                      );
                    }).toList(),
                onChanged: (Contract? value) {
                  setState(() {
                    _selectedContract = value;
                    // Pre-fill form fields with data from the selected contract
                    if (value != null) {
                      _baseRentController.text = value.rentalCost ?? '';
                      _selectedPeriodStartDate = value.contractStartDate;
                      _periodStartDateController.text =
                          _selectedPeriodStartDate != null
                              ? DateFormat(
                                'dd/MM/yyyy',
                              ).format(_selectedPeriodStartDate!)
                              : '';
                      _selectedPeriodEndDate = value.contractEndDate;
                      _periodEndDateController.text =
                          _selectedPeriodEndDate != null
                              ? DateFormat(
                                'dd/MM/yyyy',
                              ).format(_selectedPeriodEndDate!)
                              : '';
                      // You can pre-fill more fields here if desired (e.g., notes, etc.)
                    } else {
                      // Clear fields if no contract is selected
                      _baseRentController.clear();
                      _periodStartDateController.clear();
                      _periodEndDateController.clear();
                      _selectedPeriodStartDate = null;
                      _selectedPeriodEndDate = null;
                    }
                  });
                },
                hint:
                    isLoading
                        ? const Text('Cargando contratos...')
                        : const Text('Selecciona un contrato'),
                validator: (value) => _validateDropdown(value, 'contrato'),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.refresh), // Refresh button for contracts
              onPressed: () {
                context.read<ContractBloc>().add(FetchContracts());
              },
            ),
            // No add button for contracts here, as the flow is to select an existing one.
            // If new contracts need to be added, it would be from a different page.
          ],
        );
      },
    );
  }
}
