import 'package:mobidic_flutter/data/api_client.dart';
import 'package:mobidic_flutter/dto/api_response_dto.dart';
import 'package:mobidic_flutter/dto/member_dto.dart';
import 'package:mobidic_flutter/repository/auth_repository.dart';

class MemberRepository {
  final ApiClient apiClient;
  final AuthRepository authRepository;

  MemberRepository(this.apiClient, this.authRepository);

  Future<MemberDto> getMemberDetail(String memberId) async {
    String? token = await authRepository.getToken();

    GeneralResponseDto body = await apiClient.get(
      url: '/user/detail',
      headers: {'Authorization': 'Bearer $token'},
      params: {'uId': memberId},
    );

    return MemberDto.fromJson(body.data);
  }
}
