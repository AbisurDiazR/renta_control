import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:renta_control/domain/models/invoice/invoice.dart';
import 'package:renta_control/domain/models/invoice/invoice_request.dart';

class InvoiceRepository {
  final String _baseUrl = dotenv.env['API_URL']!;
  final String _apiKey = dotenv.env['API_KEY']!;

  Future<void> createInvoice(InvoiceRequest invoiceRequest) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(invoiceRequest.toJson()),
      );
      if (response.statusCode == 200) {
        print('Factura creada exitosamente');
        fetchInvoices();
      } else {
        // Error en la creación
        print('Error al crear la factura: ${response.body}');
        throw Exception('Error al crear la factura: ${response.body}');
      }
    } catch (e) {
      // Error al conectar con el servidor
      print('Ocurrió un error al conectar con el servidor: $e');
      throw Exception('Ocurrió un error al conectar con el servidor: $e');
    }
  }

  Stream<List<Invoice>> fetchInvoices() {
    return Stream.fromFuture(
      http
          .get(
            Uri.parse(_baseUrl),
            headers: {'Authorization': 'Bearer $_apiKey'},
          )
          .then((response) {
            if (response.statusCode == 200) {
              final List data = jsonDecode(response.body)['data'];
              return data.map((json) => Invoice.fromJson(json)).toList();
            } else {
              throw Exception('Error al cargar facturas');
            }
          }),
    );
  }
}
