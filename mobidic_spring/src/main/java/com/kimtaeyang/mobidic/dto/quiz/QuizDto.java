package com.kimtaeyang.mobidic.dto.quiz;

import com.kimtaeyang.mobidic.entity.quiz.Question;
import com.kimtaeyang.mobidic.entity.quiz.Quiz;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class QuizDto {
        private String token;
        private List<Question> questions;

        public static QuizDto fromDomain(Quiz quiz, String token) {
                return QuizDto.builder()
                        .token(token)
                        .questions(quiz.getQuestions())
                        .build();
        }
}
