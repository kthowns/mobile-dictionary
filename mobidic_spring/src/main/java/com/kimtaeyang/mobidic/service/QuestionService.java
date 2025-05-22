package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.dto.QuestionDto;
import com.kimtaeyang.mobidic.dto.QuestionRateDto;
import com.kimtaeyang.mobidic.dto.VocabDto;
import com.kimtaeyang.mobidic.dto.WordDetailDto;
import com.kimtaeyang.mobidic.entity.Question;
import com.kimtaeyang.mobidic.exception.ApiException;
import com.kimtaeyang.mobidic.util.BlankQuestionStrategy;
import com.kimtaeyang.mobidic.util.OxQuestionStrategy;
import com.kimtaeyang.mobidic.util.QuestionStrategy;
import com.kimtaeyang.mobidic.util.QuestionUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import static com.kimtaeyang.mobidic.code.GeneralResponseCode.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class QuestionService {
    private final WordService wordService;
    private static final String QUESTION_PREFIX = "question";
    private final RedisTemplate<String, String> redisTemplate;
    private static final Long min = 60000L;
    private final VocabService vocabService;
    private final RateService rateService;
    private final CryptoService cryptoService;

    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#vocabId)")
    public List<QuestionDto> getOxQuestions(UUID vocabId) {
        return generateQuestions(vocabId, new OxQuestionStrategy());
    }

    @PreAuthorize("@memberAccessHandler.ownershipCheck(#memberId)")
    public QuestionRateDto.Response rateOxQuestion(UUID memberId, QuestionRateDto.Request request) {
        return rateQuestion(request, new OxQuestionStrategy());
    }

    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#vocabId)")
    public List<QuestionDto> getBlankQuestions(UUID vocabId) {
        return generateQuestions(vocabId, new BlankQuestionStrategy());
    }

    @PreAuthorize("@memberAccessHandler.ownershipCheck(#memberId)")
    public QuestionRateDto.Response rateBlankQuestion(UUID memberId, QuestionRateDto.Request request) {
        return rateQuestion(request, new BlankQuestionStrategy());
    }

    private List<QuestionDto> generateQuestions(UUID vocabId, QuestionStrategy strategy) {
        VocabDto vocab = vocabService.getVocabById(vocabId);
        List<WordDetailDto> words = wordService.getWordsByVocabId(vocabId);
        if (words.isEmpty()) {
            throw new ApiException(EMPTY_VOCAB);
        }
        List<Question> questions = QuestionUtil.generateQuiz(vocab.getMemberId(), strategy, words);
        List<QuestionDto> questionDtos = new ArrayList<>();
        for (Question question : questions) {
            String token = registerQuestion(question);
            questionDtos.add(QuestionDto.builder()
                    .token(token)
                    .options(question.getOptions())
                    .stem(question.getStem())
                    .build());
        }

        return questionDtos;
    }

    private QuestionRateDto.Response rateQuestion(
            QuestionRateDto.Request request,
            QuestionStrategy strategy
    ) {
        String key = cryptoService.decrypt(request.getToken()); //복호화
        String correctAnswer = findCorrectAnswer(key);
        System.out.println("Correct answer: " + correctAnswer);
        expireAnswer(key);

        UUID wordId = UUID.fromString(key.split(":")[2]);
        QuestionRateDto.Response response = QuestionRateDto.Response.builder()
                .isCorrect(QuestionUtil.rate(strategy, request, correctAnswer))
                .correctAnswer(correctAnswer)
                .build();

        if (response.getIsCorrect()) {
            rateService.increaseCorrectCount(wordId);
        } else {
            rateService.increaseIncorrectCount(wordId);
        }

        return response;
    }

    private String registerQuestion(Question question) {
        String key = QUESTION_PREFIX
                + ":" + question.getMemberId()
                + ":" + question.getWordId()
                + ":" + question.getId();

        redisTemplate.opsForValue().set(
                key,
                question.getAnswer(),
                Duration.ofMillis(min)
        );

        return cryptoService.encrypt(key); //암호화
    }

    private String findCorrectAnswer(String token) {
        validateQuestion(token);
        String correctAnswer = redisTemplate.opsForValue().get(token);
        if (correctAnswer == null) {
            throw new ApiException(REQUEST_TIMEOUT);
        }

        return correctAnswer;
    }

    private void expireAnswer(String token) {
        redisTemplate.delete(token);
    }

    private void validateQuestion(String token) {
        if (!token.split(":")[0].equals(QUESTION_PREFIX)) {
            throw new ApiException(INVALID_REQUEST);
        }
        if (!redisTemplate.hasKey(token)) {
            throw new ApiException(REQUEST_TIMEOUT);
        }
    }
}