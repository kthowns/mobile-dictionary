package com.kimtaeyang.mobidic.exception;

import com.kimtaeyang.mobidic.dto.ApiResponse;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.authorization.AuthorizationDeniedException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import static com.kimtaeyang.mobidic.code.AuthResponseCode.*;
import static com.kimtaeyang.mobidic.code.GeneralResponseCode.FORBIDDEN;
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

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<?> methodNotSupported(
            HttpRequestMethodNotSupportedException e, HttpServletRequest request
    ) {
        log.error("errorCode : {}, uri : {}, message : {}",
                e, request.getRequestURI(), e.getMessage());
        return ApiResponse.toResponseEntity(FORBIDDEN, null);
    }

    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<?> badCredentials(
            BadCredentialsException e, HttpServletRequest request
    ) {
        log.error("errorCode : {}, uri : {}, message : {}",
                e, request.getRequestURI(), e.getMessage());
        return ApiResponse.toResponseEntity(LOGIN_FAILED, null);
    }

    @ExceptionHandler(AuthorizationDeniedException.class)
    public ResponseEntity<?> authorizationDenied(
            AuthorizationDeniedException e, HttpServletRequest request
    ) {
        log.error("errorCode : {}, uri : {}, message : {}",
                e, request.getRequestURI(), e.getMessage());
        return ApiResponse.toResponseEntity(UNAUTHORIZED, null);
    }

    @ExceptionHandler(ApiException.class)
    public ResponseEntity<?> apiException(
            ApiException e, HttpServletRequest request
    ) {
        log.error("errorCode : {}, uri : {}, message : {}",
                e, request.getRequestURI(), e.getMessage());

        return ApiResponse.toResponseEntity(e.getResponseCode(), null);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<?> exception(
            Exception e, HttpServletRequest request
    ) {
        log.error("errorCode : {}, uri : {}, message : {}",
                e, request.getRequestURI(), e.getMessage());

        return ApiResponse.toResponseEntity(INTERNAL_SERVER_ERROR, null);
    }
}
