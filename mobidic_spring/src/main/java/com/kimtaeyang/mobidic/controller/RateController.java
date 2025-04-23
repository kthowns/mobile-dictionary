package com.kimtaeyang.mobidic.controller;

import com.kimtaeyang.mobidic.dto.GeneralResponse;
import com.kimtaeyang.mobidic.dto.RateDto;
import com.kimtaeyang.mobidic.service.RateService;
import io.swagger.v3.oas.annotations.tags.Tag;
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
@Tag(name = "통계 관련 서비스", description = "단어장 별 학습률, 단어 난이도 불러오기 등")
public class RateController {
    private final RateService rateService;

    @GetMapping("/w")
    public ResponseEntity<GeneralResponse<RateDto>> getRateByWordId(
            @RequestParam String wId
    ) {
        return GeneralResponse.toResponseEntity(OK,
                rateService.getRateByWordId(UUID.fromString(wId)));
    }

    @GetMapping("/v")
    public ResponseEntity<GeneralResponse<Double>> getVocabLearningRate(
            @RequestParam String vId
    ) {
        return GeneralResponse.toResponseEntity(OK,
                rateService.getVocabLearningRate(UUID.fromString(vId)));
    }

    @PatchMapping("/tog/{wordId}")
    public ResponseEntity<GeneralResponse<Void>> toggleRateByWordId(
            @PathVariable String wordId
    ) {
        rateService.toggleRateByWordId(UUID.fromString(wordId));

        return GeneralResponse.toResponseEntity(OK, null);
    }
}
