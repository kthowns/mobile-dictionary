package com.kimtaeyang.mobidic.code;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@AllArgsConstructor
@Getter
public enum GeneralResponseCode implements ApiResponseCode {
    OK(HttpStatus.OK, "OK"),
    NOT_FOUND(HttpStatus.NOT_FOUND, "Not found"),
    INVALID_REQUEST(HttpStatus.NOT_FOUND, "Invalid Request"),
    NO_VOCAB(HttpStatus.NOT_FOUND, "No vocab found"),
    NO_WORD(HttpStatus.NOT_FOUND, "No word found"),
    NO_DEF(HttpStatus.NOT_FOUND, "No def found"),
    NO_THEME(HttpStatus.NOT_FOUND, "No theme found"),
    NO_STATS(HttpStatus.NOT_FOUND, "No stats found"),
    DUPLICATED_TITLE(HttpStatus.CONFLICT, "Title is duplicated"),
    DUPLICATED_WORD(HttpStatus.CONFLICT, "Word is duplicated"),
    DUPLICATED_DEFINITION(HttpStatus.CONFLICT, "Definition is duplicated"),
    BAD_REQUEST(HttpStatus.BAD_REQUEST, "Method is not supported"),
    INVALID_REQUEST_BODY(HttpStatus.BAD_REQUEST, "Invalid request Body"),
    FORBIDDEN(HttpStatus.FORBIDDEN, "Forbidden request"),
    INVALID_TOKEN(HttpStatus.UNAUTHORIZED, "Invalid token"),
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "Internal server error");

    private final HttpStatus status;
    private final String message;
}
