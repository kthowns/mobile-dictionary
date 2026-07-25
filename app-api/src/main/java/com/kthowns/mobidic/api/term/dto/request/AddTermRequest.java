package com.kthowns.mobidic.api.term.dto.request;

import com.kthowns.mobidic.domain.term.model.TermType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record AddTermRequest(
        @NotNull(message = "약관 유형은 필수 입력값입니다.")
        TermType type,
        @NotBlank(message = "버전은 필수 입력값입니다.")
        String version,
        @NotNull(message = "필수 동의 여부는 필수 입력값입니다.")
        boolean required,
        @NotBlank(message = "약관 내용은 필수 입력값입니다.")
        String content
) {
}
