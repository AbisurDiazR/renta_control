// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_bloc.dart';
import 'package:renta_control/presentation/blocs/invoices/invoice_event.dart';

class InvoicesPage extends StatelessWidget {
  const InvoicesPage({super.key});

  /*Future<bool> _requestStoragePermission() async {
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
  }*/

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
      'No hay contenido disponible',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
