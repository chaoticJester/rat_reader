import 'package:dio/dio.dart';
import '../models/web_manga.dart';

class MangaRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.mangadex.org',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<WebManga>> searchManga(String query) async {
    try {
      final response = await _dio.get(
        '/manga',
        queryParameters: {
          'title': query,
          'limit': 20,
          'contentRating[]': ['safe', 'suggestive'],
          'includes[]': ['cover_art'],
        },
      );

      final data = response.data['data'] as List<dynamic>;
      return data.map((json) => WebManga.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search manga: $e');
    }
  }

  Future<List<Chapter>> getChapters(String mangaId) async {
    try {
      final response = await _dio.get(
        '/manga/$mangaId/feed',
        queryParameters: {
          'translatedLanguage[]': ['en'],
          'order[chapter]': 'asc',
          'limit': 100,
        },
      );

      final data = response.data['data'] as List<dynamic>;
      return data.map((json) => Chapter.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get chapters: $e');
    }
  }

  Future<List<String>> getChapterImages(String chapterId) async {
    try {
      final response = await _dio.get('/at-home/server/$chapterId');

      final baseUrl = response.data['baseUrl'] as String;
      final chapterData =
          response.data['chapter'] as Map<String, dynamic>;
      final hash = chapterData['hash'] as String;
      final pages = chapterData['data'] as List<dynamic>;

      return pages
          .map((page) => '$baseUrl/data/$hash/$page')
          .toList();
    } catch (e) {
      throw Exception('Failed to get chapter images: $e');
    }
  }

  String getCoverUrl(WebManga manga) {
    try {
      final relationships = manga.relationships;
      if (relationships == null) return '';

      final coverArt = relationships.firstWhere(
        (r) => r['type'] == 'cover_art',
        orElse: () => null,
      );

      if (coverArt == null) return '';

      final fileName =
          coverArt['attributes']['fileName'] as String;
      return 'https://uploads.mangadex.org/covers/${manga.id}/$fileName';
    } catch (e) {
      return '';
    }
  }
}