import 'package:flutter/material.dart';
import '../../../data/models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  IconData _getIcon(BookType type) {
    switch (type) {
      case BookType.pdf:
        return Icons.picture_as_pdf;
      case BookType.epub:
        return Icons.book;
      case BookType.cbz:
        return Icons.image;
      case BookType.cbr:
        return Icons.image;
      case BookType.manga:
        return Icons.auto_stories;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          // 1. The Book Cover (The Card)
          Expanded(
            child: SizedBox(
              width: double.infinity, 
              child: Card(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.zero, 
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Center(
                    child: Icon(
                      _getIcon(book.type),
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 2. Spacing between cover and title
          const SizedBox(height: 8),
          
          // 3. The Book Title (Outside the card)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0), 
            child: Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500, 
              ),
            ),
          ),
        ],
      ),
    );
  }
}