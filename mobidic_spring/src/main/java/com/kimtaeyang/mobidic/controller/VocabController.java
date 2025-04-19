package com.kimtaeyang.mobidic.controller;

import com.kimtaeyang.mobidic.dto.AddVocabDto;
import com.kimtaeyang.mobidic.dto.ApiResponse;
import com.kimtaeyang.mobidic.dto.UpdateVocabDto;
import com.kimtaeyang.mobidic.service.VocabService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

import static com.kimtaeyang.mobidic.code.GeneralResponseCode.OK;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/vocab")
public class VocabController {
    private final VocabService vocabService;

    @PostMapping("/{memberId}")
    public ResponseEntity<?> addVocab(
            @PathVariable String memberId,
            @RequestBody @Valid AddVocabDto.Request request
    ) {
        return ApiResponse.toResponseEntity(OK,
                vocabService.addVocab(UUID.fromString(memberId), request));
    }

    @GetMapping("/all")
    public ResponseEntity<?> getAllVocab(
           @RequestParam String uId
    ) {
        return ApiResponse.toResponseEntity(OK,
                vocabService.getVocabsByMemberId(UUID.fromString(uId)));
    }

    @GetMapping("/detail")
    public ResponseEntity<?> getVocabDetail(
            @RequestParam String vId
    ) {
        return ApiResponse.toResponseEntity(OK,
                vocabService.getVocabById(UUID.fromString(vId)));
    }

    @PatchMapping("/{vocabId}")
    public ResponseEntity<?> updateVocab(
            @PathVariable String vocabId,
            @RequestBody @Valid UpdateVocabDto.Request request
    ) {
        return ApiResponse.toResponseEntity(OK,
                vocabService.updateVocab(UUID.fromString(vocabId), request));
    }

    @DeleteMapping("/{vocabId}")
    public ResponseEntity<?> deleteVocab(
            @PathVariable String vocabId
    ) {
        return ApiResponse.toResponseEntity(OK,
                vocabService.deleteVocab(UUID.fromString(vocabId)));
    }
}
