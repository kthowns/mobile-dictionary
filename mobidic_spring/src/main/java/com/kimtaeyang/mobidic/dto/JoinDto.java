package com.kimtaeyang.mobidic.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

public class JoinDto {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Request{
        @NotBlank
        @Size(min = 2, max = 100)
        @Email
        private String email;

        @NotBlank
        @Pattern(regexp = "^[ㄱ-ㅎ가-힣a-z0-9-_]{2,16}$")
        private String nickname;

        @NotBlank
        @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,128}$")
        //최소 8자, 숫자와 알파벳
        private String password;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Response{
        private String email;
        private String nickname;
    }
}
