package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.dto.QuestionDto;
import com.kimtaeyang.mobidic.dto.QuestionRateDto;
import com.kimtaeyang.mobidic.dto.VocabDto;
import com.kimtaeyang.mobidic.dto.WordDetailDto;
import com.kimtaeyang.mobidic.entity.Question;
import com.kimtaeyang.mobidic.exception.ApiException;
import com.kimtaeyang.mobidic.security.JwtUtil;
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
import java.util.Date;
import java.util.List;
import java.util.UUID;

import static com.kimtaeyang.mobidic.code.GeneralResponseCode.INVALID_REQUEST;
import static com.kimtaeyang.mobidic.code.GeneralResponseCode.REQUEST_TIMEOUT;

@Service
@RequiredArgsConstructor
@Slf4j
public class QuestionService {
    private final WordService wordService;
    private final JwtUtil jwtUtil;
    private static final String QUESTION_PREFIX = "question:";
    private final RedisTemplate<String, String> redisTemplate;
    private static final Long min = 60000L;
    private final VocabService vocabService;

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


    private List<QuestionDto> generateQuestions(UUID vocabId, QuestionStrategy strategy) {
        VocabDto vocab = vocabService.getVocabById(vocabId);
        List<WordDetailDto> words = wordService.getWordsByVocabId(vocabId);
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
        String correctAnswer = findCorrectAnswer(request.getToken());
        expireAnswer(request.getToken());

        return QuestionRateDto.Response.builder()
                .isCorrect(QuestionUtil.rate(strategy, request, correctAnswer))
                .correctAnswer(correctAnswer)
                .build();
    }

    private String registerQuestion(Question question) {
        String token = jwtUtil.generateToken(question.getMemberId(), jwt -> jwt
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + min))
                .claim("qId", question.getId())
        );

        redisTemplate.opsForValue().set(
                QUESTION_PREFIX + token,
                question.getAnswer(),
                Duration.ofMillis(min)
        );

        return token;
    }

    private String findCorrectAnswer(String token) {
        validateQuestion(token);
        String correctAnswer = redisTemplate.opsForValue().get(QUESTION_PREFIX + token);
        if (correctAnswer == null) {
            throw new ApiException(REQUEST_TIMEOUT);
        }

        return correctAnswer;
    }

    private boolean expireAnswer(String token) {
        return redisTemplate.delete(QUESTION_PREFIX + token);
    }

    private void validateQuestion(String token) {
        if (!jwtUtil.validateToken(token)) {
            throw new ApiException(INVALID_REQUEST);
        }
        if (!redisTemplate.hasKey(QUESTION_PREFIX + token)) {
            throw new ApiException(REQUEST_TIMEOUT);
        }
    }
}