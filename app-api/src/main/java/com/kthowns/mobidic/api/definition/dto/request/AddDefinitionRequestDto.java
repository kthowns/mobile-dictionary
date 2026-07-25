package com.kthowns.mobidic.api.definition.dto.request;

import com.kthowns.mobidic.domain.definition.model.PartOfSpeech;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record AddDefinitionRequestDto(
        @NotBlank(message = "뜻은 필수 입력값 입니다.")
        @Size(max = 32, message = "32자 미만이어야 합니다.")
        String meaning,
        @NotNull(message = "품사는 필수 입력값 입니다.")
        PartOfSpeech part
) {
}