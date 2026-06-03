class WebManga {
  final String id;
  final String title;
  final String? description;
  final String? coverUrl;
  final List<String> tags;
  final String status;
  final List<dynamic>? relationships;

  WebManga({
    required this.id,
    required this.title,
    this.description,
    this.coverUrl,
    this.tags = const [],
    required this.status,
    this.relationships
  });

  factory WebManga.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>;

    final titleMap = attributes['title'] as Map<String, dynamic>;
    final title = titleMap['en'] ??
        titleMap.values.firstOrNull ??
        'Unknown Title';

    final descMap = attributes['description'] as Map<String, dynamic>?;
    final description = descMap?['en'] ?? descMap?.values.firstOrNull;

    final tags = (attributes['tags'] as List<dynamic>?)
            ?.map((tag) {
              final tagAttributes =
                  tag['attributes'] as Map<String, dynamic>;
              final tagName =
                  tagAttributes['name'] as Map<String, dynamic>;
              return tagName['en'] as String? ?? '';
            })
            .where((tag) => tag.isNotEmpty)
            .toList() ??
        [];

    return WebManga(
      id: json['id'] as String,
      title: title as String,
      description: description as String?,
      tags: tags,
      status: attributes['status'] as String? ?? 'unknown',
      relationships: json['relationships'] as List<dynamic>?,
    );
  }
}

class Chapter {
  final String id;
  final String? title;
  final String? chapterNumber;
  final String? volume;
  final String translatedLanguage;

  Chapter({
    required this.id,
    this.title,
    this.chapterNumber,
    this.volume,
    required this.translatedLanguage,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>;

    return Chapter(
      id: json['id'] as String,
      title: attributes['title'] as String?,
      chapterNumber: attributes['chapter'] as String?,
      volume: attributes['volume'] as String?,
      translatedLanguage:
          attributes['translatedLanguage'] as String? ?? 'unknown',
    );
  }

  String get displayTitle {
    if (chapterNumber != null) {
      return 'Chapter $chapterNumber${title != null ? ' - $title' : ''}';
    }
    return title ?? 'Unknown Chapter';
  }
}