import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../providers/library_provider.dart';
import '../widgets/book_card.dart';
import '../../../data/models/book.dart';
import '../../pdf_reader/screens/pdf_reader_screen.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  Future<void> _pickFile(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'epub', 'cbz'],
      withData: true, 
    );

    if (result == null) return;

    final file = result.files.single;
    final extension = file.extension?.toLowerCase();

    BookType type;
    switch (extension) {
      case 'pdf':
        type = BookType.pdf;
        break;
      case 'epub':
        type = BookType.epub;
        break;
      case 'cbz':
        type = BookType.cbz;
        break;
      default:
        return;
    }

    final path = kIsWeb ? file.name : (file.path ?? file.name);
    
    final book = Book(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: file.name.replaceAll('.$extension', ''),
      filePath: path,
      type: type,
      lastRead: DateTime.now(),
    );

    ref.read(libraryProvider.notifier).addBook(book);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(libraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
      ),
      body: books.isEmpty
          ? const Center(
              child: Text(
                'No books yet.\nTap + to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.55,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                
                return BookCard(
                  book: book,
                  onTap: () {
                    // Route based on the book type
                    if (book.type == BookType.pdf) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfReaderScreen(book: book),
                        ),
                      );
                    } else {
                      // Temporary placeholder for EPUB/CBZ until you build those screens
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${book.type.name.toUpperCase()} reader not implemented yet.'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _pickFile(ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}