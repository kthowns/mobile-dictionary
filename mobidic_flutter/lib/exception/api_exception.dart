class ApiException implements Exception{
  final int statusCode;
  final String message;
  final List<Map<String, String>>? errors;

  ApiException(this.statusCode, this.message, {this.errors});

  @override
  String toString() => 'ApiException($statusCode): $message';
}