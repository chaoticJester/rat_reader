import 'dart:typed_data';

enum BookType { pdf, epub, cbz, cbr, manga }

class Book {
  final String id;
  final String title;
  final String filePath;
  final BookType type;
  final String? coverPath;
  final Uint8List? fileBytes;
  final int currentPage;
  final int totalPages;
  final DateTime lastRead;

  Book({
    required this.id,
    required this.title,
    required this.filePath,
    required this.type,
    this.coverPath,
    this.fileBytes,
    this.currentPage = 0,
    this.totalPages = 0,
    required this.lastRead,
  });
}