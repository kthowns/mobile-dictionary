import 'package:mobidic_flutter/data/auth_data_source.dart';
import 'package:mobidic_flutter/data/secure_storage_data_source.dart';
import 'package:mobidic_flutter/dto/api_response_dto.dart';
import 'package:mobidic_flutter/dto/login_dto.dart';

class AuthRepository {
  final AuthDataSource authDataSource;
  final SecureStorageDataSource secureStorageDataSource;

  AuthRepository(this.authDataSource, this.secureStorageDataSource);

  Future<void> login(String id, String password) async {
    GeneralResponseDto body = await authDataSource.login(id, password);
    LoginResponseDto response = LoginResponseDto.fromJson(body.data);

    await secureStorageDataSource.saveToken(response.token);
    await secureStorageDataSource.saveMemberId(response.memberId);
  }
}
