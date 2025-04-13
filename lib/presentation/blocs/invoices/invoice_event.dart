import 'package:equatable/equatable.dart';

abstract class InvoiceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchInvoices extends InvoiceEvent{}

class SearchInvoices extends InvoiceEvent{
  final String query;

  SearchInvoices({required this.query});

  @override
  List<Object> get props => [query];
}