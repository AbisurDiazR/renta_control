import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/invoice/invoice.dart';

abstract class InvoiceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchInvoices extends InvoiceEvent {}

class SearchInvoices extends InvoiceEvent {
  final String query;

  SearchInvoices({required this.query});

  @override
  List<Object> get props => [query];
}

class AddInvoice extends InvoiceEvent {
  final Invoice invoice;

  AddInvoice({required this.invoice});

  @override
  List<Object> get props => [invoice];
}

class InvoiceCreated extends InvoiceEvent {}

class UpdateInvoice extends InvoiceEvent {
  final Invoice invoice;

  UpdateInvoice({required this.invoice});

  @override
  List<Object> get props => [invoice];
}
