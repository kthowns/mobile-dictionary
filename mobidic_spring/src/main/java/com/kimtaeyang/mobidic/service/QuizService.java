package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.dto.quiz.QuizDto;
import com.kimtaeyang.mobidic.entity.quiz.Quiz;
import com.kimtaeyang.mobidic.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class QuizService {
    private final RedisTemplate<String, List<String>> redisTemplate;
    private static final String QUIZ_PREFIX = "quiz:";
    private static final Long min = 60000L;
    private final JwtUtil jwtUtil;

    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#memberId)")
    public QuizDto getOxQuiz(UUID memberId, UUID vocabId) {
    }

    private String registerQuiz(UUID owner, Quiz quiz) {
        String token = jwtUtil.generateTokenWithExp(owner, min);

        redisTemplate.opsForValue().set(
                QUIZ_PREFIX + token,
                quiz.getAnswers(),
                Duration.ofMillis(min)
        );

        return token;
    }

    private boolean validateQuiz(String token){
        return !(jwtUtil.validateToken(token) || redisTemplate.hasKey(QUIZ_PREFIX + token));
    }
}
