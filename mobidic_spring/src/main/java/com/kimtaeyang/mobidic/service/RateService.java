package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.dto.RateDto;
import com.kimtaeyang.mobidic.entity.Rate;
import com.kimtaeyang.mobidic.entity.Vocab;
import com.kimtaeyang.mobidic.entity.Word;
import com.kimtaeyang.mobidic.exception.ApiException;
import com.kimtaeyang.mobidic.repository.RateRepository;
import com.kimtaeyang.mobidic.repository.VocabRepository;
import com.kimtaeyang.mobidic.repository.WordRepository;
import com.kimtaeyang.mobidic.type.Difficulty;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

import static com.kimtaeyang.mobidic.code.GeneralResponseCode.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class RateService {
    private final WordRepository wordRepository;
    private final RateRepository rateRepository;
    private final VocabRepository vocabRepository;

    @Transactional(readOnly = true)
    @PreAuthorize("@rateAccessHandler.ownershipCheck(#wordId)")
    public RateDto getRateByWordId(UUID wordId) {
        Word word = wordRepository.findById(wordId)
                .orElseThrow(() -> new ApiException(NO_WORD));
        Rate rate = rateRepository.findRateByWord(word)
                .orElseThrow(() -> new ApiException(NO_RATE));

        return RateDto.fromEntity(rate, getDifficulty(rate.getCorrectCount(), rate.getIncorrectCount()));
    }

    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#vocabId)")
    @Transactional(readOnly = true)
    public Double getVocabLearningRate(UUID vocabId) {
        Vocab vocab = vocabRepository.findById(vocabId)
                .orElseThrow(() -> new ApiException(NO_VOCAB));
        if(wordRepository.countByVocab(vocab) < 1){
            return 0.0;
        }
        return rateRepository.getVocabLearningRate(vocab)
                .orElseThrow(() -> new ApiException(INTERNAL_SERVER_ERROR));
    }

    @Transactional
    @PreAuthorize("@wordAccessHandler.ownershipCheck(#wordId)")
    public void toggleRateByWordId(UUID wordId) {
        Word word = wordRepository.findById(wordId)
                .orElseThrow(() -> new ApiException(NO_WORD));
        Rate rate = rateRepository.findRateByWord(word)
                .orElseThrow(() -> new ApiException(NO_RATE));

        if(rate.getIsLearned() > 0){
            rate.setIsLearned(0);
        } else {
            rate.setIsLearned(1);
        }

        rateRepository.save(rate);
    }

    @Transactional
    @PreAuthorize("@wordAccessHandler.ownershipCheck(#wordId)")
    public void increaseCorrectCount(UUID wordId) {
        Word word = wordRepository.findById(wordId)
                        .orElseThrow(() -> new ApiException(NO_WORD));
        rateRepository.increaseCorrectCount(word);
    }

    @Transactional
    @PreAuthorize("@wordAccessHandler.ownershipCheck(#wordId)")
    public void increaseIncorrectCount(UUID wordId) {
        Word word = wordRepository.findById(wordId)
                .orElseThrow(() -> new ApiException(NO_WORD));
        rateRepository.increaseIncorrectCount(word);
    }

    private Difficulty getDifficulty(Integer correct, Integer incorrect) {
        double diff = calcDifficultyRatio(correct, incorrect);

        if (diff < 0.3) {
            return Difficulty.EASY;
        } else if (diff > 0.7) {
            return Difficulty.HARD;
        }

        return Difficulty.NORMAL;
    }

    private double calcDifficultyRatio(Integer correct, Integer incorrect) {
        /*
            난이도 함수 : -0.04correct + 0.05incorrect + 0.5
        */
        double diff = (-0.04 * correct) + (0.05 * incorrect) + 0.5;
        if (diff > 1) {
            diff = 1;
        } else if (diff < 0) {
            diff = 0;
        }

        return diff;
    }
}
