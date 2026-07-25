package com.kthowns.mobidic.api.auth.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record LoginRequest(
        @NotBlank
        @Email(message = "유효하지 않은 이메일 형식입니다.")
        String email,
        @NotBlank(message = "비밀번호는 필수 입력값입니다.")
        String password
) {
}
