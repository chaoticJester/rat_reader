import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pdfx/pdfx.dart';
import '../../../data/models/book.dart';

class PdfReaderScreen extends StatefulWidget {
  final Book book;

  const PdfReaderScreen({super.key, required this.book});

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  late PdfControllerPinch _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfControllerPinch(
      document: kIsWeb
          ? PdfDocument.openData(Future.value(Uint8List(0)))
          : PdfDocument.openFile(widget.book.filePath),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: PdfViewPinch(
        controller: _pdfController,
      ),
    );
  }
}