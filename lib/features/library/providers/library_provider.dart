import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/book.dart';

class LibraryNotifier extends Notifier<List<Book>> {
  @override
  List<Book> build() {
    return [];
  }

  void addBook(Book book) {
    state = [...state, book];
  }

  void removeBook(String id) {
    state = state.where((book) => book.id != id).toList();
  }
}

final libraryProvider = NotifierProvider<LibraryNotifier, List<Book>>(() {
  return LibraryNotifier();
});