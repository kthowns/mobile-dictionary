package com.kimtaeyang.mobidic.controller;

import com.kimtaeyang.mobidic.dto.AddVocabDto;
import com.kimtaeyang.mobidic.dto.GeneralResponse;
import com.kimtaeyang.mobidic.dto.UpdateVocabDto;
import com.kimtaeyang.mobidic.dto.VocabDto;
import com.kimtaeyang.mobidic.service.VocabService;
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
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/vocab")
@Tag(name = "단어장 관련 서비스", description = "사용자별 단어장 목록 불러오기, 추가 등")
public class VocabController {
    private final VocabService vocabService;

    @PostMapping("/{memberId}")
    public ResponseEntity<GeneralResponse<AddVocabDto.Response>> addVocab(
            @PathVariable String memberId,
            @RequestBody @Valid AddVocabDto.Request request
    ) {
        return GeneralResponse.toResponseEntity(OK,
                vocabService.addVocab(UUID.fromString(memberId), request));
    }

    @GetMapping("/all")
    public ResponseEntity<GeneralResponse<List<VocabDto>>> getAllVocab(
           @RequestParam String uId
    ) {
        return GeneralResponse.toResponseEntity(OK,
                vocabService.getVocabsByMemberId(UUID.fromString(uId)));
    }

    @GetMapping("/detail")
    public ResponseEntity<GeneralResponse<VocabDto>> getVocabDetail(
            @RequestParam String vId
    ) {
        return GeneralResponse.toResponseEntity(OK,
                vocabService.getVocabById(UUID.fromString(vId)));
    }

    @PatchMapping("/{vocabId}")
    public ResponseEntity<GeneralResponse<UpdateVocabDto.Response>> updateVocab(
            @PathVariable String vocabId,
            @RequestBody @Valid UpdateVocabDto.Request request
    ) {
        return GeneralResponse.toResponseEntity(OK,
                vocabService.updateVocab(UUID.fromString(vocabId), request));
    }

    @DeleteMapping("/{vocabId}")
    public ResponseEntity<GeneralResponse<VocabDto>> deleteVocab(
            @PathVariable String vocabId
    ) {
        return GeneralResponse.toResponseEntity(OK,
                vocabService.deleteVocab(UUID.fromString(vocabId)));
    }
}
