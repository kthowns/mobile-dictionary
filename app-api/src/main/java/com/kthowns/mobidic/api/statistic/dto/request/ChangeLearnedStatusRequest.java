package com.kthowns.mobidic.api.statistic.dto.request;

import jakarta.validation.constraints.NotNull;

public record ChangeLearnedStatusRequest(
        @NotNull(message = "상태 값은 필수 입력값입니다.")
        Boolean isLearned
) {
}
