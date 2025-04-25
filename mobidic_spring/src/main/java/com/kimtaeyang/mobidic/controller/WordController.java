package com.kimtaeyang.mobidic.controller;

import com.kimtaeyang.mobidic.dto.AddWordDto;
import com.kimtaeyang.mobidic.dto.GeneralResponse;
import com.kimtaeyang.mobidic.dto.WordDetailDto;
import com.kimtaeyang.mobidic.dto.WordDto;
import com.kimtaeyang.mobidic.service.WordService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

import static com.kimtaeyang.mobidic.code.GeneralResponseCode.OK;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api/word")
@Tag(name = "단어 관련 서비스", description = "단어장 별 단어 불러오기, 추가 등")
public class WordController {
    private final WordService wordService;

    @Operation(
            summary = "단어 추가",
            description = "중복체크 있음, 최대 45자",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @PostMapping("/{vocabId}")
    public ResponseEntity<GeneralResponse<AddWordDto.Response>> addWord(
            @PathVariable("vocabId") String vocabId,
            @RequestBody @Valid AddWordDto.Request request
    ) {
        return GeneralResponse.toResponseEntity(OK,
                wordService.addWord(UUID.fromString(vocabId), request));
    }

    @Operation(
            summary = "단어 수정",
            description = "최대 45자",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @PatchMapping("/{wordId}")
    public ResponseEntity<GeneralResponse<AddWordDto.Response>> updateWord(
            @PathVariable("wordId") String wordId,
            @RequestBody @Valid AddWordDto.Request request
    ) {
        return GeneralResponse.toResponseEntity(OK,
                wordService.updateWord(UUID.fromString(wordId), request));
    }

    @Operation(
            summary = "단어 삭제",
            description = "완전 삭제",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @DeleteMapping("/{wordId}")
    public ResponseEntity<GeneralResponse<WordDto>> deleteWord(
            @PathVariable("wordId") String wordId
    ) {
        return GeneralResponse.toResponseEntity(OK,
                wordService.deleteWord(UUID.fromString(wordId)));
    }

    @Operation(
            summary = "단어 전체 조회",
            description = "단어장 식별자를 통한 단어 전체 조회",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @GetMapping("/all")
    public ResponseEntity<GeneralResponse<List<WordDetailDto>>> getWordsByVocabId(
            @RequestParam String vId
    ) {
        return GeneralResponse.toResponseEntity(OK,
                wordService.getWordsByVocabId(UUID.fromString(vId)));
    }

    @Operation(
            summary = "단어 정보 조회",
            description = "단어 식별자를 통한 정보 조회",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @GetMapping("/detail")
    public ResponseEntity<GeneralResponse<WordDetailDto>> getWordDetail(
            @RequestParam String wId
    ){
        return GeneralResponse.toResponseEntity(OK,
                wordService.getWordDetail(UUID.fromString(wId)));
    }
}
