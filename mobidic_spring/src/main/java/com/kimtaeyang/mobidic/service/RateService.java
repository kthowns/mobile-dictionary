package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.dto.RateDto;
import com.kimtaeyang.mobidic.entity.Rate;
import com.kimtaeyang.mobidic.exception.ApiException;
import com.kimtaeyang.mobidic.repository.RateRepository;
import com.kimtaeyang.mobidic.repository.VocabRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

import static com.kimtaeyang.mobidic.code.GeneralResponseCode.INTERNAL_SERVER_ERROR;
import static com.kimtaeyang.mobidic.code.GeneralResponseCode.NO_RATE;

@Service
@RequiredArgsConstructor
@Slf4j
public class RateService {
    private final RateRepository rateRepository;

    @Transactional(readOnly = true)
    @PreAuthorize("@rateAccessHandler.ownershipCheck(#wordId)")
    public RateDto getRateByWordId(UUID wordId) {
        Rate rate = rateRepository.getRateByWordId(wordId)
                .orElseThrow(() -> new ApiException(NO_RATE));

        return RateDto.fromEntity(rate);
    }

    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#vocabId)")
    @Transactional(readOnly = true)
    public Double getVocabLearningRate(UUID vocabId) {
        return rateRepository.getVocabLearningRate(vocabId)
                .orElseThrow(() -> new ApiException(INTERNAL_SERVER_ERROR));
    }

    @Transactional
    @PreAuthorize("@wordAccessHandler.ownershipCheck(#wordId)")
    public void toggleRateByWordId(UUID wordId) {
        Rate rate = rateRepository.getRateByWordId(wordId)
                .orElseThrow(() -> new ApiException(NO_RATE));

        if(rate.getIsLearned() > 0){
            rate.setIsLearned(0);
        } else {
            rate.setIsLearned(1);
        }

        rateRepository.save(rate);
    }
}
