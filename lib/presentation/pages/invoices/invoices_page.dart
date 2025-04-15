import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/data/repositories/invoice/invoice_repository.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_bloc.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_event.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_state.dart';
import 'package:intl/intl.dart';


class InvoicesPage extends StatelessWidget {
  const InvoicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => InvoiceBloc(
            repository: RepositoryProvider.of<InvoiceRepository>(context),
          )..add(FetchInvoices()),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(8.0), child: SearchBar()),
          Expanded(
            child: BlocBuilder<InvoiceBloc, InvoiceState>(
              builder: (context, state) {
                if (state is InvoiceLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is InvoiceLoaded) {
                  return ListView.builder(
                    itemCount: state.invoices.length,
                    itemBuilder: (context, index) {
                      final invoice = state.invoices[index];
                      return ListTile(
                        title: Text(
                          invoice.customerName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(invoice.createdAt))}'),
                            Text(
                              'Total: \$${invoice.total.toStringAsFixed(2)}',
                            ),
                            Text(
                              'Estatus: ${invoice.status}',
                              style: TextStyle(
                                color:
                                    invoice.status == 'valid'
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {},
                      );
                    },
                  );
                } else if (state is InvoiceError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(child: Text('No hay facturas disponibles'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar facturas...',
        border: OutlineInputBorder(),
        prefix: Icon(Icons.search),
      ),
      onChanged: (query) {
        context.read<InvoiceBloc>().add(SearchInvoices(query: query));
      },
    );
  }
}
