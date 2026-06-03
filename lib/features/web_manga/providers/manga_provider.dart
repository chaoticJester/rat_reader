import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/web_manga.dart';
import '../../../data/repositories/manga_repository.dart';

final mangaRepositoryProvider = Provider<MangaRepository>((ref) {
  return MangaRepository();
});

final mangaSearchProvider =
    AsyncNotifierProvider<MangaSearchNotifier, List<WebManga>>(
        MangaSearchNotifier.new);

class MangaSearchNotifier extends AsyncNotifier<List<WebManga>> {
  @override
  Future<List<WebManga>> build() async {
    return [];
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() {
      final repository = ref.read(mangaRepositoryProvider);
      return repository.searchManga(query);
    });
  }
}

final chapterListProvider =
    FutureProvider.family<List<Chapter>, String>((ref, mangaId) {
  final repository = ref.read(mangaRepositoryProvider);
  return repository.getChapters(mangaId);
});