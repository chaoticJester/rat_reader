import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/manga_provider.dart';
import '../../../data/models/web_manga.dart';
import 'manga_reader_screen.dart';

class MangaDetailScreen extends ConsumerWidget {
  final WebManga manga;

  const MangaDetailScreen({super.key, required this.manga});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersState = ref.watch(chapterListProvider(manga.id));
    final repository = ref.read(mangaRepositoryProvider);
    final coverUrl = repository.getCoverUrl(manga);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                manga.title,
                style: const TextStyle(fontSize: 14),
              ),
              background: coverUrl.isEmpty
                  ? Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    )
                  : CachedNetworkImage(
                      imageUrl: coverUrl,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (manga.description != null) ...[
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(manga.description!),
                    const SizedBox(height: 16),
                  ],
                  if (manga.tags.isNotEmpty) ...[
                    const Text(
                      'Tags',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: manga.tags
                          .map((tag) => Chip(label: Text(tag)))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Text(
                    'Chapters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          chaptersState.when(
            data: (chapters) {
              if (chapters.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No English chapters available.'),
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final chapter = chapters[index];
                    return ListTile(
                      title: Text(chapter.displayTitle),
                      subtitle: chapter.volume != null
                          ? Text('Volume ${chapter.volume}')
                          : null,
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MangaReaderScreen(
                              chapter: chapter,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: chapters.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverToBoxAdapter(
              child: Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}