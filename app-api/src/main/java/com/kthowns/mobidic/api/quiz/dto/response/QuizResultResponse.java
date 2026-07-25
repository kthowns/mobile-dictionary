package com.kthowns.mobidic.api.quiz.dto.response;

import com.kthowns.mobidic.domain.quiz.model.QuizResult;

public record QuizResultResponse(
        Boolean isCorrect,
        String correctAnswer
) {
    public static QuizResultResponse fromModel(QuizResult quizResult) {
        return new QuizResultResponse(quizResult.isCorrect(), quizResult.correctAnswer());
    }
}