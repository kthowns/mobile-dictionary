package com.kthowns.mobidic.api.quiz.dto.request;

import jakarta.validation.constraints.NotBlank;

public record QuizRateRequest(
        @NotBlank(message = "토큰은 필수 입력값 입니다.")
        String token,
        @NotBlank(message = "답안은 필수 입력값 입니다.")
        String answer
) {
}