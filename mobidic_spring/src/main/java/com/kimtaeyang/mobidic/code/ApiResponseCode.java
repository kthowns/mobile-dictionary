package com.kimtaeyang.mobidic.code;

import org.springframework.http.HttpStatus;

public interface ApiResponseCode {
    public HttpStatus getStatus();
    public String getMessage();
}
