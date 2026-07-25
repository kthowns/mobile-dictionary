package com.kthowns.mobidic.api.quiz.dto.response;

import com.kthowns.mobidic.domain.quiz.model.QuizInfo;

import java.util.List;

public record QuizResponse(
        String token,
        String stem,
        long expMil,
        List<String> options
) {
    public static QuizResponse fromModel(QuizInfo quiz) {
        return new QuizResponse(quiz.token(), quiz.stem(), quiz.expMil(), quiz.options());
    }
}
