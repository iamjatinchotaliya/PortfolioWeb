import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';

/// Public API only. Admin credentials must never be embedded in the website.
class PortfolioApiClient {
  PortfolioApiClient({
    String baseUrl = ApiConfig.baseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 15),
  }) : baseUrl = _normalizeBaseUrl(baseUrl),
       _client = client ?? http.Client();

  final Uri baseUrl;
  final http.Client _client;
  final Duration timeout;

  static Uri _normalizeBaseUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    if (uri == null ||
        !const ['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.hasQuery ||
        uri.hasFragment ||
        uri.userInfo.isNotEmpty) {
      throw ArgumentError('API_BASE_URL must be an HTTP(S) API URL.');
    }
    return uri.replace(path: '${uri.path.replaceFirst(RegExp(r'/+$'), '')}/');
  }

  Future<Map<String, dynamic>> get(String path, {Map<String, String>? query}) =>
      _request('GET', path, query: query);

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) =>
      _request('POST', path, body: body);

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {
    final uri = baseUrl.resolve(path).replace(queryParameters: query);
    try {
      const headers = {'Accept': 'application/json'};
      final response =
          await (method == 'POST'
                  ? _client.post(
                      uri,
                      headers: {...headers, 'Content-Type': 'application/json'},
                      body: jsonEncode(body),
                    )
                  : _client.get(uri, headers: headers))
              .timeout(timeout);
      dynamic decoded;
      try {
        decoded = jsonDecode(utf8.decode(response.bodyBytes));
      } on FormatException {
        // Servers/proxies can return HTML on errors. Keep it out of the UI.
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw PortfolioApiException(
          _errorMessage(response.statusCode, decoded),
          statusCode: response.statusCode,
        );
      }
      if (decoded is! Map<String, dynamic>) {
        throw const PortfolioApiException(
          'The server returned an invalid response. Please try again.',
        );
      }
      return decoded;
    } on TimeoutException {
      throw const PortfolioApiException(
        'The request timed out. Please try again.',
      );
    } on http.ClientException {
      throw const PortfolioApiException(
        'Unable to reach the portfolio server. Please try again.',
      );
    }
  }

  static String _errorMessage(int status, dynamic body) {
    final detail = body is Map ? body['detail'] : null;
    if (status == 429)
      return 'Too many messages. Please wait before trying again.';
    if (status >= 500)
      return 'The portfolio server is unavailable. Please try again later.';
    if (detail is String && detail.isNotEmpty) return detail;
    if (status == 422 && detail is List) {
      final messages = detail
          .whereType<Map>()
          .map((error) {
            final location = error['loc'];
            final field = location is List && location.length > 1
                ? '${location.last}: '
                : '';
            return '$field${error['msg'] ?? 'Invalid value'}';
          })
          .join('\n');
      if (messages.isNotEmpty) return messages;
    }
    return 'The request failed. Please try again.';
  }

  void close() => _client.close();
}

class PortfolioApiException implements Exception {
  const PortfolioApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => message;
}
