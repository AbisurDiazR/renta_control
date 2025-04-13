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
    on<SearchInvoices>(_onIvoicesSearch);
  }

  FutureOr<void> _onFetchInvoices(
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
        emit(InvoiceError(message: 'Error al cargar facturas: $error'));
      },
    );
  }

  FutureOr<void> _onInvoicesUpdated(
    InvoicesUpdated event,
    Emitter<InvoiceState> emit,
  ) {
    List<Invoice> filteredInvoices = event.invoices;
    emit(InvoiceLoaded(invoices: filteredInvoices));
  }

  FutureOr<void> _onIvoicesSearch(
    SearchInvoices event,
    Emitter<InvoiceState> emit,
  ) {
    if (state is InvoiceLoaded) {
      final currentState = state as InvoiceLoaded;
      final query = event.query.toLowerCase();
      final filteredInvoices = currentState.invoices.where((invoice) {
        return invoice.customerName.toLowerCase().contains(query);
      }).toList();
      emit(InvoiceLoaded(invoices: filteredInvoices));
    }
  }

  @override
  Future<void> close(){
    _invoiceSubscription?.cancel();
    return super.close();
  }
}
