import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:renta_control/domain/models/invoice/invoice.dart';

class InvoiceRepository {
  final String _baseUrl = dotenv.env['API_URL']!;
  final String _apiKey = dotenv.env['API_KEY']!;

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
