package com.kimtaeyang.mobidic.util;

import com.kimtaeyang.mobidic.dto.QuestionRateDto;
import com.kimtaeyang.mobidic.dto.WordDetailDto;
import com.kimtaeyang.mobidic.entity.Question;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Setter
public class QuestionUtil {
    public static List<Question> generateQuiz(UUID memberId, QuestionStrategy strategy, List<WordDetailDto> words) {
        return strategy.generateQuestions(memberId, words);
    }

    public static boolean rate(QuestionStrategy strategy, QuestionRateDto.Request request, String correctAnswer) {
        return strategy.rate(request, correctAnswer);
    }
}
