import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobidic_flutter/dto/api_response_dto.dart';
import 'package:mobidic_flutter/exception/api_exception.dart';

abstract class BaseDataSource {
  Future<T> handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final Map<String, dynamic> bodyJson = jsonDecode(response.body);

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
