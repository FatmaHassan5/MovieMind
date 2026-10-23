import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

/// خطأ بيحمل رسالة جاهزة للعرض للمستخدم.
class TmdbException implements Exception {
  const TmdbException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// عميل بسيط لـ TMDB API v3 (بيستخدم الـ Read Access Token).
class TmdbClient {
  TmdbClient._();
  static final TmdbClient instance = TmdbClient._();

  static const _host = 'api.themoviedb.org';
  static const _timeout = Duration(seconds: 15);

  Future<Map<String, dynamic>> get(String path, [Map<String, String>? query]) async {
    if (!ApiConfig.hasTmdbToken) {
  throw const TmdbException(ApiConfig.missingTokenMessage);
}
    final uri = Uri.https(_host, '/3$path', {'language': 'en-US', ...?query});
    try {
      final response = await http.get(uri, headers: {

        'Authorization': 'Bearer ${ApiConfig.tmdbToken}',
        'accept': 'application/json',
      }).timeout(_timeout);

      switch (response.statusCode) {
        case 200:
          final decoded = jsonDecode(utf8.decode(response.bodyBytes));
          if (decoded is Map<String, dynamic>) return decoded;
          throw const TmdbException('Unexpected response from the movie service.');
        case 401:
          throw const TmdbException('The TMDB token is invalid. Check TMDB_TOKEN.');
        case 404:
          throw const TmdbException('Not found.');
        case 429:
          throw const TmdbException('Too many requests. Please wait a moment and retry.');
        default:
          throw TmdbException('Movie service error (${response.statusCode}).');
      }
    } on TmdbException {
      rethrow;
    } on TimeoutException {
      throw const TmdbException('The request took too long. Please try again.');
    } catch (e) {
      debugPrint('TMDB request failed: $e');
      throw const TmdbException('Couldn\'t reach the movie service. Check your connection.');
    }
  }
}
