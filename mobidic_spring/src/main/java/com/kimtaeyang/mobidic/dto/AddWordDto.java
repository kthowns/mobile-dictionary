package com.kimtaeyang.mobidic.dto;

import com.kimtaeyang.mobidic.entity.Word;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

public class AddWordDto {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Request {
        @NotBlank
        @Size(min = 1, max = 64, message = "Invalid expression pattern")
        private String expression;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Response {
        private UUID id;
        private String expression;

        public static Response fromEntity(Word word) {
            return builder()
                    .id(word.getId())
                    .expression(word.getExpression())
                    .build();
        }
    }
}
