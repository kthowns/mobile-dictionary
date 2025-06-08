import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobidic_flutter/dto/api_response_dto.dart';
import 'package:mobidic_flutter/exception/api_exception.dart';

class ApiClient {
  final String _baseUrl;

  ApiClient(this._baseUrl);

  Future<GeneralResponseDto> post({
    required String url,
    Object? body,
    Map<String, String>? headers,
  }) async {
    print("Request uri : POST $_baseUrl$url");
    final http.Response response = await http.post(
      Uri.parse('$_baseUrl$url'),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: body != null ? jsonEncode(body) : null,
    );

    return _handleResponse(response, GeneralResponseDto.fromJson);
  }

  Future<GeneralResponseDto> patch({
    required String url,
    Object? body,
    Map<String, String>? headers,
  }) async {
    print("Request uri : PATCH $_baseUrl$url");
    final http.Response response = await http.patch(
      Uri.parse('$_baseUrl$url'),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: body != null ? jsonEncode(body) : null,
    );

    return _handleResponse(response, GeneralResponseDto.fromJson);
  }

  Future<GeneralResponseDto> get({
    required String url,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) async {
    final uri = Uri.parse('$_baseUrl$url').replace(
      queryParameters: params?.map((k, v) => MapEntry(k, v.toString())),
    );
    print("Request uri : GET $_baseUrl$url");

    final http.Response response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json', ...?headers},
    );

    return _handleResponse(response, GeneralResponseDto.fromJson);
  }

  Future<GeneralResponseDto> delete({
    required String url,
    Object? body,
    Map<String, String>? headers,
  }) async {
    print("Request uri : DELETE $_baseUrl$url");
    final http.Response response = await http.delete(
      Uri.parse('$_baseUrl$url'),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: body != null ? jsonEncode(body) : null,
    );

    return _handleResponse(response, GeneralResponseDto.fromJson);
  }

  Future<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final Map<String, dynamic> bodyJson = jsonDecode(response.body);

    print(bodyJson);

    if (response.statusCode != 200) {
      final errorBody = ErrorResponseDto.fromJson(bodyJson);
      throw ApiException(
        response.statusCode,
        errorBody.message,
        errors: errorBody.errors,
      );
    }

    return fromJson(bodyJson);
  }
}
