package com.kimtaeyang.mobidic.code;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@AllArgsConstructor
@Getter
public enum AuthResponseCode implements ApiResponseCode {
    CREATED(HttpStatus.CREATED, "Join complete"),
    NO_MEMBER(HttpStatus.NOT_FOUND, "No member found"),
    INVALID_USERNAME(HttpStatus.NOT_FOUND, "Invalid username"),
    INVALID_PASSWORD(HttpStatus.UNAUTHORIZED, "Invalid password"),
    JOIN_OK(HttpStatus.OK, "Join success"),
    LOGIN_OK(HttpStatus.OK, "Login success");

    private final HttpStatus status;
    private final String message;
}
