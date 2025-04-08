package com.kimtaeyang.mobidic.controller;

import com.kimtaeyang.mobidic.dto.AddWordDto;
import com.kimtaeyang.mobidic.dto.ApiResponse;
import com.kimtaeyang.mobidic.service.WordService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

import static com.kimtaeyang.mobidic.code.GeneralResponseCode.OK;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api/word")
public class WordController {
    private final WordService wordService;

    @PostMapping("/{vocabId}")
    public ResponseEntity<?> addWord(
            @PathVariable("vocabId") String vocabId,
            @RequestBody @Valid AddWordDto.Request request
    ) {
        return ApiResponse.toResponseEntity(OK,
                wordService.addWord(UUID.fromString(vocabId), request));
    }

    @PatchMapping("/{wordId}")
    public ResponseEntity<?> updateWord(
            @PathVariable("wordId") String wordId,
            @RequestBody @Valid AddWordDto.Request request
    ) {
        return ApiResponse.toResponseEntity(OK,
                wordService.updateWord(UUID.fromString(wordId), request));
    }

    @DeleteMapping("/{wordId}")
    public ResponseEntity<?> deleteWord(
            @PathVariable("wordId") String wordId
    ) {
        return ApiResponse.toResponseEntity(OK,
                wordService.deleteWord(UUID.fromString(wordId)));
    }

    @GetMapping("/all")
    public ResponseEntity<?> getWordsByVocabId(
            @RequestParam String vId
    ) {
        return ApiResponse.toResponseEntity(OK,
                wordService.getWordsByVocabId(UUID.fromString(vId)));
    }

    @GetMapping("/detail")
    public ResponseEntity<?> getWordDetail(
            @RequestParam String wId
    ){
        return ApiResponse.toResponseEntity(OK,
                wordService.getWordDetail(UUID.fromString(wId)));
    }
}
