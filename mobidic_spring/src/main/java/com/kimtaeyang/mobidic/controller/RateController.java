package com.kimtaeyang.mobidic.controller;

import com.kimtaeyang.mobidic.dto.ApiResponse;
import com.kimtaeyang.mobidic.service.RateService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

import static com.kimtaeyang.mobidic.code.GeneralResponseCode.OK;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/rate/")
public class RateController {
    private final RateService rateService;

    @GetMapping("/w")
    public ResponseEntity<?> getRateByWordId(
            @RequestParam String wId
    ) {
        return ApiResponse.toResponseEntity(OK,
                rateService.getRateByWordId(UUID.fromString(wId)));
    }

    @GetMapping("/v")
    public ResponseEntity<?> getVocabLearningRate(
            @RequestParam String vId
    ) {
        return ApiResponse.toResponseEntity(OK,
                rateService.getVocabLearningRate(UUID.fromString(vId)));
    }

    @PatchMapping("/tog/{wordId}")
    public ResponseEntity<?> toggleRateByWordId(
            @PathVariable String wordId
    ) {
        rateService.toggleRateByWordId(UUID.fromString(wordId));

        return ApiResponse.toResponseEntity(OK, null);
    }
}
