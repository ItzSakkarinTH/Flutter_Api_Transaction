import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiClient {
  final StorageService storage;
  final http.Client _client = http.Client();

  // เปลี่ยนตามของคุณได้
  static const String baseUrl = 'https://transactions-cs.vercel.app';

  ApiClient(this.storage);

  Map<String, String> _headers() {
    final token = storage.getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse('$baseUrl$path').replace(queryParameters: query?.map((k, v) => MapEntry(k, v.toString())));
  }

  Future<http.Response> get(String path, {Map<String, dynamic>? query}) async {
    final res = await _client.get(_uri(path, query), headers: _headers());
    _throwIfUnauthorized(res);
    return res;
  }

  Future<http.Response> post(String path, {Object? body}) async {
    final res = await _client.post(_uri(path), headers: _headers(), body: jsonEncode(body ?? {}));
    _throwIfUnauthorized(res);
    return res;
  }

  Future<http.Response> put(String path, {Object? body}) async {
    final res = await _client.put(_uri(path), headers: _headers(), body: jsonEncode(body ?? {}));
    _throwIfUnauthorized(res);
    return res;
  }

  Future<http.Response> delete(String path) async {
    final res = await _client.delete(_uri(path), headers: _headers());
    _throwIfUnauthorized(res);
    return res;
  }

  void _throwIfUnauthorized(http.Response res) {
    if (res.statusCode == 401) {
      // จุดเดียวรวม logic จัดการ 401 (เช่น ล้าง token / นำไปหน้า login)
      // โยนให้ชั้นบนตัดสินใจ
      throw UnauthorizedException(res.body);
    }
  }
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
  @override
  String toString() => 'UnauthorizedException: $message';
}