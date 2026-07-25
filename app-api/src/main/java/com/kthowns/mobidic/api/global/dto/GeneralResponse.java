package com.kthowns.mobidic.api.global.dto;

import com.kthowns.mobidic.common.code.ApiResponseCode;
import org.springframework.http.ResponseEntity;

public record GeneralResponse<T>(
        Integer status,
        String message,
        T data
) {
    public static <T> ResponseEntity<GeneralResponse<T>> toResponseEntity(ApiResponseCode responseCode, T data) {
        return ResponseEntity.status(responseCode.getStatus())
                .body(GeneralResponse.fromData(
                        responseCode, data));
    }

    private static <T> GeneralResponse<T> fromData(ApiResponseCode responseCode, T data) {
        return new GeneralResponse<>(responseCode.getStatus().value(), responseCode.getMessage(), data);
    }
}
