import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/web_manga.dart';
import '../providers/manga_provider.dart';

final _chapterImagesProvider =
    FutureProvider.family<List<String>, String>((ref, chapterId) {
  final repository = ref.read(mangaRepositoryProvider);
  return repository.getChapterImages(chapterId);
});

class MangaReaderScreen extends ConsumerWidget {
  final Chapter chapter;

  const MangaReaderScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagesState = ref.watch(_chapterImagesProvider(chapter.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(chapter.displayTitle),
      ),
      body: imagesState.when(
        data: (images) {
          if (images.isEmpty) {
            return const Center(child: Text('No pages found.'));
          }
          return ListView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Container(
                  height: 400,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 400,
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: const Center(
                    child: Icon(Icons.error),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}