import 'package:flutter/material.dart';
import '../../../data/models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  IconData _getIcon(BookType type) {
    switch (type) {
      case BookType.pdf:
        return Icons.picture_as_pdf;
      case BookType.epub:
        return Icons.book;
      case BookType.cbz:
        return Icons.image;
      case BookType.manga:
        return Icons.auto_stories;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                _getIcon(book.type),
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
  
}