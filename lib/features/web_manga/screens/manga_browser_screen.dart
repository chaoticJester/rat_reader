import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/manga_provider.dart';
import 'manga_detail_screen.dart';

class MangaBrowserScreen extends ConsumerStatefulWidget {
  const MangaBrowserScreen({super.key});

  @override
  ConsumerState<MangaBrowserScreen> createState() =>
      _MangaBrowserScreenState();
}

class _MangaBrowserScreenState
    extends ConsumerState<MangaBrowserScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(mangaSearchProvider);
    final repository = ref.read(mangaRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manga Browser'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search manga...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(mangaSearchProvider.notifier).search('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (query) {
                ref.read(mangaSearchProvider.notifier).search(query);
              },
            ),
          ),
          Expanded(
            child: searchState.when(
              data: (mangas) {
                if (mangas.isEmpty) {
                  return const Center(
                    child: Text('Search for manga above.'),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: mangas.length,
                  itemBuilder: (context, index) {
                    final manga = mangas[index];
                    final coverUrl = repository.getCoverUrl(manga);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MangaDetailScreen(manga: manga),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: coverUrl.isEmpty
                                  ? Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      child: const Icon(
                                          Icons.auto_stories,
                                          size: 48),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: coverUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      placeholder: (context, url) =>
                                          Container(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        child: const Center(
                                          child:
                                              CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget:
                                          (context, url, error) =>
                                              const Icon(Icons.error),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            manga.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}