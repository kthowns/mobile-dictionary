package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.dto.QuestionDto;
import com.kimtaeyang.mobidic.dto.QuestionRateDto;
import com.kimtaeyang.mobidic.dto.VocabDto;
import com.kimtaeyang.mobidic.dto.WordDto;
import com.kimtaeyang.mobidic.entity.Question;
import com.kimtaeyang.mobidic.exception.ApiException;
import com.kimtaeyang.mobidic.model.WordWithDefs;
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
    private static final Long expPerQuestion = 30000L;
    private final VocabService vocabService;
    private final RateService rateService;
    private final CryptoService cryptoService;
    private final DefService defService;

    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#vocabId)")
    public List<QuestionDto> getOxQuestions(UUID vocabId) {
        return generateQuestions(vocabId, new OxQuestionStrategy());
    }

    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#vocabId)")
    public List<QuestionDto> getBlankQuestions(UUID vocabId) {
        return generateQuestions(vocabId, new BlankQuestionStrategy());
    }

    @PreAuthorize("@memberAccessHandler.ownershipCheck(#memberId)")
    public QuestionRateDto.Response rateQuestion(
            UUID memberId,
            QuestionRateDto.Request request
    ) {
        String key = cryptoService.decrypt(request.getToken()); //복호화
        String correctAnswer = findCorrectAnswer(key);
        expireAnswer(key);

        UUID wordId = UUID.fromString(key.split(":")[2]);
        QuestionRateDto.Response response = QuestionRateDto.Response.builder()
                .isCorrect(request.getAnswer().equals(correctAnswer))
                .correctAnswer(correctAnswer)
                .build();

        if (response.getIsCorrect()) {
            rateService.increaseCorrectCount(wordId);
        } else {
            rateService.increaseIncorrectCount(wordId);
        }

        return response;
    }

    private List<QuestionDto> generateQuestions(UUID vocabId, QuestionStrategy strategy) {
        VocabDto vocab = vocabService.getVocabById(vocabId);

        List<WordWithDefs> wordsWithDefs = new ArrayList<>();
        List<WordDto> wordDtos = wordService.getWordsByVocabId(vocab.getId());
        for (WordDto wordDto : wordDtos) {
            WordWithDefs wordWithDefs = WordWithDefs.builder()
                    .wordDto(wordDto)
                    .defDtos(defService.getDefsByWordId(wordDto.getId()))
                    .build();

            wordsWithDefs.add(wordWithDefs);
        }

        if (wordsWithDefs.isEmpty()) {
            throw new ApiException(EMPTY_VOCAB);
        }

        List<Question> questions = QuestionUtil.generateQuiz(vocab.getMemberId(), strategy, wordsWithDefs);
        List<QuestionDto> questionDtos = new ArrayList<>();
        for (Question question : questions) {
            String token = registerQuestion(question, questions.size());
            questionDtos.add(QuestionDto.builder()
                    .token(token)
                    .options(question.getOptions())
                    .stem(question.getStem())
                    .build());
        }

        return questionDtos;
    }

    private String registerQuestion(Question question, int questionAmount) {
        String key = QUESTION_PREFIX
                + ":" + question.getMemberId()
                + ":" + question.getWordId()
                + ":" + question.getId();

        redisTemplate.opsForValue().set(
                key,
                question.getAnswer(),
                Duration.ofMillis(expPerQuestion * questionAmount)
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