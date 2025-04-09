package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.dto.RateDto;
import com.kimtaeyang.mobidic.entity.Member;
import com.kimtaeyang.mobidic.entity.Rate;
import com.kimtaeyang.mobidic.entity.Vocab;
import com.kimtaeyang.mobidic.exception.ApiException;
import com.kimtaeyang.mobidic.repository.RateRepository;
import com.kimtaeyang.mobidic.repository.VocabRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

import static com.kimtaeyang.mobidic.code.AuthResponseCode.UNAUTHORIZED;
import static com.kimtaeyang.mobidic.code.GeneralResponseCode.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class RateService {
    private final RateRepository rateRepository;
    private final VocabRepository vocabRepository;

    @Transactional(readOnly = true)
    public RateDto getRateByWordId(UUID wordId) {
        Rate rate = rateRepository.getRateByWordId(wordId)
                .orElseThrow(() -> new ApiException(NO_RATE));
        authorizeRate(rate);

        return RateDto.fromEntity(rate);
    }

    @Transactional(readOnly = true)
    public Double getVocabLearningRate(UUID vocabId) {
        Vocab vocab = vocabRepository.findById(vocabId)
                .orElseThrow(() -> new ApiException(NO_VOCAB));
        authorizeVocab(vocab);

        return rateRepository.getVocabLearningRate(vocabId)
                .orElseThrow(() -> new ApiException(INTERNAL_SERVER_ERROR));
    }

    @Transactional
    public void toggleRateByWordId(UUID wordId) {
        Rate rate = rateRepository.getRateByWordId(wordId)
                .orElseThrow(() -> new ApiException(NO_RATE));
        authorizeRate(rate);

        if(rate.getIsLearned() > 0){
            rate.setIsLearned(0);
        } else {
            rate.setIsLearned(1);
        }

        rateRepository.save(rate);
    }

    private void authorizeVocab(Vocab vocab) {
        if (!vocab.getMember().getId().equals(getCurrentMemberId())) {
            throw new ApiException(UNAUTHORIZED);
        }
    }

    private void authorizeRate(Rate rate) {
        if (!rate.getWord().getVocab().getMember().getId().equals(getCurrentMemberId())) {
            throw new ApiException(UNAUTHORIZED);
        }
    }

    private UUID getCurrentMemberId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        return ((Member) auth.getPrincipal()).getId();
    }
}
