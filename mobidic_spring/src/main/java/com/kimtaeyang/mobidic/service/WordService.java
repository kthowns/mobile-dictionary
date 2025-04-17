package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.dto.AddWordDto;
import com.kimtaeyang.mobidic.dto.WordDetailDto;
import com.kimtaeyang.mobidic.dto.WordDto;
import com.kimtaeyang.mobidic.entity.Def;
import com.kimtaeyang.mobidic.entity.Rate;
import com.kimtaeyang.mobidic.entity.Vocab;
import com.kimtaeyang.mobidic.entity.Word;
import com.kimtaeyang.mobidic.exception.ApiException;
import com.kimtaeyang.mobidic.repository.DefRepository;
import com.kimtaeyang.mobidic.repository.RateRepository;
import com.kimtaeyang.mobidic.repository.VocabRepository;
import com.kimtaeyang.mobidic.repository.WordRepository;
import com.kimtaeyang.mobidic.type.Difficulty;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import static com.kimtaeyang.mobidic.code.GeneralResponseCode.*;

@Service
@Slf4j
@RequiredArgsConstructor
public class WordService {
    private final WordRepository wordRepository;
    private final VocabRepository vocabRepository;
    private final DefRepository defRepository;
    private final RateRepository rateRepository;

    @Transactional
    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#vocabId)")
    public AddWordDto.Response addWord(UUID vocabId, AddWordDto.Request request) {
        Vocab vocab = vocabRepository.findById(vocabId)
                        .orElseThrow(() -> new ApiException(NO_VOCAB));

        wordRepository.findByExpression(request.getExpression())
                .ifPresent((w) -> { throw new ApiException(DUPLICATED_WORD); });

        Word word = Word.builder()
                .expression(request.getExpression())
                .vocab(vocab)
                .build();
        wordRepository.save(word);

        Rate rate = Rate.builder()
                .word(word)
                .correctCount(0)
                .incorrectCount(0)
                .isLearned(0)
                .build();
        rateRepository.save(rate);

        return AddWordDto.Response.fromEntity(word);
    }

    @Transactional(readOnly = true)
    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#vId)")
    public List<WordDetailDto> getWordsByVocabId(UUID vId) {
        Vocab vocab = vocabRepository.findById(vId)
                .orElseThrow(() -> new ApiException(NO_VOCAB));

        return wordRepository.findByVocab(vocab)
                .stream().map((word) -> {
                    Rate rate = rateRepository.findRateByWord(word)
                            .orElseThrow(() -> new ApiException(INTERNAL_SERVER_ERROR));

                    List<Def> defs = defRepository.findByWord(word);

                    Difficulty diff = getDifficulty(rate.getCorrectCount(), rate.getIncorrectCount());

                    return WordDetailDto.fromEntity(word, defs, diff);
                }).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#wId)")
    public WordDetailDto getWordDetail(UUID wId) {
        Word word = wordRepository.findById(wId)
                .orElseThrow(() -> new ApiException(NO_WORD));

        List<Def> defs = defRepository.findByWord(word);

        Rate rate = rateRepository.findRateByWord(word)
                .orElseThrow(() -> new ApiException(INTERNAL_SERVER_ERROR));

        Difficulty diff = getDifficulty(rate.getCorrectCount(), rate.getIncorrectCount());

        return WordDetailDto.fromEntity(word, defs, diff);
    }

    @Transactional
    @PreAuthorize("@wordAccessHandler.ownershipCheck(#wordId)")
    public AddWordDto.Response updateWord(UUID wordId, AddWordDto.Request request) {
        Word word = wordRepository.findById(wordId)
                .orElseThrow(() -> new ApiException(NO_WORD));

        wordRepository.findByExpression(request.getExpression())
                        .ifPresent((w) -> { throw new ApiException(DUPLICATED_WORD); });

        word.setExpression(request.getExpression());
        wordRepository.save(word);

        return AddWordDto.Response.fromEntity(word);
    }

    @Transactional
    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#wordId)")
    public WordDto deleteWord(UUID wordId) {
        Word word = wordRepository.findById(wordId)
                .orElseThrow(() -> new ApiException(NO_WORD));

        wordRepository.delete(word);

        return WordDto.fromEntity(word);
    }

    private Difficulty getDifficulty(Integer correct, Integer incorrect) {
        double diff = calcDifficultyRatio(correct, incorrect);

        if(diff < 0.3){
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
        if (diff > 1){
            diff = 1;
        }
        else if (diff < 0){
            diff = 0;
        }

        return diff;
    }
}
