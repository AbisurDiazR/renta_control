// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:renta_control/data/repositories/invoice/invoice_repository.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_bloc.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_event.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_state.dart';
import 'package:renta_control/utils/components/pdf_viewer_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
          Padding(padding: EdgeInsets.all(8.0), child: InvoiceSearchBar()),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 80.0),
              child: BlocBuilder<InvoiceBloc, InvoiceState>(
                builder: (context, state) {
                  if (state is InvoiceLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is InvoiceLoaded) {
                    return ListView.builder(
                      itemCount: state.invoices.length,
                      itemBuilder: (context, index) {
                        final invoice = state.invoices[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.receipt,
                              color: Colors.blueAccent,
                              size: 36.0,
                            ),
                            title: Text(
                              invoice.invoiceNumber ?? 'Recibo sin número',
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Inquilino: ${invoice.tenant?.fullName ?? 'N/A'}',
                                ),
                                Text(
                                  'Propiedad: ${invoice.property?.name ?? 'N/A'}',
                                ),
                                Text(
                                  'Total: \$${invoice.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                                ),
                                Text(
                                  'Período: ${invoice.periodStartDate != null && invoice.periodEndDate != null ? '${DateFormat('dd/MM/yyyy').format(invoice.periodStartDate!)} - ${DateFormat('dd/MM/yyyy').format(invoice.periodEndDate!)}' : 'N/A'}',
                                ),
                              ],
                            ),
                            trailing: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Botón para ver PDF
                                  IconButton(
                                    icon: const Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.red,
                                      size: 30, // Adjusted size
                                    ),
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => PdfViewerPage(
                                                pdfUrl: invoice.invoiceUrl!,
                                              ),
                                        ),
                                      );
                                    }, // Disable if no URL
                                  ),
                                  // Botón para descargar PDF
                                  IconButton(
                                    icon: const Icon(
                                      Icons.download,
                                      color: Colors.blue,
                                      size: 30, // Adjusted size
                                    ),
                                    onPressed: () async {
                                      final Uri uri = Uri.parse(
                                        invoice.invoiceUrl ?? '',
                                      );
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'No se pudo abrir el pdf',
                                            ),
                                          ),
                                        );
                                      }
                                    }, // Disable if no URL
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is InvoiceError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: Text('No hay recibos disponibles'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InvoiceSearchBar extends StatelessWidget {
  const InvoiceSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar facturas...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (query) {
        if (query.isEmpty) {
          context.read<InvoiceBloc>().add(FetchInvoices());
        } else {
          context.read<InvoiceBloc>().add(SearchInvoices(query: query));
        }
      },
    );
  }
}
