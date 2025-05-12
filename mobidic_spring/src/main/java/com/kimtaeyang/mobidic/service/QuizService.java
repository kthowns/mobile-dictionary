package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.dto.WordDetailDto;
import com.kimtaeyang.mobidic.dto.quiz.QuizDto;
import com.kimtaeyang.mobidic.entity.quiz.OxQuiz;
import com.kimtaeyang.mobidic.entity.quiz.Quiz;
import com.kimtaeyang.mobidic.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class QuizService {
    private final WordService wordService;
    private final JwtUtil jwtUtil;
    private static final String QUIZ_PREFIX = "quiz:";
    private final RedisTemplate<String, Object> redisTemplate;
    private static final Long min = 60000L;

    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#vocabId)")
    public QuizDto getOxQuiz(UUID memberId, UUID vocabId) {
        List<WordDetailDto> words = wordService.getWordsByVocabId(vocabId);
        OxQuiz oxQuiz = new OxQuiz(memberId, words);
        String token = registerQuizAndGetToken(memberId, oxQuiz);

        return QuizDto.fromDomain(oxQuiz, token);
    }

    private String registerQuizAndGetToken(UUID owner, Quiz quiz) {
        String token = jwtUtil.generateToken(owner, jwt -> jwt
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + min))
                .claim("id", quiz.getId())
        );
        redisTemplate.opsForValue().set(
                QUIZ_PREFIX + token,
                quiz.getAnswers(),
                Duration.ofMillis(min)
        );

        return token;
    }

    private boolean validateQuiz(String token) {
        return jwtUtil.validateToken(token) && redisTemplate.hasKey(QUIZ_PREFIX + token);
    }
}
