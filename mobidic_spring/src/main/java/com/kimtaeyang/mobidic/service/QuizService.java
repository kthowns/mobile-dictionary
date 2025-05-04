package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.exception.ApiException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import static com.kimtaeyang.mobidic.code.AuthResponseCode.INVALID_TOKEN;

@Service
@RequiredArgsConstructor
@Slf4j
public class QuizService {
    private final WordService wordService;
    private final RedisTemplate<String, String> redisTemplate;
    private static final String QUIZ_PREFIX = "quiz:";
    private static final Long min = 60000L;

    private HashMap<String, List<String>> generateQuiz() {
       // if(isTokenLogout(token)) {
        //    throw new ApiException(INVALID_TOKEN);
       // }

        //redisTemplate.opsForValue().set(
        //        WITHDRAWN_PREFIX + jwtUtil.getIdFromToken(token),
        //        "true",
         //       Duration.ofMillis(exp)
        //);

        ArrayList<String> quizs = new ArrayList<>();
        HashMap<String, List<String>> response = new HashMap<>();

        response.put("quiz", quizs);

        return response;
    }
}
