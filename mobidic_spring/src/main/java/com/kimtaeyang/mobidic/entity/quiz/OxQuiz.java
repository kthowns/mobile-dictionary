package com.kimtaeyang.mobidic.entity.quiz;

import com.kimtaeyang.mobidic.dto.WordDetailDto;
import com.kimtaeyang.mobidic.dto.quiz.QuizRateDto;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;

@Slf4j
public class OxQuiz extends Quiz {
    public OxQuiz(UUID memberId, List<WordDetailDto> orgWords) {
        super(memberId, orgWords);
    }

    @Override
    public List<Question> generateQuestions(List<WordDetailDto> orgWords) {
        List<WordDetailDto> words = new ArrayList<>(orgWords);

        ArrayList<String> options = new ArrayList<>();
        ArrayList<Question> questions = new ArrayList<>(words.size());

        for (WordDetailDto word : words) {
            String option = "";

            if (word.getDefs() != null && !word.getDefs().isEmpty()) {
                int randIdx = ThreadLocalRandom.current().nextInt(word.getDefs().size());
                option = word.getDefs().get(randIdx).getDefinition();
            }

            options.add(option);
            questions.add(
                    Question.builder()
                            .id(UUID.randomUUID())
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
    public boolean rate(String questionToken, QuizRateDto.Request request) {

        return false;
    }
}
