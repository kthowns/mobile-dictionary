package com.kimtaeyang.mobidic.entity.quiz;

import com.kimtaeyang.mobidic.dto.WordDetailDto;
import com.kimtaeyang.mobidic.dto.quiz.QuizRateDto;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Getter
@Setter(AccessLevel.PROTECTED)
@Slf4j
public abstract class Quiz {
    private UUID id;
    private UUID owner;
    private List<Question> questions;
    private List<String> answers;

    abstract protected List<Question> generateQuestions(List<WordDetailDto> orgWords);
    abstract public boolean rate(String questionToken, QuizRateDto.Request request);

    protected Quiz(UUID memberId, List<WordDetailDto> orgWords) {
        List<WordDetailDto> words = new ArrayList<>(orgWords);
        derange(words); //derangement
        setId(UUID.randomUUID());
        setOwner(memberId);
        setQuestions(generateQuestions(words));
        setAnswers(generateAnswers());
    }

    protected List<String> generateAnswers() {
        return getQuestions().stream().map(Question::getAnswer).collect(Collectors.toList());
    }

    protected static <T> void partialShuffle(int n, List<T> list) {
        List<Integer> nums = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            nums.add(i);
        }
        derange(nums);

        ArrayList<Integer> indices = new ArrayList<>();
        for (int i = 0; i < n; i++) {
            indices.add(nums.get(i));
        }

        ArrayList<T> selectedValues = new ArrayList<>();
        for (Integer idx : indices) {
            selectedValues.add(list.get(idx));
        }
        derange(selectedValues);

        for (int i = 0; i < indices.size(); i++){
            list.set(indices.get(i), selectedValues.get(i));
        }
    }

    protected static <T> void derange(List<T> list) {
        if (list == null || list.size() < 2) {
            return;
        }
        List<T> orgList = new ArrayList<>(list);
        while (true) { //complete derangement
            Collections.shuffle(list);
            boolean isDerangement = true;
            for (int i = 0; i < list.size(); i++) {
                if (list.get(i) == orgList.get(i)) {
                    isDerangement = false;
                    break;
                }
            }
            if (isDerangement) {
                return;
            }
            log.info("Derangement detected : {}", list);
        }
    }
}
