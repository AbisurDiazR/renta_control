// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io'; // Para manejar archivos temporales si es necesario
import 'package:path_provider/path_provider.dart'; // Para obtener directorios temporales
import 'package:http/http.dart' as http; // Para descargar el PDF

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerPage({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localPath;
  bool isLoading = true;
  String errorMessage = '';
  PDFViewController? _pdfViewController;
  int? pages = 0;
  int? currentPage = 0;

  @override
  void initState() {
    super.initState();
    _downloadPdfAndLoad();
  }

  Future<void> _downloadPdfAndLoad() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/temp_contract.pdf');
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          localPath = file.path;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load PDF: HTTP ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error downloading PDF: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visor de Contrato PDF')),
      body:
          isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage.isNotEmpty
                          ? errorMessage
                          : 'Cargando PDF...',
                    ),
                  ],
                ),
              )
              : localPath != null
              ? PDFView(
                filePath: localPath,
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                pageFling: false,
                onRender: (_pages) {
                  setState(() {
                    pages = _pages;
                    // isReady = true; // No necesitas un isReady aparte de isLoading
                  });
                },
                onError: (error) {
                  setState(() {
                    errorMessage = error.toString();
                  });
                },
                onPageError: (page, error) {
                  setState(() {
                    errorMessage = '$page: ${error.toString()}';
                  });
                },
                onViewCreated: (PDFViewController pdfViewController) {
                  _pdfViewController = pdfViewController;
                },
                onPageChanged: (int? page, int? total) {
                  setState(() {
                    currentPage = page;
                  });
                },
              )
              : Center(
                child: Text(
                  errorMessage.isNotEmpty
                      ? errorMessage
                      : 'No se pudo cargar el PDF.',
                ),
              ),
      floatingActionButton:
          localPath != null && pages! > 0
              ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (currentPage! > 0)
                    FloatingActionButton.extended(
                      heroTag: 'prev',
                      onPressed: () {
                        _pdfViewController?.setPage(currentPage! - 1);
                      },
                      label: const Text('Anterior'),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  const SizedBox(width: 10),
                  FloatingActionButton.extended(
                    heroTag: 'next',
                    onPressed: () {
                      if (currentPage! < pages! - 1) {
                        _pdfViewController?.setPage(currentPage! + 1);
                      }
                    },
                    label: const Text('Siguiente'),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              )
              : null,
    );
  }
}
