package com.kthowns.mobidic.api.global.dto;

import com.kthowns.mobidic.common.code.ApiResponseCode;
import org.springframework.http.ResponseEntity;

import java.util.HashMap;

public record ErrorResponse(
        Integer status,
        String message,
        HashMap<String, String> errors
) {

    public static ResponseEntity<ErrorResponse> toResponseEntity(ApiResponseCode responseCode, HashMap<String, String> errors) {
        return ResponseEntity.status(responseCode.getStatus())
                .body(ErrorResponse.fromData(
                        responseCode, errors));
    }

    private static ErrorResponse fromData(ApiResponseCode responseCode, HashMap<String, String> errors) {
        return new ErrorResponse(responseCode.getStatus().value(), responseCode.getMessage(), errors);
    }
}