package com.kimtaeyang.mobidic.util;

import com.kimtaeyang.mobidic.dto.QuestionRateDto;
import com.kimtaeyang.mobidic.entity.Question;
import com.kimtaeyang.mobidic.model.WordWithDefs;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ThreadLocalRandom;

public class OxQuestionStrategy extends QuestionStrategy {
    @Override
    public List<Question> generateQuestions(UUID memberId, List<WordWithDefs> orgWordsWithDefs) {
        List<WordWithDefs> wordsWithDefs = new ArrayList<>(orgWordsWithDefs);
        derange(wordsWithDefs);

        ArrayList<String> options = new ArrayList<>();
        ArrayList<Question> questions = new ArrayList<>();

        for (WordWithDefs wordWithDefs : wordsWithDefs) {
            String option = "";
            String answer = "0";

            if (wordWithDefs.getDefDtos() != null && !wordWithDefs.getDefDtos().isEmpty()) {
                int randIdx = ThreadLocalRandom.current().nextInt(wordWithDefs.getDefDtos().size());
                option = wordWithDefs.getDefDtos().get(randIdx).getDefinition();
                if(option.equals(wordWithDefs.getDefDtos().get(randIdx).getDefinition())){
                    answer = "1";
                }
            }

            options.add(option);
            questions.add(
                    Question.builder()
                            .id(UUID.randomUUID())
                            .wordId(wordWithDefs.getWordDto().getId())
                            .memberId(memberId)
                            .stem(wordWithDefs.getWordDto().getExpression())
                            .options(options)
                            .answer(answer)
                            .build()
            );
        }
        partialShuffle((options.size() / 2) + 1, options);

        for (int i = 0; i < wordsWithDefs.size(); i++) {
            questions.get(i).setOptions(List.of(options.get(i)));
        }

        return questions;
    }

    @Override
    public boolean rate(QuestionRateDto.Request request, String correctAnswer) {
        return request.getAnswer().equals(correctAnswer);
    }
}
