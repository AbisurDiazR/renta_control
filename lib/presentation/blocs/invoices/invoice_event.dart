import 'package:equatable/equatable.dart';
import 'package:renta_control/domain/models/invoice/invoice_request.dart';

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

class CreateInvoice extends InvoiceEvent {
  final InvoiceRequest invoiceRequest;

  CreateInvoice({required this.invoiceRequest});

  @override
  List<Object> get props => [invoiceRequest];
}

class InvoiceCreated extends InvoiceEvent {}

class DownloadInvoiceFile extends InvoiceEvent {
  final String invoiceId;
  final String fileType; // 'pdf', 'xml' o 'zip'
  final String savePath;

  DownloadInvoiceFile({
    required this.invoiceId,
    required this.fileType,
    required this.savePath,
  });
}
