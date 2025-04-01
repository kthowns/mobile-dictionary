package com.kimtaeyang.mobidic.exception;

import com.kimtaeyang.mobidic.dto.ApiResponse;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import static com.kimtaeyang.mobidic.code.AuthResponseCode.INVALID_PASSWORD;
import static com.kimtaeyang.mobidic.code.AuthResponseCode.INVALID_USERNAME;
import static com.kimtaeyang.mobidic.code.GeneralResponseCode.INTERNAL_SERVER_ERROR;

@Slf4j
@RestControllerAdvice(annotations = RestController.class)
public class ApiExceptionHandler {
    @ExceptionHandler(InternalAuthenticationServiceException.class)
    public ResponseEntity<?> noMember(
            InternalAuthenticationServiceException e, HttpServletRequest request
    ) {
        log.error("errorCode : {}, uri : {}, message : {}",
                e, request.getRequestURI(), e.getMessage());
        if(e.getCause() instanceof UsernameNotFoundException) {
            return ApiResponse.toResponseEntity(INVALID_USERNAME, null);
        }
        return ApiResponse.toResponseEntity(INTERNAL_SERVER_ERROR, null);
    }

    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<?> badCredentials(
            BadCredentialsException e, HttpServletRequest request
    ) {
        log.error("errorCode : {}, uri : {}, message : {}",
                e, request.getRequestURI(), e.getMessage());
        return ApiResponse.toResponseEntity(INVALID_PASSWORD, null);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> handleCustomException(
            Exception e, HttpServletRequest request
    ) {
        log.error("errorCode : {}, uri : {}, message : {}",
                e, request.getRequestURI(), e.getMessage());

        return ApiResponse.toResponseEntity(INTERNAL_SERVER_ERROR, null);
    }
}
