import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/invoice/invoice.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_event.dart';

abstract class InvoiceState extends Equatable {
  @override
  List<Object> get props => [];
}

class InvoiceInitial extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class InvoiceLoaded extends InvoiceState {
  final List<Invoice> invoices;

  InvoiceLoaded({required this.invoices});

  @override
  List<Object> get props => [invoices];
}

class InvoiceError extends InvoiceState {
  final String message;

  InvoiceError({required this.message});

  @override
  List<Object> get props => [message];
}

class InvoicesUpdated extends InvoiceEvent {
  final List<Invoice> invoices;

  InvoicesUpdated({required this.invoices});

  @override
  List<Object> get props => [invoices];
}

// Estados de descarga de factura
class InvoiceDownloadInProgress extends InvoiceState {}

class InvoiceDownloadSuccess extends InvoiceState {
  final String filePath;

  InvoiceDownloadSuccess({required this.filePath});
}

class InvoiceDownloadFailure extends InvoiceState {
  final String error;

  InvoiceDownloadFailure({required this.error});
}
