import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'dart:io';
import '../../../data/models/book.dart';

class CbzReaderScreen extends StatefulWidget {
  final Book book;

  const CbzReaderScreen({super.key, required this.book});

  @override
  State<CbzReaderScreen> createState() => _CbzReaderScreenState();
}

class _CbzReaderScreenState extends State<CbzReaderScreen> {
  List<Uint8List> _pages = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCbz();
  }

  Future<void> _loadCbz() async {
    try {
      late Archive archive;

      if (kIsWeb) {
        if (widget.book.fileBytes == null) {
          setState(() => _error = 'File bytes not available on web.');
          return;
        }
        archive = ZipDecoder().decodeBytes(widget.book.fileBytes!);
      } else {
        // On Android read directly from path without loading into memory
        final file = File(widget.book.filePath);
        final inputStream = InputFileStream(widget.book.filePath);
        archive = ZipDecoder().decodeBuffer(inputStream);
      }

      final imageFiles = archive.files
          .where((file) =>
              file.isFile &&
              (file.name.toLowerCase().endsWith('.jpg') ||
                  file.name.toLowerCase().endsWith('.jpeg') ||
                  file.name.toLowerCase().endsWith('.png') ||
                  file.name.toLowerCase().endsWith('.webp')))
          .toList();

      imageFiles.sort((a, b) => a.name.compareTo(b.name));

      final pages = imageFiles
          .map((file) => Uint8List.fromList(file.content as List<int>))
          .toList();

      setState(() {
        _pages = pages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load CBZ: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.book.title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.book.title)),
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('${_pages.length} pages'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return Image.memory(
            _pages[index],
            fit: BoxFit.fitWidth,
          );
        },
      ),
    );
  }
}