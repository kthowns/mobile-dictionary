import 'package:mobidic_flutter/data/api_client.dart';
import 'package:mobidic_flutter/dto/api_response_dto.dart';
import 'package:mobidic_flutter/model/definition.dart';
import 'package:mobidic_flutter/model/rate.dart';
import 'package:mobidic_flutter/repository/auth_repository.dart';

import '../model/word.dart';

class WordRepository {
  final ApiClient _apiClient;
  final AuthRepository _authRepository;

  WordRepository(this._apiClient, this._authRepository);

  Future<List<Word>> getWords() async {
    String? token = await _authRepository.getToken();
    String? memberId = await _authRepository.getCurrentMemberId();

    GeneralResponseDto body = await _apiClient.get(
      url: '/vocab/all',
      headers: {'Authorization': 'Bearer $token'},
      params: {'uId': memberId},
    );

    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      body.data,
    );
    List<WordDto> responses = data.map((v) => WordDto.fromJson(v)).toList();
    List<Word> words = [];

    for (WordDto dto in responses) {
      GeneralResponseDto rateBody = await _apiClient.get(
        url: '/rate/w',
        headers: {'Authorization': 'Bearer $token'},
        params: {'wId': dto.id},
      );

      RateDto rateResponse = RateDto.fromJson(rateBody.data);

      GeneralResponseDto defsBody = await _apiClient.get(
        url: '/def/all',
        headers: {'Authorization': 'Bearer $token'},
        params: {'wId': dto.id},
      );

      List<Map<String, dynamic>> defsData = List<Map<String, dynamic>>.from(
        defsBody.data,
      );
      List<DefDto> defDtos = data.map((d) => DefDto.fromJson(d)).toList();
      List<Definition> defs = defDtos.map((d) => Definition.fromDto(d)).toList();

      words.add(Word.fromDto(dto, rateResponse.difficulty, defs));
    }

    return words;
  }
}
