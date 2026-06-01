
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:epub_view/epub_view.dart';
import 'dart:io';
import '../../../data/models/book.dart';

class EpubReaderScreen extends StatefulWidget {
  final Book book;

  const EpubReaderScreen({super.key, required this.book});

  @override
  State<EpubReaderScreen> createState() => _EpubReaderScreenState();
}

class _EpubReaderScreenState extends State<EpubReaderScreen> {
  late EpubController _epubController;

  @override
  void initState() {
    super.initState();
    _epubController = EpubController(
      document: kIsWeb
          ? EpubDocument.openData(widget.book.fileBytes!)
          : EpubDocument.openFile(File(widget.book.filePath)),
    );
  }

  @override
  void dispose() {
    _epubController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: EpubViewActualChapter(
          controller: _epubController,
          builder: (chapterValue) => Text(
            chapterValue?.chapter?.Title ?? widget.book.title,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      body: EpubView(
        controller: _epubController,
      ),
    );
  }
}