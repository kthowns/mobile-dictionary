package com.kimtaeyang.mobidic.util;

import com.kimtaeyang.mobidic.dto.QuestionRateDto;
import com.kimtaeyang.mobidic.dto.WordDetailDto;
import com.kimtaeyang.mobidic.entity.Question;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;

public class BlankQuestionStrategy extends QuestionStrategy {
    @Override
    public List<Question> generateQuestions(UUID memberId, List<WordDetailDto> orgWords) {
        List<WordDetailDto> words = new ArrayList<>(orgWords);

        //option은 뜻
        ArrayList<String> options = new ArrayList<>();
        ArrayList<Question> questions = new ArrayList<>(words.size());

        for (WordDetailDto word : words) {
            String option = "";

            if (word.getDefs() != null && !word.getDefs().isEmpty()) {
                int randIdx = ThreadLocalRandom.current().nextInt(word.getDefs().size());
                option = word.getDefs().get(randIdx).getDefinition();
            }

            options.add(option);

            List<Integer> nums = new ArrayList<>();
            for (int i = 0; i < word.getExpression().length(); i++) {
                nums.add(i);
            }
            int blankCount = nums.size() / 2 + 1;
            derange(nums);

            List<Integer> indices = new ArrayList<>();
            for (int i = 0; i < blankCount; i++) {
                indices.add(nums.get(i));
            }
            Collections.sort(indices);

            char[] stem = word.getExpression().toCharArray();
            StringBuilder answer = new StringBuilder();
            for (int idx : indices) {
                answer.append(stem[idx]);
                stem[idx] = '_';
            }

            questions.add(
                    Question.builder()
                            .id(UUID.randomUUID())
                            .wordId(word.getId())
                            .memberId(memberId)
                            .stem(new String(stem))
                            .answer(answer.toString())
                            .build()
            );
        }

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
