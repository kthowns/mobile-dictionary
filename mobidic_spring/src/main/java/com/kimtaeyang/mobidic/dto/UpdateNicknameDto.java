package com.kimtaeyang.mobidic.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

public class UpdateNicknameDto {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Request {
        @NotBlank
        @Pattern(regexp = "^[ㄱ-ㅎ가-힣a-z0-9-_]{2,16}$")
        private String nickname;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Response {
        private UUID id;
        private String nickname;
    }
}
