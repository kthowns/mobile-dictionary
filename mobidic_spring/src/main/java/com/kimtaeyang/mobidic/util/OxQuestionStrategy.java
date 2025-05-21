package com.kimtaeyang.mobidic.util;

import com.kimtaeyang.mobidic.dto.QuestionRateDto;
import com.kimtaeyang.mobidic.dto.WordDetailDto;
import com.kimtaeyang.mobidic.entity.Question;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;

public class OxQuestionStrategy extends QuestionStrategy {
    @Override
    public List<Question> generateQuestions(UUID memberId, List<WordDetailDto> orgWords) {
        List<WordDetailDto> words = new ArrayList<>(orgWords);

        ArrayList<String> options = new ArrayList<>();
        ArrayList<Question> questions = new ArrayList<>();

        for (WordDetailDto word : words) {
            String option = null;

            if (word.getDefs() != null && !word.getDefs().isEmpty()) {
                int randIdx = ThreadLocalRandom.current().nextInt(word.getDefs().size());
                option = word.getDefs().get(randIdx).getDefinition();
            }

            options.add(option);
            questions.add(
                    Question.builder()
                            .id(UUID.randomUUID())
                            .wordId(word.getId())
                            .memberId(memberId)
                            .stem(word.getExpression())
                            .answer(option)
                            .build()
            );
        }
        partialShuffle((options.size() / 2) + 1, options);

        for (int i = 0; i < words.size(); i++) {
            questions.get(i).setOptions(List.of(options.get(i)));
        }

        return questions;
    }

    @Override
    public boolean rate(QuestionRateDto.Request request, String correctAnswer) {
        return request.getAnswer().equals(correctAnswer);
    }
}
