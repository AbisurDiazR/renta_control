import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:renta_control/domain/models/invoice/invoice.dart';
import 'package:renta_control/domain/models/invoice/invoice_request.dart';

class InvoiceRepository {
  final String _baseUrl = dotenv.env['API_URL']!;
  final String _apiKey = dotenv.env['API_KEY']!;
  final StreamController<List<Invoice>> _invoiceController =
      StreamController.broadcast();

  Stream<List<Invoice>> get invoicesStream => _invoiceController.stream;

  Future<void> fetchInvoices() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        final invoices = data.map((json) => Invoice.fromJson(json)).toList();
        _invoiceController.add(invoices);
      } else {
        throw Exception('Error al cargar facturas');
      }
    } catch (e) {
      _invoiceController.addError(e);
    }
  }

  Future<void> createInvoice(InvoiceRequest invoiceRequest) async {
    final url = Uri.parse(_baseUrl);
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(invoiceRequest.toJson()),
      );

      if (response.statusCode == 200) {
        // Factura creada con éxito, refrescar la lista
        await fetchInvoices();
      } else {
        print("Error al crear factura: ${response.body}");
        throw Exception('Error al crear la factura: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ocurrió un error al conectar con el servidor: $e');
    }
  }

  void dispose() {
    _invoiceController.close();
  }

  Future<void> downloadInvoiceFile({
    required String invoiceId,
    required String fileType, // 'pdf', 'xml' o 'zip'
    required String savePath,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/$invoiceId/$fileType',
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $_apiKey'},
    );

    if (response.statusCode == 200) {
      final file = File(savePath);
      await file.writeAsBytes(response.bodyBytes);
      await fetchInvoices();
      print('Archivo guardado en: $savePath');
    } else {
      throw Exception('Error al descargar el archivo: ${response.statusCode}');
    }
  }
}
