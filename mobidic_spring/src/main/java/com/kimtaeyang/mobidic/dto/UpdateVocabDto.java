package com.kimtaeyang.mobidic.dto;

import com.kimtaeyang.mobidic.entity.Vocab;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

public class UpdateVocabDto {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Request {
        @NotBlank
        @Size(min = 1, max = 32, message = "Invalid title pattern")
        private String title;
        @Size(max = 32, message = "Invalid description pattern")
        private String description;
    }
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Response {
        private UUID id;
        private String title;
        private String description;
        public static Response fromEntity(Vocab vocab){
            return Response.builder()
                    .id(vocab.getId())
                    .title(vocab.getTitle())
                    .description(vocab.getDescription())
                    .build();
        }
    }
}
