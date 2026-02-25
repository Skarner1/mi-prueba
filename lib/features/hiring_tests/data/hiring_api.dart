// lib/features/hiring_tests/data/hiring_api.dart
import 'package:dio/dio.dart';
import 'hiring_item.dart';

/// API client for hiring tests. Uses routes according to the provided spec:
/// - GET /items/{cedula}
/// - GET /items/{cedula}/{id}
/// - POST /items/{cedula}
/// - PUT /items/{cedula}/{id}
/// - DELETE /items/{cedula}/{id}
class HiringApi {
  final Dio dio;
  HiringApi(this.dio);

  Future<List<HiringItem>> fetchItems({required String cedula}) async {
    final String path = '/items/$cedula';
    final resp = await dio.get(path);
    final data = resp.data;
    if (data == null) return [];
    final ok = data['ok'] ?? true;
    if (ok == false) {
      throw Exception(data['error'] ?? data['message'] ?? 'Error fetching items');
    }
    final list = (data['data'] as List<dynamic>?) ?? [];
    return list.map((e) => HiringItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<HiringItem> createItem({
    required String marca,
    required String sucursal,
    required String aspirante,
    required String cedula,
  }) async {
    final path = '/items/$cedula';
    final payload = {
      'marca': marca,
      'sucursal': sucursal,
      'aspirante': aspirante,
    };

    final resp = await dio.post(path, data: payload, options: Options(contentType: Headers.jsonContentType));
    final respData = resp.data;

    if (respData is Map) {
      final result = respData['result'] ?? respData;
      if (result is Map && result['ok'] == true) {
        final data = result['data'] ?? result;
        return HiringItem.fromJson(data as Map<String, dynamic>);
      } else if (respData['ok'] == true && respData['data'] != null) {
        return HiringItem.fromJson(respData['data'] as Map<String, dynamic>);
      } else {
        final err = result is Map ? result['error'] : respData['result'];
        throw Exception('Create failed: $err');
      }
    }
    throw Exception('Create failed: unexpected response');
  }

  Future<HiringItem> updateItem(
      int id, {
        required String marca,
        required String sucursal,
        required String aspirante,
        required String cedula,
      }) async {
    final path = '/items/$cedula/$id';
    final payload = {
      'marca': marca,
      'sucursal': sucursal,
      'aspirante': aspirante,
    };

    final resp = await dio.put(path, data: payload, options: Options(contentType: Headers.jsonContentType));
    final respData = resp.data;

    if (respData is Map) {
      final result = respData['result'] ?? respData;
      if (result is Map && result['ok'] == true) {
        final data = result['data'] ?? result;
        return HiringItem.fromJson(data as Map<String, dynamic>);
      } else if (respData['ok'] == true && respData['data'] != null) {
        return HiringItem.fromJson(respData['data'] as Map<String, dynamic>);
      } else {
        final err = result is Map ? result['error'] : respData['result'];
        throw Exception('Update failed: $err');
      }
    }
    throw Exception('Update failed: unexpected response');
  }

  /// Delete with fallbacks but using cedula in path (spec requires it).
  /// bodyFields are optional fields to send with override attempts.
  Future<void> deleteItem(int id, {required String cedula, Map<String, dynamic>? bodyFields}) async {
    final basePath = '/items/$cedula/$id';

    // 1) DELETE /items/{cedula}/{id}
    try {
      final resp = await dio.delete(basePath);
      final respData = resp.data;
      if (respData is Map && (respData['ok'] == true || resp.statusCode == 200)) return;
    } on DioError {
      // ignore and try fallbacks
    }

    // Prepare fields
    final Map<String, dynamic> fields = {};
    if (bodyFields != null) fields.addAll(bodyFields);

    // 2) POST override to same path with _method=DELETE (include fields)
    try {
      final dataToSend = {...fields, '_method': 'DELETE'};
      final resp2 = await dio.post(basePath, data: dataToSend, options: Options(contentType: Headers.jsonContentType));
      final respData = resp2.data;
      if (respData is Map) {
        final result = respData['result'] ?? respData;
        if (result is Map && result['ok'] == true) return;
        if (respData['ok'] == true) return;
      }
    } on DioError {
      // ignore and try next fallback
    }

    // 3) POST /items/{cedula}/{id}/delete
    try {
      final path3 = '/items/$cedula/$id/delete';
      final resp3 = await dio.post(path3, data: fields, options: Options(contentType: Headers.jsonContentType));
      final respData = resp3.data;
      if (respData is Map) {
        final result = respData['result'] ?? respData;
        if (result is Map && result['ok'] == true) return;
        if (respData['ok'] == true) return;
      }
    } on DioError {
      // ignore
    }

    // 4) POST /items/{cedula}/delete with id in body
    try {
      final path4 = '/items/$cedula/delete';
      final resp4 = await dio.post(path4, data: {'id': id, ...fields}, options: Options(contentType: Headers.jsonContentType));
      final respData = resp4.data;
      if (respData is Map) {
        final result = respData['result'] ?? respData;
        if (result is Map && result['ok'] == true) return;
        if (respData['ok'] == true) return;
      }
    } on DioError {
      // ignore
    }

    // If none worked
    throw Exception('Delete failed: server does not accept known delete alternatives for cedula=$cedula id=$id. Revisa backend.');
  }
}