import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/invoice/invoice_repository.dart';
import 'package:renta_control/domain/models/invoice/invoice.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_event.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceRepository repository;
  StreamSubscription<List<Invoice>>? _invoiceSubscription;

  InvoiceBloc({required this.repository}) : super(InvoiceInitial()) {
    on<FetchInvoices>(_onFetchInvoices);
    on<InvoicesUpdated>(_onInvoicesUpdated);
    on<AddInvoice>(_onAddInvoice);
    on<UpdateInvoice>(_onUpdateInvoice);
    on<SearchInvoices>(_onSearchInvoices);
  }

  Future<void> _onFetchInvoices(
    FetchInvoices event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(InvoiceLoading());
    await _invoiceSubscription?.cancel();
    _invoiceSubscription = repository.fetchInvoices().listen(
      (invoices) {
        add(InvoicesUpdated(invoices: invoices));
      },
      onError: (error) {
        emit(InvoiceError(message: 'Error al cargar recibos: $error'));
      },
    );
  }

  Future<void> _onInvoicesUpdated(
    InvoicesUpdated event,
    Emitter<InvoiceState> emit,
  ) async {
    List<Invoice> filteredInvoices = event.invoices;
    emit(InvoiceLoaded(invoices: filteredInvoices));
  }

  Future<void> _onAddInvoice(
    AddInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      await repository.addInvoice(event.invoice);
    } catch (e) {
      emit(InvoiceError(message: "Error al crear el contrato: $e"));
    }
  }

  Future<void> _onUpdateInvoice(
    UpdateInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      await repository.updateInvoice(event.invoice);
    } catch (e) {
      emit(InvoiceError(message: "Error al actualizar el recibo"));
    }
  }

  Future<void> _onSearchInvoices(
    SearchInvoices event,
    Emitter<InvoiceState> emit,
  ) async {
    if (state is InvoiceLoaded) {
      final currenState = state as InvoiceLoaded;
      final query = event.query.toLowerCase();
      final filteredInvoices =
          currenState.invoices.where((invoice) {
            return invoice.invoiceNumber.toString().toLowerCase().contains(
                  query,
                ) ||
                invoice.property!.name.toLowerCase().contains(query) ||
                invoice.tenant!.fullName.toLowerCase().contains(query);
          }).toList();
      emit(InvoiceLoaded(invoices: filteredInvoices));
    }
  }
}
