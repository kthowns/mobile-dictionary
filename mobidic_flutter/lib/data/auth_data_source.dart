import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobidic_flutter/data/base_data_source.dart';
import 'package:mobidic_flutter/dto/api_response_dto.dart';

class AuthDataSource extends BaseDataSource {
  final String baseUrl;

  AuthDataSource(this.baseUrl);

  Future<GeneralResponseDto> login(String id, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final http.Response response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': id, 'password': password}),
    );

    return handleResponse(response, GeneralResponseDto.fromJson);
  }

  Future<GeneralResponseDto> logout(String token) async {
    final url = Uri.parse('$baseUrl/auth/logout');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      },
    );

    return handleResponse(response, GeneralResponseDto.fromJson);
  }
}
