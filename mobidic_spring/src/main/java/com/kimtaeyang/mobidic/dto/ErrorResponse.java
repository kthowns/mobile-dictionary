package com.kimtaeyang.mobidic.dto;

import com.kimtaeyang.mobidic.code.ApiResponseCode;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.http.ResponseEntity;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ErrorResponse<T> {
    private Integer status;
    private String message;
    private T errors;

    public static <T> ResponseEntity<?> toResponseEntity(ApiResponseCode responseCode, T errors) {
        return ResponseEntity.status(responseCode.getStatus())
                .body(ErrorResponse.fromData(
                        responseCode, errors));
    }

    private static <T> ErrorResponse<?> fromData(ApiResponseCode responseCode, T errors) {
        return ErrorResponse.builder()
                .errors(errors)
                .message(responseCode.getMessage())
                .status(responseCode.getStatus().value())
                .build();
    }
}