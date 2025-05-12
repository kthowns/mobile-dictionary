package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.config.JwtProperties;
import com.kimtaeyang.mobidic.dto.DefDto;
import com.kimtaeyang.mobidic.dto.WordDetailDto;
import com.kimtaeyang.mobidic.dto.quiz.QuizDto;
import com.kimtaeyang.mobidic.entity.quiz.Question;
import com.kimtaeyang.mobidic.security.JwtUtil;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.given;

@ExtendWith(SpringExtension.class)
@TestPropertySource(properties = {
        "jwt.secret=qwerqwerqwerqwerqwerqwerqwerqwer",
        "jwt.exp=3600"
})
@ContextConfiguration(classes = {QuizService.class, QuizServiceTest.TestConfig.class})
@ActiveProfiles("dev")
public class QuizServiceTest {
    @Autowired
    private QuizService quizService;

    @Autowired
    private JwtProperties jwtProperties;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private WordService wordService;

    @Autowired
    private ValueOperations<String, Object> valueOperations;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;


    @Test
    @DisplayName("[QuizService] Generate OX quiz")
    void generateOxQuiz() {
        List<WordDetailDto> words = List.of(
                WordDetailDto.builder()
                        .id(UUID.randomUUID())
                        .expression("Apple")
                        .defs(List.of(
                                DefDto.builder()
                                        .id(UUID.randomUUID())
                                        .definition("사과")
                                        .build()
                        ))
                        .build(),
                WordDetailDto.builder()
                        .id(UUID.randomUUID())
                        .expression("Hello")
                        .defs(List.of(
                                DefDto.builder()
                                        .id(UUID.randomUUID())
                                        .definition("안녕")
                                        .build()
                        ))
                        .build(),
                WordDetailDto.builder()
                        .id(UUID.randomUUID())
                        .expression("Run")
                        .defs(List.of(
                                DefDto.builder()
                                        .id(UUID.randomUUID())
                                        .definition("뛰다")
                                        .build()
                        ))
                        .build(),
                WordDetailDto.builder()
                        .id(UUID.randomUUID())
                        .expression("Idiot")
                        .defs(List.of(
                                DefDto.builder()
                                        .id(UUID.randomUUID())
                                        .definition("병신")
                                        .build()
                        ))
                        .build(),
                WordDetailDto.builder()
                        .id(UUID.randomUUID())
                        .expression("Media")
                        .defs(List.of(
                                DefDto.builder()
                                        .id(UUID.randomUUID())
                                        .definition("매체")
                                        .build()
                        ))
                        .build());

        //given
        given(wordService.getWordsByVocabId(any(UUID.class)))
                .willReturn(words);
        given(redisTemplate.opsForValue())
                .willReturn(valueOperations);

        int epoch = 10;
        int assertCnt = 0;

        for(int i = 0; i < epoch; i++){
            //when
            QuizDto result = quizService.getOxQuiz(UUID.randomUUID(), UUID.randomUUID());

            //then
            int matchCnt = 0;
            for(Question question : result.getQuestions()) {
                for(WordDetailDto word : words){
                    if(question.getStem().equals(word.getExpression())
                            && question.getOptions().getFirst().equals(word.getDefs().getFirst().getDefinition())) {
                        matchCnt++;
                        break;
                    }
                }
            }

            if(matchCnt < (words.size()/2) + 1){
                assertCnt++;
            }
        }

        assertEquals(epoch, assertCnt);
    }

    @TestConfiguration
    static class TestConfig {
        @Bean
        public WordService wordService() {
            return Mockito.mock(WordService.class);
        }

        @Bean
        public JwtProperties jwtProperties() {
            return new JwtProperties();
        }

        @Bean
        public JwtUtil jwtUtil() {
            return new JwtUtil(jwtProperties());
        }

        @Bean
        public RedisTemplate redisTemplate() { return Mockito.mock(RedisTemplate.class); }

        @Bean
        public ValueOperations valueOperations() { return Mockito.mock(ValueOperations.class); }
    }
}
