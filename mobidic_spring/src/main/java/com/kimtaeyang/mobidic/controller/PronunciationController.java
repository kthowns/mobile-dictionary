package com.kimtaeyang.mobidic.controller;

import com.kimtaeyang.mobidic.service.PronunciationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/pron")
public class PronunciationController {
    private final PronunciationService pronunciationService;

    @Operation(
            summary = "발음 체크",
            description = "음성 파일과 단어 식별자를 통한 발음 점수 체크",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @PostMapping("/rate")
    public double ratePronunciation(
            @RequestParam("file") MultipartFile file,
            @RequestParam("wordId") UUID wordId
    ) {
        return pronunciationService.ratePronunciation(wordId, file);
    }
}
