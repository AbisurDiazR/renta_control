// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:renta_control/data/repositories/invoice/invoice_repository.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_bloc.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_event.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_state.dart';
import 'package:intl/intl.dart';

class InvoicesPage extends StatelessWidget {
  const InvoicesPage({super.key});

  Future<bool> _requestStoragePermission() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<String?> _getDownloadPath() async {
    try {
      return await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOAD,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => InvoiceBloc(
            repository: RepositoryProvider.of<InvoiceRepository>(context),
          )..add(FetchInvoices()),
      child: BlocListener<InvoiceBloc, InvoiceState>(
        listener: (context, state) {
          if (state is InvoiceDownloadSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Factura guardada en: ${state.filePath}')),
            );
          } else if (state is InvoiceDownloadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al descargar factura: ${state.error}'),
              ),
            );
          }
        },
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fecha: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(invoice.createdAt))}',
                              ),
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
                          onTap: () async {
                            final selectedFormat = await showDialog<String>(
                              context: context,
                              builder:
                                  (context) => SimpleDialog(
                                    title: const Text(
                                      'Descargar factura como...',
                                    ),
                                    children: [
                                      SimpleDialogOption(
                                        onPressed:
                                            () => Navigator.pop(context, 'pdf'),
                                        child: const Text('PDF'),
                                      ),
                                      SimpleDialogOption(
                                        onPressed:
                                            () => Navigator.pop(context, 'xml'),
                                        child: const Text('XML'),
                                      ),
                                      SimpleDialogOption(
                                        onPressed:
                                            () => Navigator.pop(context, 'zip'),
                                        child: const Text('ZIP'),
                                      ),
                                    ],
                                  ),
                            );

                            if (selectedFormat != null) {
                              final hasPermission =
                                  await _requestStoragePermission();
                              if (!hasPermission) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Permiso de almacenamiento denegado.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final downloadPath = await _getDownloadPath();
                              if (downloadPath == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'No se pudo obtener la ruta de Descargas.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final filePath =
                                  '$downloadPath/factura_${invoice.id}.$selectedFormat';

                              context.read<InvoiceBloc>().add(
                                DownloadInvoiceFile(
                                  invoiceId: invoice.id,
                                  fileType: selectedFormat,
                                  savePath: filePath,
                                ),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Descargando ${selectedFormat.toUpperCase()}...',
                                  ),
                                ),
                              );
                            }
                          },
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
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (query) {
        context.read<InvoiceBloc>().add(SearchInvoices(query: query));
      },
    );
  }
}
